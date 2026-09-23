import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import '../../core/errors/printer_exception.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/label_model.dart';
import '../../data/models/printer_model.dart';
import '../../data/repositories/label_repository.dart';
import 'drivers/printer_driver.dart';
import 'drivers/tspl_driver.dart';
import 'printer_service.dart';

/// Impressora térmica de etiquetas conectada por USB e instalada como
/// impressora comum do Windows (ex.: Elgin L42DT — ver escopo,
/// adaptação para rodar no PC). Em vez de Bluetooth
/// ([BluetoothThermalPrinterService]), os bytes já prontos do
/// [PrinterDriver] (TSPL) são enviados crus (`datatype "RAW"`)
/// diretamente pelo spooler de impressão do Windows — o mesmo caminho
/// usado por qualquer software de etiquetas nesse tipo de impressora,
/// sem depender de driver específico nem reconfigurar o USB.
class WindowsUsbPrinterService implements PrinterService {
  WindowsUsbPrinterService({
    required LabelRepository labelRepository,
    PrinterDriver driver = const TsplDriver(),
  })  : _labelRepository = labelRepository,
        _driver = driver;

  final LabelRepository _labelRepository;
  final PrinterDriver _driver;

  final _statusController = StreamController<PrinterConnectionStatus>.broadcast();
  PrinterConnectionStatus _status = PrinterConnectionStatus.desconectada;
  String? _printerName;

  @override
  Stream<PrinterConnectionStatus> get connectionStatusStream => _statusController.stream;

  @override
  PrinterConnectionStatus get currentStatus => _status;

  /// Nomes das impressoras instaladas no Windows (locais e conexões de
  /// rede já configuradas) — usado pela tela de configuração para o
  /// operador escolher qual usar, sem precisar digitar nada.
  static List<String> listPrinters() {
    const flags = PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS;
    final pcbNeeded = calloc<Uint32>();
    final pcReturned = calloc<Uint32>();
    try {
      EnumPrinters(flags, nullptr, 4, nullptr, 0, pcbNeeded, pcReturned);
      final bufferSize = pcbNeeded.value;
      if (bufferSize == 0) return const [];

      final buffer = calloc<Uint8>(bufferSize);
      try {
        final ok = EnumPrinters(flags, nullptr, 4, buffer, bufferSize, pcbNeeded, pcReturned);
        if (ok == 0) return const [];

        final infos = buffer.cast<PRINTER_INFO_4>();
        return List.generate(
          pcReturned.value,
          (i) => (infos + i).ref.pPrinterName.toDartString(),
        );
      } finally {
        calloc.free(buffer);
      }
    } finally {
      calloc.free(pcbNeeded);
      calloc.free(pcReturned);
    }
  }

  @override
  Future<void> connect(PrinterModel printer) async {
    _setStatus(PrinterConnectionStatus.conectando);
    try {
      final hPrinter = _openPrinter(printer.endereco);
      if (hPrinter == null) {
        throw PrinterConnectionException(
          'Impressora "${printer.endereco}" não encontrada no Windows.',
        );
      }
      ClosePrinter(hPrinter);

      _printerName = printer.endereco;
      _setStatus(PrinterConnectionStatus.conectada);
    } catch (e, st) {
      AppLogger.e('Falha ao conectar na impressora USB (Windows)', e, st);
      _setStatus(PrinterConnectionStatus.erro);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    _printerName = null;
    _setStatus(PrinterConnectionStatus.desconectada);
  }

  @override
  Future<void> printLabel(LabelPrintData data) async {
    final printerName = _printerName;
    if (printerName == null) {
      throw const PrinterNotConfiguredException();
    }

    final label = await _labelRepository.getDefault() ?? LabelModel.builtInDefault();
    final bytes = _driver.render(label, data);

    final hPrinter = _openPrinter(printerName);
    if (hPrinter == null) {
      _setStatus(PrinterConnectionStatus.erro);
      throw PrinterConnectionException('Impressora "$printerName" não encontrada no Windows.');
    }

    try {
      _sendRawBytes(hPrinter, bytes);
      _setStatus(PrinterConnectionStatus.conectada);
    } catch (e, st) {
      AppLogger.e('Falha ao enviar etiqueta para a impressora USB (Windows)', e, st);
      _setStatus(PrinterConnectionStatus.erro);
      throw const PrinterConnectionException('Falha ao enviar a etiqueta para a impressora.');
    } finally {
      ClosePrinter(hPrinter);
    }
  }

  /// Abre um handle para a impressora Windows `name`, ou `null` se ela
  /// não existir/não puder ser aberta (desligada não impede abrir o
  /// handle — só o spooler do Windows já resolve isso na hora de
  /// entregar o trabalho — mas uma impressora desinstalada, sim).
  int? _openPrinter(String name) {
    final namePtr = name.toNativeUtf16();
    final defaults = calloc<PRINTER_DEFAULTS>();
    final phPrinter = calloc<IntPtr>();
    try {
      defaults.ref.pDatatype = nullptr;
      defaults.ref.pDevMode = nullptr;
      defaults.ref.DesiredAccess = PRINTER_ACCESS_USE;

      final ok = OpenPrinter(namePtr, phPrinter, defaults);
      if (ok == 0) return null;
      return phPrinter.value;
    } finally {
      calloc.free(namePtr);
      calloc.free(defaults);
      calloc.free(phPrinter);
    }
  }

  /// Manda [bytes] crus para a impressora já aberta em [hPrinter],
  /// usando `datatype "RAW"` — o spooler do Windows repassa exatamente
  /// esses bytes para a impressora, sem reinterpretar/reformatar os
  /// comandos TSPL (ver [TsplDriver]).
  void _sendRawBytes(int hPrinter, List<int> bytes) {
    final docInfo = calloc<DOC_INFO_1>();
    final docNamePtr = 'Etiqueta de pesagem'.toNativeUtf16();
    final dataTypePtr = 'RAW'.toNativeUtf16();
    final buffer = calloc<Uint8>(bytes.length);
    final written = calloc<Uint32>();
    try {
      docInfo.ref.pDocName = docNamePtr;
      docInfo.ref.pOutputFile = nullptr;
      docInfo.ref.pDatatype = dataTypePtr;

      final jobId = StartDocPrinter(hPrinter, 1, docInfo);
      if (jobId == 0) {
        throw const PrinterConnectionException('Falha ao iniciar o trabalho de impressão.');
      }
      try {
        if (StartPagePrinter(hPrinter) == 0) {
          throw const PrinterConnectionException('Falha ao iniciar a página de impressão.');
        }
        buffer.asTypedList(bytes.length).setAll(0, bytes);
        final ok = WritePrinter(hPrinter, buffer.cast(), bytes.length, written);
        EndPagePrinter(hPrinter);
        if (ok == 0 || written.value != bytes.length) {
          throw const PrinterConnectionException('Falha ao enviar os dados para a impressora.');
        }
      } finally {
        EndDocPrinter(hPrinter);
      }
    } finally {
      calloc.free(docInfo);
      calloc.free(docNamePtr);
      calloc.free(dataTypePtr);
      calloc.free(buffer);
      calloc.free(written);
    }
  }

  void _setStatus(PrinterConnectionStatus status) {
    _status = status;
    _statusController.add(status);
  }

  @override
  void dispose() => _statusController.close();
}
