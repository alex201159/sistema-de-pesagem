/// Utilitários de conversão e formatação de peso.
///
/// Peso é sempre tratado internamente em quilogramas (kg) com 3 casas
/// decimais, que é a precisão típica de balanças comerciais (gramas).
class WeightUtils {
  WeightUtils._();

  static const int decimalPlaces = 3;

  /// Arredonda um peso em kg para 3 casas decimais.
  static double round(double kg) {
    final factor = 1000;
    return (kg * factor).round() / factor;
  }

  /// Converte gramas para quilogramas.
  static double gramsToKg(num grams) => grams / 1000.0;

  /// Converte quilogramas para gramas (inteiro).
  static int kgToGrams(double kg) => (kg * 1000).round();

  /// Formata o peso no padrão "0,485 kg".
  static String format(double kg, {bool withUnit = true}) {
    final formatted = kg.toStringAsFixed(decimalPlaces).replaceAll('.', ',');
    return withUnit ? '$formatted kg' : formatted;
  }

  /// Indica se um peso é considerado válido para uma pesagem comercial
  /// (maior que zero e dentro de uma faixa plausível de balança de
  /// bancada/comércio).
  static bool isPlausible(double kg, {double maxKg = 60}) {
    return kg > 0 && kg <= maxKg;
  }
}
