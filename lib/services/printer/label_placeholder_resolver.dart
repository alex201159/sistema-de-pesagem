import '../../core/utils/currency_utils.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/weight_utils.dart';
import '../../data/models/label_element_model.dart';
import 'printer_service.dart';

/// Resolve o texto exibido/impresso de um elemento de etiqueta a
/// partir dos dados de uma pesagem (ver escopo, item 24 —
/// placeholders `{PRODUTO}`, `{PESO}`, etc.).
///
/// Compartilhado entre o driver de impressão ([TsplDriver]) e o editor
/// visual (Etapa 6) para que a etiqueta impressa e sua pré-visualização
/// nunca divirjam na formatação (mesmas regras de moeda/peso/data já
/// centralizadas em `core/utils`).
class LabelPlaceholderResolver {
  LabelPlaceholderResolver._();

  static String resolve(LabelElementModel element, LabelPrintData data) {
    return switch (element.tipo) {
      LabelElementType.produto => data.produto,
      LabelElementType.codigo => data.codigo,
      // O modelo de impressão ainda não carrega um PLU distinto do
      // código do produto — usa o mesmo valor até que
      // `LabelPrintData` seja estendido com esse campo.
      LabelElementType.plu => data.codigo,
      LabelElementType.peso => data.porUnidade
          ? '${data.peso.round()} un'
          : WeightUtils.format(data.peso),
      LabelElementType.precoKg => CurrencyUtils.format(data.precoKg),
      LabelElementType.total => CurrencyUtils.format(data.total),
      LabelElementType.data => AppDateUtils.formatDate(data.dataHora),
      LabelElementType.hora => AppDateUtils.formatTime(data.dataHora),
      LabelElementType.validade =>
        data.validade == null ? '' : AppDateUtils.formatDate(data.validade!),
      LabelElementType.codigoBarras => data.codigoBarras,
      LabelElementType.textoLivre => element.conteudoLivre ?? '',
      LabelElementType.qrCode ||
      LabelElementType.logotipo ||
      LabelElementType.linha ||
      LabelElementType.retangulo =>
        '',
    };
  }

  /// Dados de exemplo para pré-visualização (editor/preview de
  /// etiqueta), com os mesmos valores de referência usados na
  /// configuração do código de barras (ver escopo, item 25).
  static LabelPrintData sampleData() {
    return LabelPrintData(
      produto: 'QUEIJO MUSSARELA',
      codigo: '125',
      peso: 0.485,
      precoKg: 42.90,
      total: 20.81,
      codigoBarras: '2125000208105',
      dataHora: DateTime.now(),
      validade: DateTime.now().add(const Duration(days: 10)),
    );
  }
}
