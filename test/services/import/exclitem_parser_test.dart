import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/services/import/exclitem_parser.dart';

void main() {
  group('ExclItemParser', () {
    test('decodifica uma linha: departamento (2) + código (6)', () {
      final bytes = utf8.encode('06001256\n');
      final codigos = ExclItemParser.parse(bytes);

      expect(codigos, ['1256']);
    });

    test('decodifica múltiplas linhas', () {
      final bytes = utf8.encode('01000001\n00007086\n');
      final codigos = ExclItemParser.parse(bytes);

      expect(codigos, ['1', '7086']);
    });

    test('ignora linha com código zero', () {
      final bytes = utf8.encode('01000000\n');
      expect(ExclItemParser.parse(bytes), isEmpty);
    });

    test('ignora linha menor que 8 caracteres ou não numérica', () {
      final bytes = utf8.encode('curta\nAB001256\n');
      expect(ExclItemParser.parse(bytes), isEmpty);
    });

    test('arquivo vazio não gera erro', () {
      expect(ExclItemParser.parse(utf8.encode('')), isEmpty);
    });
  });
}
