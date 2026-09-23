import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/services/scale/weight_stability_service.dart';

void main() {
  group('WeightStabilityService', () {
    test('reporta instável enquanto não há amostras suficientes', () {
      final service = WeightStabilityService(sampleCount: 5, toleranceKg: 0.005);

      expect(service.evaluate(0.480).stable, isFalse);
      expect(service.evaluate(0.483).stable, isFalse);
      expect(service.evaluate(0.485).stable, isFalse);
      expect(service.evaluate(0.485).stable, isFalse);
    });

    test('reporta estável quando a janela completa está dentro da tolerância', () {
      final service = WeightStabilityService(sampleCount: 5, toleranceKg: 0.005);

      service.evaluate(0.483);
      service.evaluate(0.485);
      service.evaluate(0.485);
      service.evaluate(0.484);
      final result = service.evaluate(0.485);

      expect(result.stable, isTrue);
      expect(result.kg, 0.485);
    });

    test('reporta instável quando a variação excede a tolerância', () {
      final service = WeightStabilityService(sampleCount: 5, toleranceKg: 0.005);

      service.evaluate(0.100);
      service.evaluate(0.300);
      service.evaluate(0.500);
      service.evaluate(0.700);
      final result = service.evaluate(0.900);

      expect(result.stable, isFalse);
    });

    test('volta a ficar instável quando o peso muda após estabilizar', () {
      final service = WeightStabilityService(sampleCount: 3, toleranceKg: 0.005);

      service.evaluate(0.485);
      service.evaluate(0.485);
      expect(service.evaluate(0.485).stable, isTrue);

      expect(service.evaluate(1.200).stable, isFalse);
    });

    test('reset() limpa a janela de leituras', () {
      final service = WeightStabilityService(sampleCount: 3, toleranceKg: 0.005);

      service.evaluate(0.485);
      service.evaluate(0.485);
      service.evaluate(0.485);
      service.reset();

      expect(service.evaluate(0.485).stable, isFalse);
    });
  });
}
