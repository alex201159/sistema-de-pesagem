#include "serial_port_channel.h"

#include <flutter/encodable_value.h>
#include <flutter/event_channel.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/flutter_engine.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

#include <windows.h>

#include <algorithm>
#include <atomic>
#include <memory>
#include <mutex>
#include <optional>
#include <string>
#include <thread>
#include <utility>
#include <variant>
#include <vector>

// Canal de porta serial nativo (Win32 puro: CreateFile/SetCommState/ReadFile
// numa thread própria), portado do app "lccarga" (C:\lccarga\windows\runner)
// depois que a implementação anterior baseada em `flutter_libserialport`
// (chamadas FFI síncronas direto na isolate da UI) travava o app inteiro com
// adaptadores USB-serial instáveis (clones do chip CH340) — abrir/configurar/
// ler a porta aqui roda numa thread nativa separada, então mesmo que o driver
// trave, só essa thread fica presa; a UI do Flutter nunca é bloqueada.

namespace {

constexpr char kSerialMethodChannelName[] = "pesagem_totem_serial";
constexpr char kSerialStreamChannelName[] = "pesagem_totem_serial_stream";
constexpr UINT kSerialPortMessage = WM_APP + 174;

enum class SerialEventType { kLine, kError };

struct SerialEvent {
  SerialEventType type = SerialEventType::kLine;
  std::string payload;
  std::string error_code;
};

std::string WideToUtf8(const std::wstring& wstr) {
  if (wstr.empty()) {
    return {};
  }
  const int required = WideCharToMultiByte(
      CP_UTF8, 0, wstr.c_str(), -1, nullptr, 0, nullptr, nullptr);
  if (required <= 0) {
    return {};
  }
  std::string utf8;
  utf8.resize(required);
  WideCharToMultiByte(
      CP_UTF8, 0, wstr.c_str(), -1, utf8.data(), required, nullptr, nullptr);
  if (!utf8.empty() && utf8.back() == '\0') {
    utf8.pop_back();
  }
  return utf8;
}

std::wstring Utf8ToWide(const std::string& utf8) {
  if (utf8.empty()) {
    return {};
  }
  const int required = MultiByteToWideChar(
      CP_UTF8, 0, utf8.c_str(), -1, nullptr, 0);
  if (required <= 0) {
    return {};
  }
  std::wstring result(static_cast<size_t>(required), L'\0');
  MultiByteToWideChar(
      CP_UTF8, 0, utf8.c_str(), -1, result.data(), required);
  if (!result.empty() && result.back() == L'\0') {
    result.pop_back();
  }
  return result;
}

std::optional<std::string> ExtractString(
    const flutter::EncodableMap& map,
    const std::string& key) {
  const auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) {
    return std::nullopt;
  }
  if (const auto* string_value = std::get_if<std::string>(&it->second)) {
    return *string_value;
  }
  return std::nullopt;
}

std::optional<int> ExtractInteger(
    const flutter::EncodableMap& map,
    const std::string& key) {
  const auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) {
    return std::nullopt;
  }
  if (const auto* int_value = std::get_if<int>(&it->second)) {
    return *int_value;
  }
  if (const auto* double_value = std::get_if<double>(&it->second)) {
    return static_cast<int>(*double_value);
  }
  if (const auto* string_value = std::get_if<std::string>(&it->second)) {
    try {
      return std::stoi(*string_value);
    } catch (...) {
      return std::nullopt;
    }
  }
  return std::nullopt;
}

struct SerialMonitorContext {
  HANDLE handle = INVALID_HANDLE_VALUE;
  std::unique_ptr<std::thread> worker;
  std::atomic<bool> running{false};
  std::string buffer;
  std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> sink;
  // -1 significa o comportamento padrão (corta em '\r' ou '\n'). Caso
  // contrário é o byte único que marca fim de quadro, para balanças que
  // transmitem quadros de tamanho fixo continuamente sem CR/LF.
  int terminator = -1;
};

SerialMonitorContext g_serial_monitor_context;
std::mutex g_serial_monitor_mutex;
HWND g_serial_hwnd = nullptr;

