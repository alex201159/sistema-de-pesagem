import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';

import '../../core/errors/scale_exception.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/scale_model.dart';
import 'scale_line_weight_parser.dart';
import 'scale_service.dart';
import 'serial_protocol.dart';

/// Balança comum conectada por cabo, através de um adaptador serial
/// USB-OTG (RS232-USB, chips FTDI/CP210x/PL2303/CH340 — ver escopo,
/// item 10). Fala diretamente com a balança: sem gateway intermediário
/// e sem o protocolo de comandos `ST*` (isso é específico do gateway
/// BLE em [BleGatewayScaleService]) — as linhas cruas da balança são
/// interpretadas diretamente por [ScaleLineWeightParser].
class UsbSerialScaleService implements ScaleService {
  UsbSerialScaleService({
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

  UsbPort? _port;
  StreamSubscription<Uint8List>? _dataSub;
  String _buffer = '';

  @override
  Stream<ScaleReading> get weightStream => _weightController.stream;

  @override
  Stream<ScaleConnectionStatus> get connectionStatusStream => _statusController.stream;

  @override
  Stream<String> get rawLineStream => _rawLineController.stream;

  @override
  ScaleConnectionStatus get currentStatus => _status;

  void updateWeightParser(ScaleLineWeightParser parser) => _weightParser = parser;

  /// Lista os adaptadores seriais USB conectados no momento — usado
  /// pela tela de configuração para o operador escolher qual usar.
  static Future<List<UsbDevice>> listDevices() => UsbSerial.listDevices();

  @override
  Future<void> connect(ScaleModel scale) async {
    _setStatus(ScaleConnectionStatus.conectando);
    try {
      final devices = await UsbSerial.listDevices();
      if (devices.isEmpty) {
        throw const ScaleNotConfiguredException(
          'Nenhum adaptador serial USB encontrado. Conecte o cabo e tente novamente.',
        );
      }

      UsbDevice? target;
      for (final device in devices) {
        if (device.deviceName == scale.endereco) {
          target = device;
          break;
        }
      }
      target ??= devices.first;

      final port = await target.create();
      if (port == null) {
        throw const ScaleException('Não foi possível abrir a porta serial USB.');
      }

      final opened = await port.open();
      if (!opened) {
        throw const ScaleException(
          'Falha ao abrir a porta serial USB (permissão de acesso negada?).',
        );
      }

      await port.setPortParameters(
        _protocol.baud,
        _protocol.dataBits == 7 ? UsbPort.DATABITS_7 : UsbPort.DATABITS_8,
        _protocol.stopBits == 2 ? UsbPort.STOPBITS_2 : UsbPort.STOPBITS_1,
        _protocol.parityCode,
      );

      _port = port;
      _buffer = '';
      await _dataSub?.cancel();
      _dataSub = port.inputStream?.listen(
        _onData,
        onError: (Object e, StackTrace st) {
          AppLogger.e('Erro na leitura serial USB da balança', e, st);
          _setStatus(ScaleConnectionStatus.erro);
        },
      );

      _setStatus(ScaleConnectionStatus.conectada);
    } catch (e, st) {
      AppLogger.e('Falha ao conectar na balança via USB serial', e, st);
      _setStatus(ScaleConnectionStatus.erro);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    await _dataSub?.cancel();
    _dataSub = null;
    try {
      await _port?.close();
    } catch (_) {}
    _port = null;
    _setStatus(ScaleConnectionStatus.semBalanca);
  }

  void _onData(Uint8List chunk) {
    _buffer += utf8.decode(chunk, allowMalformed: true);

    var newlineIndex = _buffer.indexOf('\n');
    while (newlineIndex >= 0) {
      final line = _buffer.substring(0, newlineIndex).trim();
      _buffer = _buffer.substring(newlineIndex + 1);
      if (line.isNotEmpty) {
        _rawLineController.add(line);
        final kg = _weightParser.extract(line);
        if (kg != null) {
          _weightController.add(ScaleReading(kg: kg, timestamp: DateTime.now()));
        }
      }
      newlineIndex = _buffer.indexOf('\n');
    }

    // Evita crescimento ilimitado do buffer caso a balança nunca envie
    // um terminador de linha reconhecido.
    if (_buffer.length > 256) {
      _buffer = _buffer.substring(_buffer.length - 256);
    }
  }

  void _setStatus(ScaleConnectionStatus status) {
    _status = status;
    _statusController.add(status);
  }

  @override
  void dispose() {
    _dataSub?.cancel();
    _weightController.close();
    _statusController.close();
    _rawLineController.close();
  }
}
