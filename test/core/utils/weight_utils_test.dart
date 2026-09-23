import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/core/utils/weight_utils.dart';

void main() {
  group('WeightUtils.round', () {
    test('arredonda para 3 casas decimais', () {
      expect(WeightUtils.round(0.4855), 0.486);
      expect(WeightUtils.round(0.4851), 0.485);
    });
  });

  group('conversões grama/quilograma', () {
    test('gramsToKg', () {
      expect(WeightUtils.gramsToKg(485), 0.485);
    });

    test('kgToGrams', () {
      expect(WeightUtils.kgToGrams(0.485), 485);
    });
  });

  group('WeightUtils.format', () {
    test('formata com unidade', () {
      expect(WeightUtils.format(0.485), '0,485 kg');
    });

    test('formata sem unidade', () {
      expect(WeightUtils.format(0.485, withUnit: false), '0,485');
    });
  });

  group('WeightUtils.isPlausible', () {
    test('rejeita peso zero ou negativo', () {
      expect(WeightUtils.isPlausible(0), isFalse);
      expect(WeightUtils.isPlausible(-1), isFalse);
    });

    test('aceita peso dentro da faixa padrão', () {
      expect(WeightUtils.isPlausible(0.485), isTrue);
    });

    test('rejeita peso acima do limite configurado', () {
      expect(WeightUtils.isPlausible(100, maxKg: 60), isFalse);
    });
  });
}
