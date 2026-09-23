import '../../core/utils/barcode_utils.dart';
import '../../data/models/barcode_config_model.dart';

/// Dados de origem para a montagem do código de barras de uma pesagem.
class BarcodeInput {
  final String productCode;
  final double pricePerKg;
  final double total;
  final double weightKg;

  /// `true` quando [weightKg] na verdade carrega uma quantidade de
  /// unidades (produto vendido por unidade, não por peso — ver
  /// `WeighingState.porUnidade`), não um peso em kg de verdade.
  final bool porUnidade;

  /// Código de barras trazido pelo arquivo de importação, quando
  /// existir (ver escopo, item 17). Preservado exatamente como
  /// importado quando [BarcodeConfigModel.valueType] for
  /// [BarcodeValueType.importado].
  final String? importedBarcode;

  const BarcodeInput({
    required this.productCode,
    required this.pricePerKg,
    required this.total,
    required this.weightKg,
    this.porUnidade = false,
    this.importedBarcode,
  });
}

/// Monta o código de barras EAN-13 impresso na etiqueta, seguindo a
/// configuração definida pelo usuário (ver escopo, itens 18-21):
/// quantidade de dígitos do código/PLU e o que o campo de valor
/// representa (preço, preço total, peso, ou código importado).
class BarcodeService {
  /// Gera o EAN-13 conforme [config] e [input].
  String build(BarcodeConfigModel config, BarcodeInput input) {
    if (config.valueType == BarcodeValueType.importado &&
        input.importedBarcode != null &&
        input.importedBarcode!.trim().isNotEmpty) {
      return input.importedBarcode!.trim();
    }

    final codePart = _fitDigits(input.productCode, config.productDigits);

    final rawValue = switch (config.valueType) {
      BarcodeValueType.preco => (input.pricePerKg * 100).round(),
      BarcodeValueType.precoTotal => (input.total * 100).round(),
      // Um produto por unidade não tem peso em gramas de verdade pra
      // codificar aqui — `input.weightKg` carrega a quantidade digitada,
      // não um peso (ver [BarcodeInput.porUnidade]). Usa preço total
      // como reserva, senão o código sairia com "3000 g" onde a
      // quantidade era só "3 un".
      BarcodeValueType.peso => input.porUnidade
          ? (input.total * 100).round()
          : (input.weightKg * 1000).round(),
      // Sem código importado disponível: usa preço total como reserva,
      // para nunca deixar de montar um código válido.
      BarcodeValueType.importado => (input.total * 100).round(),
    };
    final valuePart = _fitDigits(rawValue.toString(), config.valueDigits);

    final digits12 = '${config.prefix}$codePart$valuePart';
    return BarcodeUtils.buildEan13(digits12);
  }

  /// Ajusta uma sequência numérica para exatamente [length] dígitos:
  /// preenche com zeros à esquerda quando curta, mantém apenas os
  /// dígitos menos significativos quando exceder o limite (ex.: total
  /// alto demais para caber no campo de valor).
  String _fitDigits(String digitsOnly, int length) {
    final onlyDigits = digitsOnly.replaceAll(RegExp(r'\D'), '');
    final padded = onlyDigits.padLeft(length, '0');
    return padded.length > length ? padded.substring(padded.length - length) : padded;
  }
}
