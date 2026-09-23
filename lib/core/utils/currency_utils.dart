import 'package:intl/intl.dart';

/// Regras financeiras centralizadas do aplicativo.
///
/// Todo cálculo monetário deve passar por aqui para evitar duplicação de
/// regras de arredondamento entre telas (ver escopo, item 16).
///
/// Valores monetários são tratados internamente em CENTAVOS (inteiros)
/// para evitar erros de ponto flutuante. As telas/serviços trabalham com
/// `double` (reais) na entrada/saída, mas o arredondamento sempre ocorre
/// convertendo para centavos.
class CurrencyUtils {
  CurrencyUtils._();

  /// Caractere non-breaking space (U+00A0) usado pelo `NumberFormat`
  /// do pacote `intl` entre o símbolo da moeda e o valor.
  static final String _nbsp = String.fromCharCode(0xA0);

  static final NumberFormat _brFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  /// Converte um valor em reais para centavos, arredondando para o
  /// centavo mais próximo (arredondamento comercial: 0,5 sobe).
  static int toCents(double reais) => (reais * 100).round();

  /// Converte centavos para reais.
  static double fromCents(int cents) => cents / 100.0;

  /// Arredonda um valor em reais para 2 casas decimais usando a mesma
  /// regra de arredondamento comercial usada em toda a aplicação.
  static double round(double reais) => fromCents(toCents(reais));

  /// Calcula o total de uma pesagem: peso (kg) × preço por kg (R$),
  /// já arredondado para 2 casas decimais.
  ///
  /// Exemplo: peso=0.485, precoKg=42.90 -> 20.8065 -> 20.81
  static double calculateTotal({
    required double weightKg,
    required double pricePerKg,
  }) {
    final rawTotal = weightKg * pricePerKg;
    return round(rawTotal);
  }

  /// Formata um valor em reais no padrão brasileiro: R$ 20,81
  ///
  /// O NBSP inserido pelo `NumberFormat` é normalizado para um espaço
  /// comum, evitando comparações e buscas de texto frágeis na UI.
  static String format(double reais) => _brFormat.format(reais).replaceAll(_nbsp, ' ');

  /// Formata sem o símbolo de moeda: 20,81
  static String formatValue(double reais) {
    return format(reais).replaceFirst('R\$', '').trim();
  }

  /// Faz o parse de um valor monetário digitado pelo usuário.
  ///
  /// Aceita "20,81", "20.81", "1.234,56" e "1234.56". Quando ambos os
  /// separadores aparecem, assume o formato brasileiro (ponto = milhar,
  /// vírgula = decimal). Quando só um aparece, é tratado como separador
  /// decimal.
  static double? tryParse(String input) {
    var normalized = input.trim();
    final hasComma = normalized.contains(',');
    final hasDot = normalized.contains('.');

    if (hasComma && hasDot) {
      normalized = normalized.replaceAll('.', '').replaceAll(',', '.');
    } else if (hasComma) {
      normalized = normalized.replaceAll(',', '.');
    }

    return double.tryParse(normalized);
  }
}
