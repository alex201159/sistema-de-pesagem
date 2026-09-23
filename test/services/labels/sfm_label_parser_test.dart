import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/core/errors/label_exception.dart';
import 'package:pesagem_totem/data/models/label_element_model.dart';
import 'package:pesagem_totem/services/labels/sfm_label_parser.dart';

const _assetsDir = 'assets/etiquetas_prontas';

String _read(String relativePath) => File('$_assetsDir/$relativePath').readAsStringSync();

int _count(List elements, LabelElementType tipo) =>
    elements.where((e) => e.tipo == tipo).length;

void main() {
  group('SfmLabelParser', () {
    test('converte um modelo 40x40 (sem "codigo", com todas as linhas finas)', () {
      final label = SfmLabelParser.parse(
        _read('etiquetas 40x40/1 PESO DEFAULT.sfm'),
        nomeSugerido: '1 PESO DEFAULT',
      );

      // Header band nativo é 448x336 (8 dots/mm) -> 56x42mm, não 40x40mm
      // como o nome da pasta sugeriria (ver plano: dimensão real vem do
      // arquivo, não do nome da pasta).
      expect(label.larguraMm, 56);
      expect(label.alturaMm, 42);
      expect(label.nome, '1 PESO DEFAULT');
      expect(label.elementos, hasLength(18));

      expect(_count(label.elementos, LabelElementType.produto), 1);
      expect(_count(label.elementos, LabelElementType.data), 1);
      expect(_count(label.elementos, LabelElementType.validade), 1);
      expect(_count(label.elementos, LabelElementType.hora), 1);
      expect(_count(label.elementos, LabelElementType.peso), 1);
      expect(_count(label.elementos, LabelElementType.precoKg), 1);
      expect(_count(label.elementos, LabelElementType.total), 1);
      expect(_count(label.elementos, LabelElementType.codigo), 0);
      expect(_count(label.elementos, LabelElementType.codigoBarras), 1);
      expect(_count(label.elementos, LabelElementType.linha), 2);
      expect(_count(label.elementos, LabelElementType.retangulo), 0);
      // 7 rótulos estáticos ("Data:", "Val:", "Hora:", "TARA:", "PESO:",
      // "PREÇO/kg:", "(R$)") + 1 campo sem tipo equivalente (tara, field 8).
      expect(_count(label.elementos, LabelElementType.textoLivre), 8);

      final produto = label.elementos.firstWhere((e) => e.tipo == LabelElementType.produto);
      expect(produto.alinhamento, LabelTextAlign.center);
    });

    test('converte um modelo 60x90 com "codigo", retângulo, logotipo e tabela nutricional', () {
      final label = SfmLabelParser.parse(
        _read('etiquetas 60x90/47 - PESO.sfm'),
        nomeSugerido: '47 - PESO',
      );

      expect(label.larguraMm, 56);
      expect(label.alturaMm, 42);
      expect(label.elementos, hasLength(23));

      for (final tipo in [
        LabelElementType.produto,
        LabelElementType.data,
        LabelElementType.validade,
        LabelElementType.codigo,
        LabelElementType.hora,
        LabelElementType.peso,
        LabelElementType.precoKg,
        LabelElementType.total,
      ]) {
        expect(_count(label.elementos, tipo), 1, reason: '$tipo deveria aparecer 1x');
      }

      expect(_count(label.elementos, LabelElementType.codigoBarras), 1);
      expect(_count(label.elementos, LabelElementType.logotipo), 1);
      expect(_count(label.elementos, LabelElementType.linha), 1);
      expect(_count(label.elementos, LabelElementType.retangulo), 1);
      // 8 rótulos estáticos (sem <field>) + 2 campos sem tipo equivalente
      // (tara field 8, receita field 13) + 1 tabela nutricional (UCNutInfoTable).
      expect(_count(label.elementos, LabelElementType.textoLivre), 11);

      final nutInfo = label.elementos.firstWhere(
        (e) => e.conteudoLivre == '[Tabela nutricional — recriar manualmente]',
      );
      expect(nutInfo.tipo, LabelElementType.textoLivre);
    });

    test('nenhum elemento fica fora dos limites da etiqueta (clamp)', () {
      final label = SfmLabelParser.parse(
        _read('etiquetas 40x40/1 PESO DEFAULT.sfm'),
        nomeSugerido: 'x',
      );

      for (final e in label.elementos) {
        expect(e.x, greaterThanOrEqualTo(0));
        expect(e.y, greaterThanOrEqualTo(0));
        expect(e.x + e.largura, lessThanOrEqualTo(label.larguraMm));
        expect(e.y + e.altura, lessThanOrEqualTo(label.alturaMm));
        expect(e.largura, greaterThanOrEqualTo(2));
        // Linhas separadoras finas ficam abaixo de 2mm de propósito (ver
        // SfmLabelParser._minLinhaAlturaMm) para não virarem barras grossas.
        expect(e.altura, greaterThanOrEqualTo(e.tipo == LabelElementType.linha ? 0.3 : 2));
      }
    });

    test('lança LabelParseException para XML inválido', () {
      expect(
        () => SfmLabelParser.parse('não é xml', nomeSugerido: 'x'),
        throwsA(isA<LabelParseException>()),
      );
    });

    test('lança LabelParseException quando não há banda Header', () {
      const xml = '<?xml version="1.0"?><template><TemplatePage></TemplatePage></template>';
      expect(
        () => SfmLabelParser.parse(xml, nomeSugerido: 'x'),
        throwsA(isA<LabelParseException>()),
      );
    });

    test('consegue converter ao menos um arquivo real de cada pasta do pacote', () {
      const amostras = [
        'Etiquetas 60x25/19 - DEFAULT peso.sfm',
        'etiquetas 40x40/1 PESO DEFAULT.sfm',
        'etiquetas 40x60/59 - PESO - DADOS PLU - DADOS COMERCIAIS.sfm',
        'etiquetas 60x30/23 - PESO barras - preco - esquerda.sfm',
        'etiquetas 60x40/36 - DEFAULT PESO.sfm',
        'etiquetas 60x60/44 - PESO.sfm',
        'etiquetas 60x90/47 - PESO.sfm',
      ];

      for (final caminho in amostras) {
        final label = SfmLabelParser.parse(_read(caminho), nomeSugerido: caminho);
        expect(label.larguraMm, greaterThan(0), reason: caminho);
        expect(label.alturaMm, greaterThan(0), reason: caminho);
        expect(label.elementos, isNotEmpty, reason: caminho);
      }
    });
  });
}
