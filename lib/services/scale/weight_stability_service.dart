import 'dart:math' as math;

/// Resultado da avaliação de estabilidade de uma nova leitura.
class StabilityResult {
  final double kg;
  final bool stable;

  const StabilityResult({required this.kg, required this.stable});
}

/// Analisa as últimas leituras de peso para decidir se a balança está
/// "PESO ESTÁVEL" ou "PESO INSTÁVEL" (ver escopo, item 12).
///
/// Puramente computacional (sem I/O, sem timers) para nunca travar a
/// interface — é chamado a cada nova leitura recebida do
/// [ScaleService] e responde imediatamente.
///
/// Configurável: [toleranceKg] é a variação máxima aceita entre a
/// menor e a maior leitura da janela; [sampleCount] é o tamanho da
/// janela de leituras consideradas.
class WeightStabilityService {
  final double toleranceKg;
  final int sampleCount;

  final List<double> _buffer = [];

  WeightStabilityService({
    this.toleranceKg = 0.005,
    this.sampleCount = 5,
  }) : assert(sampleCount >= 2, 'sampleCount deve ser >= 2');

  StabilityResult evaluate(double reading) {
    _buffer.add(reading);
    if (_buffer.length > sampleCount) {
      _buffer.removeAt(0);
    }

    if (_buffer.length < sampleCount) {
      return StabilityResult(kg: reading, stable: false);
    }

    final maxValue = _buffer.reduce(math.max);
    final minValue = _buffer.reduce(math.min);
    final stable = (maxValue - minValue) <= toleranceKg;

    return StabilityResult(kg: reading, stable: stable);
  }

  /// Limpa a janela de leituras (ex.: ao trocar de produto ou
  /// reconectar a balança).
  void reset() => _buffer.clear();
}
