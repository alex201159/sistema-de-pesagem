import '../../../data/models/label_element_model.dart';
import '../../../data/models/label_model.dart';
import '../label_placeholder_resolver.dart';
import '../printer_service.dart';
import 'printer_driver.dart';

/// Driver TSPL — protocolo de comandos usado pela impressora térmica
/// de etiquetas já validada em campo (ver escopo, item 29).
///
/// Converte os elementos posicionáveis de [LabelModel] (editor visual,
/// Etapa 6) em comandos TSPL (`SIZE/GAP/CLS/TEXT/BARCODE/QRCODE/BAR/
/// BOX/PRINT`), resolvendo os placeholders de [LabelElementType] a
/// partir de [LabelPrintData]. ESC/POS/CPCL/ZPL ficam como próxima
/// extensão atrás da mesma interface [PrinterDriver] — não há
/// impressora com esses protocolos em uso hoje.
class TsplDriver implements PrinterDriver {
  /// Resolução da impressora em dots por milímetro. 8 dots/mm
  /// corresponde a 203 DPI, o padrão da maioria das impressoras de
  /// etiqueta térmicas de balcão (mesma referência usada no app irmão
  /// que já imprime em produção).
  const TsplDriver({this.dotsPerMm = 8});

  final int dotsPerMm;

  @override
  List<int> render(LabelModel label, LabelPrintData data) {
    final buffer = StringBuffer();
    final widthMm = label.larguraMm.round();
    final heightMm = label.alturaMm.round();

    buffer.writeln('SIZE $widthMm mm,$heightMm mm');
    buffer.writeln('GAP 2 mm,0');
    buffer.writeln('DIRECTION 1');
    buffer.writeln('CLS');

    final sortedElements = [...label.elementos]..sort((a, b) => a.ordem.compareTo(b.ordem));
    for (final element in sortedElements) {
      final command = _renderElement(element, data);
      if (command != null) buffer.writeln(command);
    }

    buffer.writeln('PRINT 1');
    return buffer.toString().codeUnits;
  }

  String? _renderElement(LabelElementModel element, LabelPrintData data) {
    final x = _mm(element.x);
    final y = _mm(element.y);
    final rotation = element.rotacao.round();

    switch (element.tipo) {
      case LabelElementType.linha:
        return 'BAR $x,$y,${_mm(element.largura)},${_mm(element.altura).clamp(1, 999)}';

      case LabelElementType.retangulo:
        return 'BOX $x,$y,${x + _mm(element.largura)},${y + _mm(element.altura)},2';

      case LabelElementType.qrCode:
        if (data.codigoBarras.isEmpty) return null;
        return 'QRCODE $x,$y,H,4,A,$rotation,"${_escape(data.codigoBarras)}"';

      case LabelElementType.codigoBarras:
        if (data.codigoBarras.isEmpty) return null;
        final height = _mm(element.altura).clamp(10, 999);
        return 'BARCODE $x,$y,"128",$height,1,$rotation,2,2,"${_escape(data.codigoBarras)}"';

      case LabelElementType.logotipo:
        // Upload/armazenamento de imagem de logo ainda não é suportado
        // (exigiria comando BITMAP + um repositório de assets) — o
        // elemento é ignorado na impressão em vez de quebrar a
        // etiqueta inteira.
        return null;

      default:
        final text = LabelPlaceholderResolver.resolve(element, data);
        if (text.isEmpty) return null;
        final scale = (element.fonteTamanho / 8).round().clamp(1, 6);
        final font = element.negrito ? '3' : '2';
        final alignedX = _alignedX(element, text, scale);
        return 'TEXT $alignedX,$y,"$font",$rotation,$scale,$scale,"${_escape(text)}"';
    }
  }

  /// Alinha o texto dentro da própria caixa do elemento
  /// ([LabelElementModel.x] até `x + largura`), não da etiqueta
  /// inteira — cada elemento é posicionado/dimensionado
  /// individualmente no editor visual (Etapa 6).
  int _alignedX(LabelElementModel element, String text, int scale) {
    final boxX = _mm(element.x);
    if (element.alinhamento == LabelTextAlign.left) return boxX;

    final boxWidthDots = _mm(element.largura);
    // Largura aproximada de um caractere na fonte embutida "2"/"3" do
    // TSPL em escala 1 — suficiente para centralizar/alinhar à
    // direita sem depender de métricas exatas de fonte da impressora.
    const baseCharWidthDots = 12;
    final textWidthDots = text.length * baseCharWidthDots * scale;

    if (element.alinhamento == LabelTextAlign.center) {
      return boxX + ((boxWidthDots - textWidthDots) / 2).round().clamp(0, boxWidthDots);
    }
    return boxX + (boxWidthDots - textWidthDots).clamp(0, boxWidthDots).round();
  }

  int _mm(double mm) => (mm * dotsPerMm).round();

  String _escape(String text) {
    return text.replaceAll('"', '').replaceAll('\n', ' ').replaceAll('\r', ' ').trim();
  }
}