void CleanupSerialMonitor(bool notify_end) {
  g_serial_monitor_context.running.store(false);
  if (g_serial_monitor_context.handle != INVALID_HANDLE_VALUE) {
    CancelIoEx(g_serial_monitor_context.handle, nullptr);
  }
  if (g_serial_monitor_context.worker &&
      g_serial_monitor_context.worker->joinable()) {
    g_serial_monitor_context.worker->join();
  }
  if (g_serial_monitor_context.handle != INVALID_HANDLE_VALUE) {
    CloseHandle(g_serial_monitor_context.handle);
    g_serial_monitor_context.handle = INVALID_HANDLE_VALUE;
  }
  if (notify_end && g_serial_monitor_context.sink) {
    g_serial_monitor_context.sink->EndOfStream();
  }
  g_serial_monitor_context.sink.reset();
  g_serial_monitor_context.buffer.clear();
  g_serial_monitor_context.worker.reset();
}

bool PostSerialEvent(std::unique_ptr<SerialEvent> event) {
  if (!g_serial_hwnd || !event) {
    return false;
  }
  if (!PostMessage(
          g_serial_hwnd,
          kSerialPortMessage,
          reinterpret_cast<WPARAM>(event.get()),
          0)) {
    return false;
  }
  event.release();
  return true;
}

// Bytes crus da balança não são UTF-8 válido (bytes de controle/status podem
// ser qualquer coisa 0x00-0xFF), mas o canal da plataforma transmite strings
// como UTF-8. Codificar cada byte cru como seu codepoint Latin-1 mantém todo
// valor de byte representável sem perdas, em vez de ser descartado
// silenciosamente pelo codec.
std::string Latin1ToUtf8(const std::string& input) {
  std::string output;
  output.reserve(input.size());
  for (unsigned char byte : input) {
    if (byte < 0x80) {
      output.push_back(static_cast<char>(byte));
    } else {
      output.push_back(static_cast<char>(0xC0 | (byte >> 6)));
      output.push_back(static_cast<char>(0x80 | (byte & 0x3F)));
    }
  }
  return output;
}

void PostLineEvent(std::string line) {
  if (!line.empty() && line.back() == '\r') {
    line.pop_back();
  }
  if (line.empty()) {
    return;
  }
  auto event = std::make_unique<SerialEvent>();
  event->type = SerialEventType::kLine;
  event->payload = Latin1ToUtf8(line);
  PostSerialEvent(std::move(event));
}

void FlushDelimitedBuffer(SerialMonitorContext* context) {
  if (!context) {
    return;
  }
  const bool custom_terminator = context->terminator >= 0;
  const char terminator_byte =
      custom_terminator ? static_cast<char>(context->terminator) : '\0';
  constexpr size_t kDiagnosticOverflowThreshold = 512;
  while (!context->buffer.empty()) {
    const auto separator = std::find_if(
        context->buffer.begin(), context->buffer.end(),
        [custom_terminator, terminator_byte](char value) {
          if (custom_terminator) {
            return value == terminator_byte;
          }
          return value == '\r' || value == '\n';
        });
    if (separator == context->buffer.end()) {
      if (context->buffer.size() >= kDiagnosticOverflowThreshold) {
        // Terminador nunca bateu e o buffer só cresceu: mostra o que
        // realmente chegou pra um terminador mal configurado ficar visível
        // no log em vez de travar silenciosamente.
        std::string overflow = std::move(context->buffer);
        context->buffer.clear();
        PostLineEvent("[sem terminador encontrado] " + overflow);
      }
      return;
    }
    const size_t separator_index =
        static_cast<size_t>(separator - context->buffer.begin());
    std::string line = context->buffer.substr(0, separator_index);
    size_t erase_count = separator_index + 1;
    if (!custom_terminator && *separator == '\r' &&
        erase_count < context->buffer.size() &&
        context->buffer[erase_count] == '\n') {
      ++erase_count;
    }
    context->buffer.erase(0, erase_count);
    PostLineEvent(std::move(line));
  }
}

