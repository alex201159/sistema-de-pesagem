import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/constants/bluetooth_constants.dart';
import '../../core/errors/scale_exception.dart';

/// Descoberta de gateways BLE próximos, usada pela tela de
/// configuração da balança (ver escopo, item 10) — separada de
/// [BleGatewayScaleService] porque "escanear" é uma operação de
/// descoberta, não de uma balança já conhecida/configurada.
class BleScaleScanner {
  BleScaleScanner._();

  static Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  static Future<bool> requestPermissions() async {
    // Desktop (Linux/BlueZ, Windows) não tem permissão de runtime —
    // e o permission_handler nem tem implementação no Linux.
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return true;
    }

    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    final bluetoothOk = (statuses[Permission.bluetoothScan]?.isGranted ?? false) &&
        (statuses[Permission.bluetoothConnect]?.isGranted ?? false);
    final locationOk = statuses[Permission.location]?.isGranted ?? false;
    return bluetoothOk || locationOk;
  }

  static Future<void> startScan({Duration timeout = BluetoothConstants.scanTimeout}) async {
    final granted = await requestPermissions();
    if (!granted) {
      throw const ScaleException('Permissão de Bluetooth/Localização negada.');
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        await FlutterBluePlus.turnOn();
      } catch (_) {
        // Usuário pode recusar ligar o Bluetooth pelo diálogo do sistema;
        // o scan seguinte simplesmente não encontrará nada.
      }
    }

    await FlutterBluePlus.stopScan();
    await FlutterBluePlus.startScan(
      timeout: timeout,
      continuousUpdates: true,
      androidScanMode: AndroidScanMode.lowLatency,
      androidCheckLocationServices: false,
    );
  }

  static Future<void> stopScan() => FlutterBluePlus.stopScan();
}
