import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../core/constants/bluetooth_constants.dart';
import '../../core/errors/scale_exception.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/scale_model.dart';
import 'ble_scale_scanner.dart';
import 'scale_line_weight_parser.dart';
import 'scale_service.dart';
import 'serial_protocol.dart';

/// Balança comum conectada através de um gateway BLE (ESP32, perfil
/// UART Nordic) que faz a ponte com a serial da balança (ver escopo,
/// item 10 — "ESP32 BLE").
///
/// Protocolo do gateway (firmware já validado em campo, reaproveitado
/// tal qual): `STCFG:baud:paridade:stopBits:dataBits` configura a
/// serial, `STSTART`/`STSTOP` liga/desliga o envio contínuo de
/// leituras, cada leitura chega como uma linha `ST|<conteúdo cru>`
/// (interpretada por [ScaleLineWeightParser]), e `STASCAN`/`STCANCEL`
/// disparam/cancelam a busca automática de protocolo no firmware
/// (respostas `STSCANNING:`/`STOK:`/`STFAIL`).
class BleGatewayScaleService implements ScaleService {
  BleGatewayScaleService({
    SerialProtocol protocol = SerialProtocol.defaultProtocol,
    ScaleLineWeightParser weightParser = const ScaleLineWeightParser(),
  })  : _protocol = protocol,
        _weightParser = weightParser;

  final SerialProtocol _protocol;
  ScaleLineWeightParser _weightParser;

  final _weightController = StreamController<ScaleReading>.broadcast();
  final _statusController = StreamController<ScaleConnectionStatus>.broadcast();
  final _rawLineController = StreamController<String>.broadcast();
  ScaleConnectionStatus _status = ScaleConnectionStatus.semBalanca;

  BluetoothDevice? _device;
  BluetoothCharacteristic? _writeCharacteristic;
  StreamSubscription<List<int>>? _notifySub;
  StreamSubscription<BluetoothConnectionState>? _connSub;

  @override
  Stream<ScaleReading> get weightStream => _weightController.stream;

  @override
  Stream<ScaleConnectionStatus> get connectionStatusStream => _statusController.stream;

  @override
  Stream<String> get rawLineStream => _rawLineController.stream;

  @override
  ScaleConnectionStatus get currentStatus => _status;

  /// Ajusta protocolo serial/recorte do peso sem precisar reconectar
  /// (ex.: operador calibrando a extração com a balança já ligada).
  /// Reenviar a configuração ao gateway exige reconectar — o ajuste ao
  /// vivo aqui vale apenas para a interpretação das linhas já em fluxo.
  void updateWeightParser(ScaleLineWeightParser parser) => _weightParser = parser;

  @override
  Future<void> connect(ScaleModel scale) async {
    _setStatus(ScaleConnectionStatus.conectando);
    try {
      final granted = await BleScaleScanner.requestPermissions();
      if (!granted) {
        throw const ScaleException('Permissão de Bluetooth/Localização negada.');
      }

      await BleScaleScanner.stopScan();
      final device = BluetoothDevice.fromId(scale.endereco);
      await device.connect(timeout: BluetoothConstants.connectTimeout);
      _device = device;

      await _discoverUart(device);
      _monitorConnection(device);

      await _sendCommand(_protocol.gatewayConfigCommand);
      await Future.delayed(const Duration(milliseconds: 80));
      await _sendCommand('STSTART');

      _setStatus(ScaleConnectionStatus.conectada);
    } catch (e, st) {
      AppLogger.e('Falha ao conectar na balança (gateway BLE)', e, st);
      _setStatus(ScaleConnectionStatus.erro);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    await _notifySub?.cancel();
    await _connSub?.cancel();
    try {
      await _device?.disconnect();
    } catch (_) {}
    _device = null;
    _writeCharacteristic = null;
    _setStatus(ScaleConnectionStatus.semBalanca);
  }

  Future<void> _discoverUart(BluetoothDevice device) async {
    final services = await device.discoverServices();
    final serviceUuid = Guid(BluetoothConstants.uartServiceUuid);
    final txUuid = Guid(BluetoothConstants.uartTxCharacteristic);
    final rxUuid = Guid(BluetoothConstants.uartRxCharacteristic);

    BluetoothCharacteristic? notifyCharacteristic;
    BluetoothCharacteristic? writeCharacteristic;
    for (final service in services) {
      if (service.uuid != serviceUuid) continue;
      for (final characteristic in service.characteristics) {
        if (characteristic.uuid == txUuid) notifyCharacteristic = characteristic;
        if (characteristic.uuid == rxUuid) writeCharacteristic = characteristic;
      }
    }

    if (notifyCharacteristic == null || writeCharacteristic == null) {
      throw const ScaleProtocolException(
        'Serviço UART BLE do gateway da balança não encontrado.',
      );
    }

    _writeCharacteristic = writeCharacteristic;
    await notifyCharacteristic.setNotifyValue(true);
    await _notifySub?.cancel();
    _notifySub = notifyCharacteristic.lastValueStream.listen(_onNotify);
  }

  void _onNotify(List<int> value) {
    final decoded = utf8.decode(value, allowMalformed: true);
    for (final raw in decoded.split(RegExp(r'\r?\n'))) {
      final line = raw.trim();
      if (!line.startsWith('ST|')) continue;

      final content = line.substring(3).trim();
      _rawLineController.add(content);
      final kg = _weightParser.extract(content);
      if (kg != null) {
        _weightController.add(ScaleReading(kg: kg, timestamp: DateTime.now()));
      }
    }
  }

  void _monitorConnection(BluetoothDevice device) {
    _connSub?.cancel();
    _connSub = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected && _device?.remoteId == device.remoteId) {
        _device = null;
        _writeCharacteristic = null;
        _setStatus(ScaleConnectionStatus.semBalanca);
      }
    });
  }

  Future<void> _sendCommand(String command) async {
    final characteristic = _writeCharacteristic;
    if (characteristic == null) {
      throw const ScaleException('Característica de escrita BLE indisponível.');
    }
    await characteristic.write(utf8.encode(command), withoutResponse: false);
  }

  void _setStatus(ScaleConnectionStatus status) {
    _status = status;
    _statusController.add(status);
  }

  @override
  void dispose() {
    _notifySub?.cancel();
    _connSub?.cancel();
    _weightController.close();
    _statusController.close();
    _rawLineController.close();
  }
}
