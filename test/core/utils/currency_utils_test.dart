import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/core/utils/currency_utils.dart';

void main() {
  group('CurrencyUtils.calculateTotal', () {
    test('arredonda 0,485 kg x R\$42,90 para R\$20,81', () {
      final total = CurrencyUtils.calculateTotal(weightKg: 0.485, pricePerKg: 42.90);
      expect(total, 20.81);
    });

    test('arredonda para baixo quando a terceira casa é < 5', () {
      final total = CurrencyUtils.calculateTotal(weightKg: 1.0, pricePerKg: 10.001);
      expect(total, 10.00);
    });

    test('arredonda para cima quando a terceira casa é >= 5', () {
      final total = CurrencyUtils.calculateTotal(weightKg: 1.0, pricePerKg: 10.005);
      expect(total, 10.01);
    });
  });

  group('CurrencyUtils.format', () {
    test('formata no padrão brasileiro', () {
      expect(CurrencyUtils.format(20.81), 'R\$ 20,81');
    });
  });

  group('CurrencyUtils.tryParse', () {
    test('aceita vírgula decimal', () {
      expect(CurrencyUtils.tryParse('20,81'), 20.81);
    });

    test('aceita ponto decimal', () {
      expect(CurrencyUtils.tryParse('20.81'), 20.81);
    });

    test('aceita milhar com vírgula decimal', () {
      expect(CurrencyUtils.tryParse('1.234,56'), 1234.56);
    });

    test('retorna null para entrada inválida', () {
      expect(CurrencyUtils.tryParse('abc'), isNull);
    });
  });
}
