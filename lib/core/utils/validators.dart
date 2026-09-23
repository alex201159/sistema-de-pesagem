import 'currency_utils.dart';

/// Validações reutilizáveis de campos de domínio (produto, preço, etc.).
///
/// Usadas tanto pelo parser de importação (para reportar linhas
/// inválidas, ver escopo item 55) quanto por formulários de UI.
class Validators {
  Validators._();

  /// Um preço é válido se for maior que zero e possuir no máximo 2
  /// casas decimais relevantes (não impomos limite superior, pois
  /// produtos como carnes nobres podem ter preços altos por kg).
  static bool isValidPrice(double? price) => price != null && price > 0 && price.isFinite;

  static bool isValidWeight(double? weightKg) =>
      weightKg != null && weightKg > 0 && weightKg.isFinite;

  /// Código/PLU deve ser numérico e não vazio.
  static bool isValidProductCode(String? code) {
    if (code == null || code.trim().isEmpty) return false;
    return RegExp(r'^\d+$').hasMatch(code.trim());
  }

  static bool isValidDescription(String? description) =>
      description != null && description.trim().isNotEmpty;

  /// Faz o parse "tolerante" de um preço em texto (aceita vírgula ou
  /// ponto decimal) retornando null se inválido.
  static double? parsePrice(String? raw) {
    if (raw == null) return null;
    final value = CurrencyUtils.tryParse(raw);
    return isValidPrice(value) ? value : null;
  }

  static bool isValidBarcode(String? barcode) {
    if (barcode == null || barcode.trim().isEmpty) return false;
    return RegExp(r'^\d{6,20}$').hasMatch(barcode.trim());
  }
}
