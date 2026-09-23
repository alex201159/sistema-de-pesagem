import 'dart:async';

import 'package:flutter/services.dart';

import '../../core/errors/scale_exception.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/scale_model.dart';
import 'scale_line_weight_parser.dart';
import 'scale_service.dart';
import 'serial_protocol.dart';

/// Balança comum conectada a uma porta serial real do PC (COM1, COM2...
/// — ver escopo, item 10, adaptação para rodar no Windows).
///
/// Fala com um canal nativo Win32 puro (`windows/runner/
/// serial_port_channel.cpp`, portado do app irmão `lccarga` — já
/// validado em campo com o mesmo tipo de adaptador USB-serial
/// instável) em vez de abrir a porta via FFI direto na isolate do
/// Flutter: abrir/configurar/ler a porta roda numa thread nativa
/// separada, então um driver travado prende só aquela thread, nunca a
/// interface do app (a tentativa anterior, com `flutter_libserialport`,
/// travava o app inteiro com adaptadores CH340 problemáticos).
class WindowsSerialScaleService implements ScaleService {
  WindowsSerialScaleService({
    SerialProtocol protocol = SerialProtocol.defaultProtocol,
    ScaleLineWeightParser weightParser = const ScaleLineWeightParser(),
  })  : _protocol = protocol,
        _weightParser = weightParser;

  static const _methodChannel = MethodChannel('pesagem_totem_serial');
  static const _eventChannel = EventChannel('pesagem_totem_serial_stream');

  final SerialProtocol _protocol;
  ScaleLineWeightParser _weightParser;

  final _weightController = StreamController<ScaleReading>.broadcast();
  final _statusController = StreamController<ScaleConnectionStatus>.broadcast();
  final _rawLineController = StreamController<String>.broadcast();
  ScaleConnectionStatus _status = ScaleConnectionStatus.semBalanca;

  StreamSubscription<dynamic>? _sub;

  @override
  Stream<ScaleReading> get weightStream => _weightController.stream;

  @override
  Stream<ScaleConnectionStatus> get connectionStatusStream => _statusController.stream;

  @override
  Stream<String> get rawLineStream => _rawLineController.stream;

  @override
  ScaleConnectionStatus get currentStatus => _status;

  void updateWeightParser(ScaleLineWeightParser parser) => _weightParser = parser;

  /// Lista as portas seriais disponíveis no PC (ex.: `COM3`), lidas do
  /// registro do Windows pelo lado nativo — usado pela tela de
  /// configuração para o operador escolher qual usar.
  static Future<List<String>> listPorts() async {
    try {
      final result = await _methodChannel.invokeMethod<List<Object?>>('listSerialPorts');
      return result?.whereType<String>().toList() ?? const [];
    } on PlatformException catch (e, st) {
      AppLogger.e('Falha ao listar portas seriais', e, st);
      return const [];
    } on MissingPluginException {
      return const [];
    }
  }

  @override
  Future<void> connect(ScaleModel scale) async {
    _setStatus(ScaleConnectionStatus.conectando);
    await _sub?.cancel();
    try {
      await _methodChannel.invokeMethod('resetSerialMonitor');
    } catch (_) {}

    final parityLabel = switch (_protocol.parity) {
      'E' => 'even',
      'O' => 'odd',
      _ => 'none',
    };

    final completer = Completer<void>();
    var settled = false;
    void settle(FutureOr<void> Function() action) {
      if (settled) return;
      settled = true;
      action();
    }

    _sub = _eventChannel.receiveBroadcastStream(<String, Object>{
      'port': scale.endereco,
      'baudRate': _protocol.baud,
      'parity': parityLabel,
      'dataBits': _protocol.dataBits,
      'stopBits': _protocol.stopBits,
      'timeoutMs': 500,
    }).listen(
      (event) {
        settle(() {
          _setStatus(ScaleConnectionStatus.conectada);
          completer.complete();
        });
        final line = event?.toString() ?? '';
        if (line.isEmpty) return;
        _rawLineController.add(line);
        final kg = _weightParser.extract(line);
        if (kg != null) {
          _weightController.add(ScaleReading(kg: kg, timestamp: DateTime.now()));
        }
      },
      onError: (Object e, StackTrace st) {
        AppLogger.e('Erro na porta serial da balança', e, st);
        _setStatus(ScaleConnectionStatus.erro);
        settle(() => completer.completeError(
              ScaleException('Falha ao conectar na porta ${scale.endereco}: $e'),
            ));
      },
      onDone: () {
        if (_status != ScaleConnectionStatus.erro) {
          _setStatus(ScaleConnectionStatus.semBalanca);
        }
      },
    );

    // O lado nativo abre/configura a porta de forma síncrona dentro do
    // `onListen` do canal — uma falha imediata (porta ocupada, não
    // existe) chega como erro do stream quase na hora. Uma folga curta
    // deixa esse erro imediato virar uma falha visível em [connect] em
    // vez de só aparecer bem depois, quando o operador já teria saído
    // da tela achando que conectou.
    unawaited(Future<void>.delayed(const Duration(milliseconds: 400), () {
      settle(() {
        _setStatus(ScaleConnectionStatus.conectada);
        completer.complete();
      });
    }));

    return completer.future;
  }

  @override
  Future<void> disconnect() async {
    await _sub?.cancel();
    _sub = null;
    try {
      await _methodChannel.invokeMethod('resetSerialMonitor');
    } catch (_) {}
    _setStatus(ScaleConnectionStatus.semBalanca);
  }

  void _setStatus(ScaleConnectionStatus status) {
    _status = status;
    _statusController.add(status);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _weightController.close();
    _statusController.close();
    _rawLineController.close();
  }
}
