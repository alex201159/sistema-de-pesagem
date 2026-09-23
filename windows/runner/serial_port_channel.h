#ifndef RUNNER_SERIAL_PORT_CHANNEL_H_
#define RUNNER_SERIAL_PORT_CHANNEL_H_

#include <windows.h>

namespace flutter {
class FlutterEngine;
}  // namespace flutter

void RegisterSerialPortChannels(flutter::FlutterEngine* engine, HWND hwnd);
bool HandleSerialPortWindowMessage(UINT message, WPARAM wparam, LPARAM lparam);

#endif  // RUNNER_SERIAL_PORT_CHANNEL_H_
