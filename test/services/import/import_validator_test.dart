import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/core/constants/app_constants.dart';
import 'package:pesagem_totem/services/import/file_parser.dart';
import 'package:pesagem_totem/services/import/import_validator.dart';

void main() {
  final validator = ImportValidator();
  final now = DateTime(2026, 1, 1);

  ParsedProductRow row({required bool porUnidade, int? validadeDias}) => ParsedProductRow(
        lineNumber: 1,
        rawLine: 'linha',
        departamento: '010',
        codigo: '125',
        preco: 10.0,
        descricao: 'PRODUTO TESTE',
        porUnidade: porUnidade,
        validadeDias: validadeDias,
      );

  test('produto sem o bit de unidade vira KG (padrão)', () {
    final result = validator.validate(row(porUnidade: false), now);
    expect(result.isValid, isTrue);
    expect(result.product!.unidade, AppConstants.defaultWeightUnit);
  });

  test('produto com o bit de unidade vira UN', () {
    final result = validator.validate(row(porUnidade: true), now);
    expect(result.isValid, isTrue);
    expect(result.product!.unidade, AppConstants.defaultUnitUnit);
  });

  test('validadeDias do arquivo passa direto para o ProductModel', () {
    final result = validator.validate(row(porUnidade: false, validadeDias: 5), now);
    expect(result.isValid, isTrue);
    expect(result.product!.validadeDias, 5);
  });

  test('sem validadeDias no arquivo, ProductModel fica null', () {
    final result = validator.validate(row(porUnidade: false), now);
    expect(result.isValid, isTrue);
    expect(result.product!.validadeDias, isNull);
  });
}
