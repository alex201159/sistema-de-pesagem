import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/services/scale/scale_line_weight_parser.dart';

void main() {
  group('ScaleLineWeightParser', () {
    test('extrai peso de um inteiro com casas decimais implícitas', () {
      const parser = ScaleLineWeightParser(extractStart: 1, extractLength: 6, implicitDecimals: 3);

      expect(parser.extract('000485'), 0.485);
      expect(parser.extract('012350'), 12.350);
    });

    test('extrai peso de um recorte no meio de uma linha maior', () {
      const parser = ScaleLineWeightParser(extractStart: 4, extractLength: 6, implicitDecimals: 3);

      expect(parser.extract('ST:000485:XX'), 0.485);
    });

    test('aceita vírgula ou ponto como separador decimal', () {
      const parser = ScaleLineWeightParser(extractStart: 1, extractLength: 6, implicitDecimals: 3);

      expect(parser.extract('0,485 '), 0.485);
      expect(parser.extract('0.485 '), 0.485);
    });

    test('marcador F força peso zero (balança "flutuando"/vazia)', () {
      // extractStart aponta para os dígitos; o marcador de sinal
      // imediatamente anterior é incluído automaticamente pelo recorte.
      const parser = ScaleLineWeightParser(extractStart: 3, extractLength: 6, implicitDecimals: 3);

      expect(parser.extract('XF000485'), 0);
    });

    test('marcadores D/L definem o sinal do peso', () {
      const parser = ScaleLineWeightParser(extractStart: 3, extractLength: 6, implicitDecimals: 3);

      expect(parser.extract('XD000485'), 0.485);
      expect(parser.extract('XL000485'), -0.485);
    });

    test('retorna null quando o recorte não é um valor reconhecível', () {
      const parser = ScaleLineWeightParser(extractStart: 1, extractLength: 6, implicitDecimals: 3);

      expect(parser.extract('ABCDEF'), isNull);
      expect(parser.extract(''), isNull);
    });

    test('copyWith ajusta apenas os campos informados', () {
      const parser = ScaleLineWeightParser(extractStart: 1, extractLength: 6, implicitDecimals: 3);
      final adjusted = parser.copyWith(extractLength: 8);

      expect(adjusted.extractStart, 1);
      expect(adjusted.extractLength, 8);
      expect(adjusted.implicitDecimals, 3);
    });
  });
}
