/// O que o campo de valor do código de barras representa
/// (ver escopo, item 19).
enum BarcodeValueType {
  preco,
  precoTotal,
  peso,

  /// Usa o código de barras exatamente como veio do arquivo de
  /// importação, sem montar nada (ver escopo, item 17). Se o produto
  /// não tiver um código importado, o app monta um automaticamente
  /// como reserva, para nunca deixar de imprimir uma etiqueta.
  importado;

  String get label => switch (this) {
        BarcodeValueType.preco => 'PREÇO',
        BarcodeValueType.precoTotal => 'PREÇO TOTAL',
        BarcodeValueType.peso => 'PESO',
        BarcodeValueType.importado => 'UTILIZAR CÓDIGO IMPORTADO',
      };

  static BarcodeValueType fromName(String name) => BarcodeValueType.values
      .firstWhere((e) => e.name == name, orElse: () => BarcodeValueType.precoTotal);
}

/// Configuração do formato do código de barras montado pelo app
/// (ver escopo, itens 18-21), persistida via `SettingsRepository`.
///
/// Formato resultante (EAN-13, 13 dígitos):
/// `PREFIXO + CÓDIGO/PLU (productDigits) + VALOR (valueDigits) + DV`,
/// onde `valueDigits = 12 - prefix.length - productDigits`.
class BarcodeConfigModel {
  final String prefix;
  final int productDigits;
  final BarcodeValueType valueType;

  const BarcodeConfigModel({
    this.prefix = '21',
    this.productDigits = 5,
    this.valueType = BarcodeValueType.precoTotal,
  }) : assert(productDigits >= 4 && productDigits <= 6, 'productDigits deve ser 4, 5 ou 6');

  /// Quantidade de dígitos reservados para o valor, calculada para que
  /// prefixo + código + valor somem sempre 12 dígitos (+ 1 dígito
  /// verificador = 13, um EAN-13 válido).
  int get valueDigits => 12 - prefix.length - productDigits;

  BarcodeConfigModel copyWith({
    String? prefix,
    int? productDigits,
    BarcodeValueType? valueType,
  }) {
    return BarcodeConfigModel(
      prefix: prefix ?? this.prefix,
      productDigits: productDigits ?? this.productDigits,
      valueType: valueType ?? this.valueType,
    );
  }
}