void FlushBufferedFrame(SerialMonitorContext* context) {
  if (!context || context->buffer.empty()) {
    return;
  }
  std::string frame = std::move(context->buffer);
  context->buffer.clear();
  PostLineEvent(std::move(frame));
}

std::vector<std::string> EnumerateSerialPortsFromRegistry() {
  std::vector<std::string> ports;
  HKEY key = nullptr;
  if (RegOpenKeyExW(HKEY_LOCAL_MACHINE,
                    L"HARDWARE\\DEVICEMAP\\SERIALCOMM",
                    0,
                    KEY_READ,
                    &key) != ERROR_SUCCESS) {
    return ports;
  }

  DWORD value_count = 0;
  DWORD max_value_name_len = 0;
  DWORD max_value_len = 0;
  if (RegQueryInfoKeyW(key,
                       nullptr,
                       nullptr,
                       nullptr,
                       nullptr,
                       nullptr,
                       nullptr,
                       &value_count,
                       &max_value_name_len,
                       &max_value_len,
                       nullptr,
                       nullptr) == ERROR_SUCCESS &&
      value_count > 0) {
    auto value_name = std::make_unique<wchar_t[]>(max_value_name_len + 1);
    auto data_buffer = std::make_unique<BYTE[]>(max_value_len + 1);

    for (DWORD index = 0; index < value_count; ++index) {
      DWORD name_length = max_value_name_len + 1;
      DWORD data_length = max_value_len + 1;
      DWORD type = 0;
      const auto result = RegEnumValueW(key,
                                        index,
                                        value_name.get(),
                                        &name_length,
                                        nullptr,
                                        &type,
                                        data_buffer.get(),
                                        &data_length);
      if (result != ERROR_SUCCESS || type != REG_SZ || data_length < sizeof(wchar_t)) {
        continue;
      }

      const auto* data_str = reinterpret_cast<const wchar_t*>(data_buffer.get());
      const auto wchar_count = data_length / sizeof(wchar_t);
      if (wchar_count == 0) {
        continue;
      }
      auto raw = std::wstring(data_str, wchar_count);
      if (!raw.empty() && raw.back() == L'\0') {
        raw.pop_back();
      }
      if (raw.empty()) {
        continue;
      }
      ports.push_back(WideToUtf8(raw));
    }
  }

  RegCloseKey(key);
  return ports;
}

std::unique_ptr<
    flutter::MethodChannel<flutter::EncodableValue>> g_serial_method_channel;

std::unique_ptr<
    flutter::EventChannel<flutter::EncodableValue>> g_serial_event_channel;

}  // namespace

