import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/data/models/label_element_model.dart';
import 'package:pesagem_totem/data/models/label_model.dart';
import 'package:pesagem_totem/services/printer/drivers/tspl_driver.dart';
import 'package:pesagem_totem/services/printer/printer_service.dart';

void main() {
  const driver = TsplDriver();

  LabelPrintData buildData() => LabelPrintData(
        produto: 'QUEIJO MUSSARELA',
        codigo: '125',
        peso: 0.485,
        precoKg: 42.90,
        total: 20.81,
        codigoBarras: '2125000208105',
        dataHora: DateTime(2026, 8, 25, 14, 35),
        validade: DateTime(2026, 9, 4),
      );

  LabelModel buildLabel(List<LabelElementModel> elementos) {
    final now = DateTime(2026, 1, 1);
    return LabelModel(
      nome: 'Teste',
      larguraMm: 60,
      alturaMm: 40,
      dataCriacao: now,
      dataAtualizacao: now,
      elementos: elementos,
    );
  }

  test('gera o cabeçalho SIZE/GAP/CLS e o rodapé PRINT', () {
    final label = buildLabel(const []);
    final commands = String.fromCharCodes(driver.render(label, buildData()));

    expect(commands, contains('SIZE 60 mm,40 mm'));
    expect(commands, contains('CLS'));
    expect(commands, contains('PRINT 1'));
  });

  test('resolve o placeholder do produto em um comando TEXT', () {
    final label = buildLabel([
      const LabelElementModel(
        labelId: 1,
        tipo: LabelElementType.produto,
        x: 2,
        y: 2,
        largura: 56,
        altura: 6,
      ),
    ]);
    final commands = String.fromCharCodes(driver.render(label, buildData()));

    expect(commands, contains('QUEIJO MUSSARELA'));
  });

  test('formata peso e total usando as mesmas regras do resto do app', () {
    final label = buildLabel([
      const LabelElementModel(
        labelId: 1,
        tipo: LabelElementType.peso,
        x: 2,
        y: 10,
        largura: 27,
        altura: 6,
      ),
      const LabelElementModel(
        labelId: 1,
        tipo: LabelElementType.total,
        x: 2,
        y: 18,
        largura: 56,
        altura: 8,
      ),
    ]);
    final commands = String.fromCharCodes(driver.render(label, buildData()));

    expect(commands, contains('0,485 kg'));
    expect(commands, contains('R\$ 20,81'));
  });

  test('imprime a validade quando o produto tem validadeDias (arquivo trouxe VVV)', () {
    final label = buildLabel([
      const LabelElementModel(
        labelId: 1,
        tipo: LabelElementType.validade,
        x: 2,
        y: 34,
        largura: 56,
        altura: 6,
      ),
    ]);
    final commands = String.fromCharCodes(driver.render(label, buildData()));

    expect(commands, contains('04/09/2026'));
  });

  test('validade ausente (validadeDias null) imprime elemento vazio, sem quebrar', () {
    final label = buildLabel([
      const LabelElementModel(
        labelId: 1,
        tipo: LabelElementType.validade,
        x: 2,
        y: 34,
        largura: 56,
        altura: 6,
      ),
    ]);
    final semValidade = LabelPrintData(
      produto: 'QUEIJO MUSSARELA',
      codigo: '125',
      peso: 0.485,
      precoKg: 42.90,
      total: 20.81,
      codigoBarras: '2125000208105',
      dataHora: DateTime(2026, 8, 25, 14, 35),
    );
    final commands = driver.render(label, semValidade);

    expect(() => driver.render(label, semValidade), returnsNormally);
    expect(commands, isNotEmpty);
  });

  test('gera um comando BARCODE com o código de barras já calculado', () {
    final label = buildLabel([
      const LabelElementModel(
        labelId: 1,
        tipo: LabelElementType.codigoBarras,
        x: 2,
        y: 28,
        largura: 56,
        altura: 8,
      ),
    ]);
    final commands = String.fromCharCodes(driver.render(label, buildData()));

    expect(commands, contains('BARCODE'));
    expect(commands, contains('2125000208105'));
  });

  test('ignora elemento de logotipo (upload de imagem ainda não suportado)', () {
    final label = buildLabel([
      const LabelElementModel(
        labelId: 1,
        tipo: LabelElementType.logotipo,
        x: 2,
        y: 2,
        largura: 20,
        altura: 20,
      ),
    ]);
    final commands = driver.render(label, buildData());

    // Cabeçalho + rodapé apenas — nenhum comando extra para o logo.
    expect(String.fromCharCodes(commands).trim().split('\n'), hasLength(5));
  });

  test('texto livre usa o conteúdo configurado no elemento', () {
    final label = buildLabel([
      const LabelElementModel(
        labelId: 1,
        tipo: LabelElementType.textoLivre,
        x: 2,
        y: 2,
        largura: 40,
        altura: 6,
        conteudoLivre: 'Produto resfriado',
      ),
    ]);
    final commands = String.fromCharCodes(driver.render(label, buildData()));

    expect(commands, contains('Produto resfriado'));
  });
}
