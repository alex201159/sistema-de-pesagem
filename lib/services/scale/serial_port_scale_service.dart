import 'dart:io' show Platform;

import 'linux_serial_scale_service.dart';
import 'scale_line_weight_parser.dart';
import 'scale_service.dart';
import 'serial_protocol.dart';
import 'windows_serial_scale_service.dart';

/// Ponto único de escolha da implementação de
/// [ScaleTransportType.serialPort] por sistema operacional — porta COM
/// no Windows ([WindowsSerialScaleService]) ou `/dev/tty*` no Linux
/// ([LinuxSerialScaleService], Orange Pi/Armbian).
class SerialPortScaleService {
  SerialPortScaleService._();

  static bool get isSupported => Platform.isWindows || Platform.isLinux;

  static ScaleService create({
    required SerialProtocol protocol,
    required ScaleLineWeightParser weightParser,
  }) {
    if (Platform.isLinux) {
      return LinuxSerialScaleService(protocol: protocol, weightParser: weightParser);
    }
    return WindowsSerialScaleService(protocol: protocol, weightParser: weightParser);
  }

  static Future<List<String>> listPorts() {
    if (Platform.isLinux) return LinuxSerialScaleService.listPorts();
    return WindowsSerialScaleService.listPorts();
  }
}
