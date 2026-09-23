import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/services/import/itens_mgv_parser.dart';

void main() {
  final parser = ItensMgvParser();

  group('ItensMgvParser com o arquivo real ITENSMGV.txt', () {
    late List<int> bytes;

    setUpAll(() {
      final file = File('import_samples/ITENSMGV.txt');
      bytes = file.readAsBytesSync();
    });

    test('reconhece o arquivo pelo nome', () {
      expect(parser.canParse('ITENSMGV.txt', bytes), isTrue);
    });

    test('reconhece o arquivo pelo conteúdo mesmo com outro nome', () {
      expect(parser.canParse('produtos_qualquer.txt', bytes), isTrue);
    });

    test('decodifica todas as 262 linhas sem nenhum erro estrutural', () {
      final result = parser.parse('ITENSMGV.txt', bytes);
      expect(result.errors, isEmpty);
      expect(result.rows, hasLength(262));
    });

    test('extrai corretamente o primeiro produto (ABACATE)', () {
      final result = parser.parse('ITENSMGV.txt', bytes);
      final abacate = result.rows.first;

      expect(abacate.departamento, '01');
      expect(abacate.codigo, '59');
      expect(abacate.preco, 6.99);
      expect(abacate.descricao, 'ABACATE');
      expect(abacate.porUnidade, isFalse);
    });

    test('remove zeros à esquerda do código preservando o valor', () {
      final result = parser.parse('ITENSMGV.txt', bytes);
      final bolo = result.rows.firstWhere((r) => r.descricao == 'BOLO VULCAO');

      expect(bolo.codigo, '7086');
      expect(bolo.departamento, '00');
      expect(bolo.preco, 29.99);
      // Um bolo inteiro faz sentido ser vendido por unidade.
      expect(bolo.porUnidade, isTrue);
    });

    test('lida com as linhas cuja descrição tem um espaço extra (161 chars)', () {
      final result = parser.parse('ITENSMGV.txt', bytes);
      final pao = result.rows.where((r) => r.descricao == 'PAO DE QUEIJO RECHEADO');

      expect(pao, hasLength(2));
      expect(pao.map((r) => r.codigo), containsAll(['238', '186']));
    });

    test('não gera códigos duplicados', () {
      final result = parser.parse('ITENSMGV.txt', bytes);
      final codigos = result.rows.map((r) => r.codigo).toList();
      expect(codigos.toSet().length, codigos.length);
    });

    test('reconhece os 56 produtos com o byte de tipo de venda "1" como por unidade', () {
      // Confirmado contra o layout oficial ITENSMGV do Toledo MGV6
      // (help.toledobrasil.com/mgv6): posição 3 da linha ("T") vale
      // '0' para peso e '1' para unidade — inclui itens de padaria,
      // pré-embalados e bandejas, todos plausíveis por unidade.
      final result = parser.parse('ITENSMGV.txt', bytes);
      final porUnidade = result.rows.where((r) => r.porUnidade).toList();

      expect(porUnidade, hasLength(56));
      expect(porUnidade.map((r) => r.descricao), contains('BOLO DOIS AMORES'));
      expect(porUnidade.map((r) => r.descricao), contains('BOLO VULCAO'));
      expect(porUnidade.map((r) => r.descricao), contains('SACOLA RECICLADA 40X50'));
    });

    test('todos os demais produtos da amostra são vendidos por peso', () {
      final result = parser.parse('ITENSMGV.txt', bytes);
      final porPeso = result.rows.where((r) => !r.porUnidade);
      expect(porPeso.length, 206);
    });
  });

  group('ItensMgvParser com linhas sintéticas', () {
    String buildLine({
      String departamento = '01',
      String saleType = '0',
      String codigo = '000125',
      String precoCentavos = '004290',
      String reservado = '000',
      required String descricao,
      int descricaoWidth = 50,
      String tail = '',
    }) {
      final desc = descricao.padRight(descricaoWidth);
      final tailFilled = tail.padLeft(92, '0');
      return '$departamento$saleType$codigo$precoCentavos$reservado$desc$tailFilled';
    }

    test('rejeita linha menor que o tamanho mínimo', () {
      final result = parser.parse('t.txt', utf8.encode('010000125004290000CURTA\n'));
      expect(result.rows, isEmpty);
      expect(result.errors, hasLength(1));
      expect(result.errors.first.motivo, contains('menor que o mínimo'));
    });

    test('rejeita prefixo não numérico', () {
      final line = 'AB0000125004290000${'PRODUTO TESTE'.padRight(50)}${'0' * 92}';
      final result = parser.parse('t.txt', utf8.encode(line));
      expect(result.rows, isEmpty);
      expect(result.errors.single.motivo, contains('não é numérico'));
    });

    test('rejeita código zero', () {
      final line = buildLine(codigo: '000000', descricao: 'PRODUTO SEM CODIGO');
      final result = parser.parse('t.txt', utf8.encode(line));
      expect(result.rows, isEmpty);
      expect(result.errors.single.motivo, contains('zero'));
    });

    test('rejeita preço zero', () {
      final line = buildLine(precoCentavos: '000000', descricao: 'PRODUTO SEM PRECO');
      final result = parser.parse('t.txt', utf8.encode(line));
      expect(result.rows, isEmpty);
      expect(result.errors.single.motivo, contains('Preço inválido'));
    });

    test('rejeita descrição vazia', () {
      final line = buildLine(descricao: '', descricaoWidth: 50);
      final result = parser.parse('t.txt', utf8.encode(line));
      expect(result.rows, isEmpty);
      expect(result.errors.single.motivo, contains('Descrição vazia'));
    });

    test('lê o byte de tipo de venda (posição 3) como unidade quando "1"', () {
      final line = buildLine(saleType: '1', descricao: 'PRODUTO POR UNIDADE');
      final result = parser.parse('t.txt', utf8.encode(line));

      expect(result.rows, hasLength(1));
      expect(result.rows.single.porUnidade, isTrue);
    });

    test('lê o byte de tipo de venda "5" (EAN-13 por unidade) também como unidade', () {
      final line = buildLine(saleType: '5', descricao: 'PRODUTO EAN13 UNIDADE');
      final result = parser.parse('t.txt', utf8.encode(line));

      expect(result.rows, hasLength(1));
      expect(result.rows.single.porUnidade, isTrue);
    });

    test('lê os bytes de tipo de venda "2","3","4" (variantes de peso) como peso', () {
      for (final saleType in ['0', '2', '3', '4']) {
        final line = buildLine(saleType: saleType, descricao: 'PRODUTO POR PESO');
        final result = parser.parse('t.txt', utf8.encode(line));

        expect(result.rows, hasLength(1), reason: 'saleType=$saleType');
        expect(result.rows.single.porUnidade, isFalse, reason: 'saleType=$saleType');
      }
    });

    test('lê o campo VVV (validade em dias) quando presente', () {
      final line = buildLine(reservado: '005', descricao: 'PAO FRANCES');
      final result = parser.parse('t.txt', utf8.encode(line));

      expect(result.rows, hasLength(1));
      expect(result.rows.single.validadeDias, 5);
    });

    test('VVV = "000" vira validadeDias null (sem validade)', () {
      final line = buildLine(reservado: '000', descricao: 'PAO FRANCES');
      final result = parser.parse('t.txt', utf8.encode(line));

      expect(result.rows.single.validadeDias, isNull);
    });

    test('VVV = "999" (validade digitada na balança) também vira null', () {
      final line = buildLine(reservado: '999', descricao: 'PAO FRANCES');
      final result = parser.parse('t.txt', utf8.encode(line));

      expect(result.rows.single.validadeDias, isNull);
    });

    test('detecta código duplicado dentro do arquivo', () {
      final line1 = buildLine(codigo: '000125', descricao: 'PRODUTO UM');
      final line2 = buildLine(codigo: '000125', descricao: 'PRODUTO DOIS');
      final result = parser.parse('t.txt', utf8.encode('$line1\n$line2'));

      expect(result.rows, hasLength(1));
      expect(result.rows.single.descricao, 'PRODUTO UM');
      expect(result.errors.single.motivo, contains('duplicado'));
    });

    test('ignora linhas em branco sem gerar erro', () {
      final line = buildLine(descricao: 'PRODUTO VALIDO');
      final result = parser.parse('t.txt', utf8.encode('\n$line\n\n'));
      expect(result.rows, hasLength(1));
      expect(result.errors, isEmpty);
    });
  });
}
