/// Utilitários genéricos de código de barras.
///
/// A regra de MONTAGEM do código (prefixo + PLU + valor + dígito
/// verificador, configurável pelo usuário) fica em
/// `services/barcode/barcode_format_service.dart` (Etapa 5). Este
/// arquivo contém apenas operações elementares e reutilizáveis.
class BarcodeUtils {
  BarcodeUtils._();

  /// Preenche um código com zeros à esquerda até [length] dígitos.
  /// Exemplo: pad('125', 5) -> '00125'.
  static String pad(String value, int length) => value.padLeft(length, '0');

  /// Verifica se a string contém apenas dígitos.
  static bool isNumeric(String value) =>
      value.isNotEmpty && RegExp(r'^\d+$').hasMatch(value);

  /// Calcula o dígito verificador padrão EAN-13/GTIN a partir dos 12
  /// primeiros dígitos (algoritmo módulo 10, peso 3/1 alternado a
  /// partir da direita).
  ///
  /// Lança [ArgumentError] se [digits12] não tiver exatamente 12
  /// dígitos numéricos.
  static int calculateEan13CheckDigit(String digits12) {
    if (digits12.length != 12 || !isNumeric(digits12)) {
      throw ArgumentError('Esperado 12 dígitos numéricos, recebido: $digits12');
    }
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      final digit = int.parse(digits12[i]);
      // Posições da direita para a esquerda alternam peso 3 e 1.
      // Como temos 12 dígitos (índices 0..11), o dígito mais à direita
      // (índice 11) recebe peso 3.
      final weight = (i % 2 == 0) ? 1 : 3;
      sum += digit * weight;
    }
    final mod = sum % 10;
    return mod == 0 ? 0 : 10 - mod;
  }

  /// Monta um EAN-13 completo a partir de 12 dígitos, calculando e
  /// anexando o dígito verificador.
  static String buildEan13(String digits12) {
    final check = calculateEan13CheckDigit(digits12);
    return '$digits12$check';
  }

  /// Valida se um EAN-13 completo (13 dígitos) possui dígito
  /// verificador correto.
  static bool isValidEan13(String ean13) {
    if (ean13.length != 13 || !isNumeric(ean13)) return false;
    final expected = calculateEan13CheckDigit(ean13.substring(0, 12));
    return expected == int.parse(ean13[12]);
  }
}
