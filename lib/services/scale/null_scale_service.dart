import '../../data/models/scale_model.dart';
import 'scale_service.dart';

/// Implementação nula usada enquanto nenhuma balança foi configurada
/// (ver escopo, item 11 — estado "SEM BALANÇA"). Nunca emite leituras
/// de peso nem dados brutos, e seu status de conexão é sempre
/// [ScaleConnectionStatus.semBalanca] — existe apenas para dar a
/// [ScaleServiceManager] um estado inicial honesto, sem simular
/// hardware que não existe.
class NullScaleService implements ScaleService {
  @override
  Stream<ScaleReading> get weightStream => const Stream.empty();

  @override
  Stream<String> get rawLineStream => const Stream.empty();

  @override
  Stream<ScaleConnectionStatus> get connectionStatusStream => const Stream.empty();

  @override
  ScaleConnectionStatus get currentStatus => ScaleConnectionStatus.semBalanca;

  @override
  Future<void> connect(ScaleModel scale) async {}

  @override
  Future<void> disconnect() async {}

  @override
  void dispose() {}
}
