import '../../core/constants/app_constants.dart';
import '../../core/utils/validators.dart';
import '../../data/models/import_model.dart';
import '../../data/models/product_model.dart';
import 'file_parser.dart';

/// Resultado da validação de negócio de uma linha já decodificada:
/// ou vira um [ProductModel] pronto para persistir, ou um
/// [ImportLineError] explicando o motivo da rejeição — nunca os dois,
/// nunca descartado silenciosamente (ver escopo, item 55).
class ProductValidationResult {
  final ProductModel? product;
  final ImportLineError? error;

  const ProductValidationResult.ok(ProductModel this.product) : error = null;
  const ProductValidationResult.error(ImportLineError this.error) : product = null;

  bool get isValid => product != null;
}

/// Validação de regras de negócio sobre linhas já decodificadas
/// estruturalmente pelo `ProductFileParser`.
///
/// Separado do parser de propósito: o parser cuida da SINTAXE do
/// arquivo (posições, tamanhos), este validador cuida da SEMÂNTICA
/// (um preço estruturalmente válido ainda pode ser uma regra de
/// negócio inválida, ex.: zero).
///
/// A unidade de venda (peso/kg ou unidade) vem de `row.porUnidade`,
/// decodificado pelo `ItensMgvParser` a partir do byte "tipo de venda"
/// do layout oficial ITENSMGV (Toledo MGV6) — não é mais assumida
/// como sempre KG.
class ImportValidator {
  ProductValidationResult validate(ParsedProductRow row, DateTime now) {
    if (!Validators.isValidProductCode(row.codigo)) {
      return ProductValidationResult.error(ImportLineError(
        linha: row.lineNumber,
        motivo: 'Código de produto inválido: "${row.codigo}".',
        conteudo: row.rawLine,
      ));
    }

    if (!Validators.isValidDescription(row.descricao)) {
      return ProductValidationResult.error(ImportLineError(
        linha: row.lineNumber,
        motivo: 'Descrição inválida ou vazia.',
        conteudo: row.rawLine,
      ));
    }

    if (!Validators.isValidPrice(row.preco)) {
      return ProductValidationResult.error(ImportLineError(
        linha: row.lineNumber,
        motivo: 'Preço inválido: ${row.preco}.',
        conteudo: row.rawLine,
      ));
    }

    final product = ProductModel(
      codigo: row.codigo,
      plu: row.codigo,
      descricao: row.descricao,
      preco: row.preco,
      unidade: row.porUnidade ? AppConstants.defaultUnitUnit : AppConstants.defaultWeightUnit,
      departamento: row.departamento,
      validadeDias: row.validadeDias,
      ativo: true,
      dataCriacao: now,
      dataAtualizacao: now,
    );
    return ProductValidationResult.ok(product);
  }
}
