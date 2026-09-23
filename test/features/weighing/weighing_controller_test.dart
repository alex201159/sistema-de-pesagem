import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/core/constants/app_constants.dart';
import 'package:pesagem_totem/data/models/product_model.dart';
import 'package:pesagem_totem/features/weighing/weighing_controller.dart';

void main() {
  final now = DateTime(2026, 1, 1);

  ProductModel produto({required String unidade}) => ProductModel(
        codigo: '125',
        plu: '125',
        descricao: 'PRODUTO TESTE',
        preco: 10.0,
        unidade: unidade,
        ativo: true,
        dataCriacao: now,
        dataAtualizacao: now,
      );

  group('WeighingState — modo peso (KG)', () {
    final produtoPeso = produto(unidade: AppConstants.defaultWeightUnit);

    test('porUnidade é falso e total usa o peso da balança', () {
      final state = WeighingState(selectedProduct: produtoPeso, weightKg: 2.0);
      expect(state.porUnidade, isFalse);
      expect(state.total, 20.0);
    });

    test('canPrint exige peso > 0 e balança estável', () {
      final semPesoEstavel = WeighingState(
        selectedProduct: produtoPeso,
        weightKg: 2.0,
        scaleStatus: ScaleDisplayStatus.instavel,
      );
      expect(semPesoEstavel.canPrint, isFalse);

      final pronto = WeighingState(
        selectedProduct: produtoPeso,
        weightKg: 2.0,
        scaleStatus: ScaleDisplayStatus.estavel,
      );
      expect(pronto.canPrint, isTrue);
    });

    test('quantidadeInput não afeta o total quando o produto é por peso', () {
      final state = WeighingState(
        selectedProduct: produtoPeso,
        weightKg: 2.0,
        scaleStatus: ScaleDisplayStatus.estavel,
        quantidadeInput: '99',
      );
      expect(state.total, 20.0);
    });
  });

  group('WeighingState — modo unidade (UN)', () {
    final produtoUnidade = produto(unidade: AppConstants.defaultUnitUnit);

    test('porUnidade é verdadeiro e total usa a quantidade digitada', () {
      final state = WeighingState(selectedProduct: produtoUnidade, quantidadeInput: '3');
      expect(state.porUnidade, isTrue);
      expect(state.quantidade, 3);
      expect(state.total, 30.0);
    });

    test('canPrint exige quantidade > 0, independentemente da balança', () {
      final semQuantidade = WeighingState(selectedProduct: produtoUnidade);
      expect(semQuantidade.canPrint, isFalse);

      final comQuantidade = WeighingState(
        selectedProduct: produtoUnidade,
        quantidadeInput: '3',
        scaleStatus: ScaleDisplayStatus.semBalanca,
      );
      expect(comQuantidade.canPrint, isTrue);
    });

    test('aceita vírgula como separador decimal na quantidade', () {
      final state = WeighingState(selectedProduct: produtoUnidade, quantidadeInput: '2,5');
      expect(state.quantidade, 2.5);
      expect(state.total, 25.0);
    });

    test('peso da balança é ignorado no total quando o produto é por unidade', () {
      final state = WeighingState(
        selectedProduct: produtoUnidade,
        weightKg: 999,
        quantidadeInput: '1',
      );
      expect(state.total, 10.0);
    });
  });
}
