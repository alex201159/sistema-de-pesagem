import 'dart:async';

import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../core/errors/printer_exception.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/label_model.dart';
import '../../data/models/printer_model.dart';
import '../../data/repositories/label_repository.dart';
import 'drivers/printer_driver.dart';
import 'drivers/tspl_driver.dart';
import 'printer_service.dart';

/// Impressora térmica conectada via Bluetooth Classic (perfil SPP —
/// ver escopo, item 27). O protocolo de comandos fica isolado no
/// [PrinterDriver] injetado (hoje só [TsplDriver] está implementado —
/// não há impressora ESC/POS em uso — ver escopo, item 29), nunca
/// misturado com a lógica de transporte Bluetooth aqui.
class BluetoothThermalPrinterService implements PrinterService {
  BluetoothThermalPrinterService({
    required LabelRepository labelRepository,
    PrinterDriver driver = const TsplDriver(),
  })  : _labelRepository = labelRepository,
        _driver = driver;

  final LabelRepository _labelRepository;
  final PrinterDriver _driver;

  final _statusController = StreamController<PrinterConnectionStatus>.broadcast();
  PrinterConnectionStatus _status = PrinterConnectionStatus.desconectada;
  String? _macAddress;

  @override
  Stream<PrinterConnectionStatus> get connectionStatusStream => _statusController.stream;

  @override
  PrinterConnectionStatus get currentStatus => _status;

  @override
  Future<void> connect(PrinterModel printer) async {
    _setStatus(PrinterConnectionStatus.conectando);
    try {
      final enabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!enabled) {
        throw const PrinterConnectionException('Bluetooth desligado.');
      }

      final connected =
          await PrintBluetoothThermal.connect(macPrinterAddress: printer.endereco);
      if (!connected) {
        throw const PrinterConnectionException('Falha ao conectar na impressora.');
      }

      _macAddress = printer.endereco;
      _setStatus(PrinterConnectionStatus.conectada);
    } catch (e, st) {
      AppLogger.e('Falha ao conectar na impressora Bluetooth', e, st);
      _setStatus(PrinterConnectionStatus.erro);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await PrintBluetoothThermal.disconnect;
    } catch (_) {}
    _macAddress = null;
    _setStatus(PrinterConnectionStatus.desconectada);
  }

  @override
  Future<void> printLabel(LabelPrintData data) async {
    final macAddress = _macAddress;
    if (macAddress == null) {
      throw const PrinterNotConfiguredException();
    }

    final connected = await PrintBluetoothThermal.connectionStatus;
    if (!connected) {
      // Reconecta ao endereço salvo antes de imprimir — a operação de
      // pesagem não pode se perder por uma desconexão momentânea
      // (ver escopo, itens 31 e 44).
      final reconnected = await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
      if (!reconnected) {
        _setStatus(PrinterConnectionStatus.erro);
        throw const PrinterConnectionException(
          'Impressora desconectada e não foi possível reconectar.',
        );
      }
    }
    _setStatus(PrinterConnectionStatus.conectada);

    final label = await _labelRepository.getDefault() ?? LabelModel.builtInDefault();
    final bytes = _driver.render(label, data);

    final sent = await PrintBluetoothThermal.writeBytes(bytes);
    if (!sent) {
      throw const PrinterConnectionException('Falha ao enviar a etiqueta para a impressora.');
    }
  }

  void _setStatus(PrinterConnectionStatus status) {
    _status = status;
    _statusController.add(status);
  }

  @override
  void dispose() => _statusController.close();
}
