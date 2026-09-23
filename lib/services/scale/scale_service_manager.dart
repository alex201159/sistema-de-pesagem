import 'dart:async';

import '../../core/utils/app_logger.dart';
import '../../data/models/scale_model.dart';
import 'scale_service.dart';

/// Encaminha para uma implementação [ScaleService] concreta, trocável
/// em tempo de execução — permite que a tela de configuração troque a
/// balança (mock -> BLE -> USB serial) sem que `WeighingController`
/// precise recriar suas assinaturas de stream (ver escopo, item 10:
/// "possibilitar trocar futuramente balança... sem reescrever o app").
class ScaleServiceManager implements ScaleService {
  ScaleServiceManager(ScaleService initial) : _active = initial {
    _pipe(_active);
  }

  ScaleService _active;
  StreamSubscription<ScaleReading>? _weightSub;
  StreamSubscription<ScaleConnectionStatus>? _statusSub;
  StreamSubscription<String>? _rawLineSub;

  final _weightController = StreamController<ScaleReading>.broadcast();
  final _statusController = StreamController<ScaleConnectionStatus>.broadcast();
  final _rawLineController = StreamController<String>.broadcast();

  @override
  Stream<ScaleReading> get weightStream => _weightController.stream;

  /// Emite o status atual imediatamente para quem começar a ouvir
  /// agora (ex.: uma tela recém-aberta), e então repassa as próximas
  /// mudanças — sem isso, um novo ouvinte só veria algo quando o
  /// status mudasse de novo, o que nunca acontece enquanto a
  /// implementação ativa for [NullScaleService] (estado constante).
  @override
  Stream<ScaleConnectionStatus> get connectionStatusStream async* {
    yield currentStatus;
    yield* _statusController.stream;
  }

  @override
  Stream<String> get rawLineStream => _rawLineController.stream;

  @override
  ScaleConnectionStatus get currentStatus => _active.currentStatus;

  @override
  Future<void> connect(ScaleModel scale) => _active.connect(scale);

  @override
  Future<void> disconnect() => _active.disconnect();

  /// Substitui a implementação ativa por [implementation] e conecta em
  /// [scale] imediatamente, sem bloquear quem chamou (ver escopo, item
  /// 45) — falhas de conexão chegam via [connectionStatusStream], não
  /// como exceção não tratada.
  Future<void> useImplementation(ScaleService implementation, ScaleModel scale) async {
    await _retireActive();
    _active = implementation;
    _pipe(_active);
    try {
      await _active.connect(scale);
    } catch (e, st) {
      AppLogger.e('Falha ao conectar na balança recém-configurada', e, st);
    }
  }

  void _pipe(ScaleService service) {
    _weightSub = service.weightStream.listen(_weightController.add);
    _statusSub = service.connectionStatusStream.listen(_statusController.add);
    _rawLineSub = service.rawLineStream.listen(_rawLineController.add);
  }

  Future<void> _retireActive() async {
    await _weightSub?.cancel();
    await _statusSub?.cancel();
    await _rawLineSub?.cancel();
    try {
      await _active.disconnect();
    } catch (_) {}
    _active.dispose();
  }

  @override
  void dispose() {
    _weightSub?.cancel();
    _statusSub?.cancel();
    _rawLineSub?.cancel();
    _active.dispose();
    _weightController.close();
    _statusController.close();
    _rawLineController.close();
  }
}
