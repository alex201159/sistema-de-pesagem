import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/core/utils/barcode_utils.dart';

void main() {
  group('BarcodeUtils.pad', () {
    test('preenche com zeros à esquerda', () {
      expect(BarcodeUtils.pad('125', 5), '00125');
    });
  });

  group('BarcodeUtils.isNumeric', () {
    test('aceita apenas dígitos', () {
      expect(BarcodeUtils.isNumeric('12345'), isTrue);
      expect(BarcodeUtils.isNumeric('12a45'), isFalse);
      expect(BarcodeUtils.isNumeric(''), isFalse);
    });
  });

  group('BarcodeUtils.calculateEan13CheckDigit', () {
    test('calcula dígito verificador correto (exemplo conhecido)', () {
      // EAN-13 completo de referência: 4006381333931
      expect(BarcodeUtils.calculateEan13CheckDigit('400638133393'), 1);
    });

    test('lança erro para entrada com tamanho incorreto', () {
      expect(() => BarcodeUtils.calculateEan13CheckDigit('123'), throwsArgumentError);
    });
  });

  group('BarcodeUtils.buildEan13 / isValidEan13', () {
    test('monta um EAN-13 válido', () {
      final ean = BarcodeUtils.buildEan13('400638133393');
      expect(ean, '4006381333931');
      expect(BarcodeUtils.isValidEan13(ean), isTrue);
    });

    test('detecta EAN-13 inválido', () {
      expect(BarcodeUtils.isValidEan13('4006381333930'), isFalse);
    });
  });
}