void RegisterSerialPortChannels(flutter::FlutterEngine* engine, HWND hwnd) {
  if (engine == nullptr || g_serial_method_channel != nullptr) {
    return;
  }

  g_serial_hwnd = hwnd;
  auto messenger = engine->messenger();

  g_serial_method_channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          messenger,
          kSerialMethodChannelName,
          &flutter::StandardMethodCodec::GetInstance());
  g_serial_method_channel->SetMethodCallHandler(
      [](const flutter::MethodCall<flutter::EncodableValue>& call,
         std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        if (call.method_name().compare("listSerialPorts") == 0) {
          const auto ports = EnumerateSerialPortsFromRegistry();
          std::vector<flutter::EncodableValue> encoded_ports;
          encoded_ports.reserve(ports.size());
          for (const auto& port : ports) {
            encoded_ports.emplace_back(port);
          }
          result->Success(flutter::EncodableValue(std::move(encoded_ports)));
          return;
        }
        if (call.method_name().compare("resetSerialMonitor") == 0) {
          std::lock_guard<std::mutex> guard(g_serial_monitor_mutex);
          CleanupSerialMonitor(false);
          result->Success(flutter::EncodableValue(true));
          return;
        }
        result->NotImplemented();
      });

  g_serial_event_channel =
      std::make_unique<flutter::EventChannel<flutter::EncodableValue>>(
          messenger,
          kSerialStreamChannelName,
          &flutter::StandardMethodCodec::GetInstance());
  g_serial_event_channel->SetStreamHandler(
      std::make_unique<
          flutter::StreamHandlerFunctions<flutter::EncodableValue>>(
          [](const flutter::EncodableValue* arguments,
             std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&& events)
              -> std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> {
            if (!events) {
              return std::make_unique<flutter::StreamHandlerError<flutter::EncodableValue>>(
                  "invalid_sink", "Falha interna ao iniciar o monitor.", nullptr);
            }
            std::lock_guard<std::mutex> guard(g_serial_monitor_mutex);
            CleanupSerialMonitor(true);

            const auto* args_map =
                arguments ? std::get_if<flutter::EncodableMap>(arguments) : nullptr;
            if (!args_map) {
              return std::make_unique<flutter::StreamHandlerError<flutter::EncodableValue>>(
                  "missing_args", "Argumentos de configuração ausentes.", nullptr);
            }

            auto port = ExtractString(*args_map, "port");
            if (!port) {
              return std::make_unique<flutter::StreamHandlerError<flutter::EncodableValue>>(
                  "missing_port", "A porta serial não foi informada.", nullptr);
            }

            const int baud_rate =
                ExtractInteger(*args_map, "baudRate").value_or(9600);
            const std::string parity_label =
                ExtractString(*args_map, "parity").value_or("none");
            const int data_bits =
                ExtractInteger(*args_map, "dataBits").value_or(8);
            const int stop_bits =
                ExtractInteger(*args_map, "stopBits").value_or(1);
            const int timeout_ms =
                std::max(1, ExtractInteger(*args_map, "timeoutMs").value_or(500));
            const int frame_terminator_code =
                ExtractInteger(*args_map, "frameTerminatorCode").value_or(-1);

            std::wstring port_path = Utf8ToWide(*port);
            if (!port_path.empty() &&
                port_path.rfind(L"\\\\.\\", 0) != 0) {
              port_path = L"\\\\.\\" + port_path;
            }
            if (port_path.empty()) {
              return std::make_unique<flutter::StreamHandlerError<flutter::EncodableValue>>(
                  "invalid_port_path", "Nome da porta serial inválido.", nullptr);
            }

            const HANDLE handle = CreateFileW(
                port_path.c_str(),
                GENERIC_READ | GENERIC_WRITE,
                0,
                nullptr,
                OPEN_EXISTING,
                FILE_ATTRIBUTE_NORMAL,
                nullptr);
            if (handle == INVALID_HANDLE_VALUE) {
              const DWORD last = GetLastError();
              return std::make_unique<flutter::StreamHandlerError<flutter::EncodableValue>>(
                  "open_failed",
                  "Falha ao abrir " + *port + " (Erro " + std::to_string(last) + ").",
                  nullptr);
            }

            DCB dcb = {};
            dcb.DCBlength = sizeof(DCB);
            if (!GetCommState(handle, &dcb)) {
              const DWORD last = GetLastError();
              CloseHandle(handle);
              return std::make_unique<flutter::StreamHandlerError<flutter::EncodableValue>>(
                  "state_read_failed",
                  "Não foi possível ler o estado da porta serial: " +
                      std::to_string(last),
                  nullptr);
            }

            dcb.BaudRate = static_cast<DWORD>(baud_rate);
            dcb.ByteSize = static_cast<BYTE>(
                std::clamp(data_bits, 5, 8));
            if (parity_label == "even") {
              dcb.Parity = EVENPARITY;
              dcb.fParity = TRUE;
            } else if (parity_label == "odd") {
              dcb.Parity = ODDPARITY;
              dcb.fParity = TRUE;
            } else {
              dcb.Parity = NOPARITY;
              dcb.fParity = FALSE;
            }
            dcb.StopBits = stop_bits >= 2 ? TWOSTOPBITS : ONESTOPBIT;
            dcb.fBinary          = TRUE;
            dcb.fOutxCtsFlow     = FALSE;
            dcb.fOutxDsrFlow     = FALSE;
            dcb.fDtrControl      = DTR_CONTROL_ENABLE;
            dcb.fDsrSensitivity  = FALSE;
            dcb.fTXContinueOnXoff = FALSE;
            dcb.fOutX            = FALSE;
            dcb.fInX             = FALSE;
            dcb.fErrorChar       = FALSE;
            dcb.fNull            = FALSE;
            dcb.fRtsControl      = RTS_CONTROL_ENABLE;
            dcb.fAbortOnError    = FALSE;

            if (!SetCommState(handle, &dcb)) {
              const DWORD last = GetLastError();
              CloseHandle(handle);
              return std::make_unique<flutter::StreamHandlerError<flutter::EncodableValue>>(
                  "state_write_failed",
                  "Não foi possível configurar a porta serial: " +
                      std::to_string(last),
                  nullptr);
            }

            COMMTIMEOUTS timeouts = {};
            timeouts.ReadIntervalTimeout = timeout_ms;
            timeouts.ReadTotalTimeoutMultiplier = 0;
            timeouts.ReadTotalTimeoutConstant = timeout_ms;
            if (!SetCommTimeouts(handle, &timeouts)) {
              const DWORD last = GetLastError();
              CloseHandle(handle);
              return std::make_unique<flutter::StreamHandlerError<flutter::EncodableValue>>(
                  "timeout_failed",
                  "Não foi possível configurar o timeout serial: " +
                      std::to_string(last),
                  nullptr);
            }

            PurgeComm(handle, PURGE_RXCLEAR | PURGE_TXCLEAR);

            g_serial_monitor_context.handle = handle;
            g_serial_monitor_context.running.store(true);
            g_serial_monitor_context.buffer.clear();
            g_serial_monitor_context.terminator = frame_terminator_code;
            g_serial_monitor_context.sink = std::move(events);

            auto* context = &g_serial_monitor_context;
            context->worker = std::make_unique<std::thread>([context]() {
              constexpr size_t kTempBufferSize = 256;
              char temp_buffer[kTempBufferSize];
              while (context->running.load()) {
                DWORD bytes_read = 0;
                const BOOL success = ReadFile(
                    context->handle,
                    temp_buffer,
                    static_cast<DWORD>(kTempBufferSize),
                    &bytes_read,
                    nullptr);
                if (!success) {
                  const DWORD last = GetLastError();
                  if (last == ERROR_OPERATION_ABORTED ||
                      last == ERROR_IO_PENDING ||
                      !context->running.load()) {
                    break;
                  }
                  auto event = std::make_unique<SerialEvent>();
                  event->type = SerialEventType::kError;
                  event->error_code = "read_error";
                  event->payload =
                      "Erro ao ler os dados da porta serial: " +
                      std::to_string(last);
                  PostSerialEvent(std::move(event));
                  context->running.store(false);
                  break;
                }
                if (bytes_read == 0) {
                  FlushBufferedFrame(context);
                  continue;
                }
                context->buffer.append(temp_buffer, bytes_read);
                FlushDelimitedBuffer(context);
              }
              FlushBufferedFrame(context);
              context->running.store(false);
            });

            return nullptr;
          },
          [](const flutter::EncodableValue*)
              -> std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> {
            std::lock_guard<std::mutex> guard(g_serial_monitor_mutex);
            CleanupSerialMonitor(true);
            return nullptr;
          }));
}

bool HandleSerialPortWindowMessage(UINT message, WPARAM wparam, LPARAM) {
  if (message != kSerialPortMessage) {
    return false;
  }
  std::unique_ptr<SerialEvent> event(
      reinterpret_cast<SerialEvent*>(wparam));
  if (!event) {
    return true;
  }
  std::lock_guard<std::mutex> guard(g_serial_monitor_mutex);
  if (!g_serial_monitor_context.sink) {
    return true;
  }
  if (event->type == SerialEventType::kLine) {
    g_serial_monitor_context.sink->Success(
        flutter::EncodableValue(std::move(event->payload)));
    return true;
  }
  if (event->type == SerialEventType::kError) {
    g_serial_monitor_context.sink->Error(
        event->error_code, event->payload, nullptr);
    return true;
  }
  return true;
}
