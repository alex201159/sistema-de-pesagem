import 'package:xml/xml.dart';

import '../../core/errors/label_exception.dart';
import '../../data/models/label_element_model.dart';
import '../../data/models/label_model.dart';

/// Converte um modelo de etiqueta pronto no formato `.sfm` (XML de um
/// editor de balança comercial, ver `assets/etiquetas_prontas/`) para um
/// [LabelModel] editável no editor visual do app (Etapa 6).
///
/// A unidade nativa de posição/tamanho do `.sfm` (`x/y/w/h`) é a mesma
/// usada por [TsplDriver] para imprimir (8 dots/mm — 203 DPI, o padrão
/// da maioria das impressoras térmicas de balcão), confirmado
/// comparando a banda `Header` de vários tamanhos de etiqueta do
/// pacote original contra o nome de suas pastas (ex.: pasta "40x60" →
/// `w=320,h=480` → `320/8=40mm, 480/8=60mm`, exato).
class SfmLabelParser {
  SfmLabelParser._();

  static const double _dotsPerMm = 8;
  static const double _minSizeMm = 2;

  /// Mais da metade dos códigos de barras do pacote original começam
  /// perto de `x=0`, na mesma coluna onde outros textos também começam
  /// — um valor generoso como 50mm (o padrão do editor para um
  /// elemento novo) faria o código de barras cobrir esses textos. 35mm
  /// ainda é larga o suficiente para ficar legível/editável, reduzindo
  /// a sobreposição no caso comum sem piorar os casos onde o código já
  /// nasce mais à direita (aí quem limita é o espaço restante mesmo).
  static const double _defaultBarcodeLarguraMm = 35;

  /// Altura mínima só para `linha` — diferente dos demais elementos, uma
  /// linha separadora fina (ex.: 0.25mm no `.sfm` original) deve
  /// continuar fina; forçá-la a [_minSizeMm] (2mm) a transformaria numa
  /// barra preta grossa, distorcendo o layout original.
  static const double _minLinhaAlturaMm = 0.3;

  /// Campos dinâmicos usados pelo `.sfm` (`<field>`) que têm
  /// equivalente direto em [LabelElementType]. Os demais (quantidade,
  /// tara, lote, dados de conservação/receita/comerciais) não têm
  /// campo correspondente no app e viram texto livre (ver
  /// `LabelPlaceholderResolver`).
  static const Map<int, LabelElementType> _fieldMap = {
    1: LabelElementType.produto,
    2: LabelElementType.validade,
    3: LabelElementType.data,
    4: LabelElementType.peso,
    6: LabelElementType.codigo,
    7: LabelElementType.precoKg,
    15: LabelElementType.total,
    19: LabelElementType.hora,
  };

  static LabelModel parse(String xmlContent, {required String nomeSugerido}) {
    final XmlDocument document;
    try {
      document = XmlDocument.parse(xmlContent);
    } on XmlException catch (e, stackTrace) {
      throw LabelParseException(
        'Arquivo de etiqueta inválido (XML malformado)',
        cause: e,
        stackTrace: stackTrace,
      );
    }

    XmlElement? headerBand;
    for (final shape in document.findAllElements('UCShape')) {
      if (shape.getAttribute('type') == 'UCBand' && _text(shape, 'bandType') == 'Header') {
        headerBand = shape;
        break;
      }
    }
    if (headerBand == null) {
      throw const LabelParseException('Modelo de etiqueta sem banda "Header"');
    }

    final larguraMm = _double(headerBand, 'w') / _dotsPerMm;
    final alturaMm = _double(headerBand, 'h') / _dotsPerMm;
    if (larguraMm <= 0 || alturaMm <= 0) {
      throw const LabelParseException('Modelo de etiqueta com dimensões inválidas');
    }

    final elementos = <LabelElementModel>[];
    var ordem = 0;
    for (final shape in headerBand.childElements.where((e) => e.name.local == 'UCShape')) {
      final element = switch (shape.getAttribute('type')) {
        'UCText' => _parseText(shape),
        'UCBarcode' => _parseBarcode(shape, larguraMm),
        'UCRect' => _parseRect(shape),
        'UCImage' => _parseImage(shape),
        'UCNutInfoTable' => _parseNutInfoTable(shape),
        _ => null,
      };
      if (element == null) continue;
      elementos.add(_clamp(element.copyWith(ordem: ordem), larguraMm, alturaMm));
      ordem++;
    }

    final now = DateTime.now();
    return LabelModel(
      nome: nomeSugerido,
      larguraMm: larguraMm,
      alturaMm: alturaMm,
      dataCriacao: now,
      dataAtualizacao: now,
      elementos: elementos,
    );
  }

  static LabelElementModel _parseText(XmlElement shape) {
    final field = int.tryParse(_text(shape, 'field') ?? '0') ?? 0;
    final tipo = _fieldMap[field];
    final alinhamento = switch (_text(shape, 'align')) {
      '1' => LabelTextAlign.right,
      '2' => LabelTextAlign.center,
      _ => LabelTextAlign.left,
    };

    // O `.sfm` original não guarda o tamanho da fonte pela altura da
    // caixa (a caixa costuma ser bem maior que o texto real, com
    // margem) — o tamanho vem de `fontHeight`, um multiplicador
    // inteiro (1, 2, 3...) da fonte-base do firmware da balança, igual
    // ao par x-mult/y-mult do comando TSPL `TEXT` que este app já usa
    // para imprimir (`TsplDriver._renderElement`: `scale =
    // (fonteTamanho / 8).round()`) — por isso a mesma escala de 8 por
    // nível aqui, para que a fonte calculada já saia coerente com o
    // que a impressora realmente usaria.
    final fontHeight = int.tryParse(_text(shape, 'fontHeight') ?? '1') ?? 1;

    return LabelElementModel(
      labelId: 0,
      tipo: tipo ?? LabelElementType.textoLivre,
      x: _double(shape, 'x') / _dotsPerMm,
      y: _double(shape, 'y') / _dotsPerMm,
      largura: _double(shape, 'w') / _dotsPerMm,
      altura: _double(shape, 'h') / _dotsPerMm,
      fonteTamanho: (fontHeight * 8).clamp(4, 24).toDouble(),
      alinhamento: alinhamento,
      conteudoLivre: tipo == null ? (_text(shape, 'text') ?? '') : null,
    );
  }

  /// `UCBarcode` nunca informa largura/altura no `.sfm` original — só
  /// `bh` (altura em mm, já nessa unidade, diferente de x/y) e `mw`
  /// (largura do módulo, irrelevante aqui). Usa o mesmo tamanho padrão
  /// que `LabelEditorController._defaultsFor` já usa para um código de
  /// barras novo, limitado ao espaço restante da etiqueta.
  static LabelElementModel _parseBarcode(XmlElement shape, double larguraLabelMm) {
    final x = _double(shape, 'x') / _dotsPerMm;
    final alturaMm = _double(shape, 'bh');
    final larguraDisponivelMm =
        (larguraLabelMm - x - 2).clamp(_minSizeMm, _defaultBarcodeLarguraMm).toDouble();

    return LabelElementModel(
      labelId: 0,
      tipo: LabelElementType.codigoBarras,
      x: x,
      y: _double(shape, 'y') / _dotsPerMm,
      largura: larguraDisponivelMm,
      altura: alturaMm > 0 ? alturaMm : 12,
    );
  }

  /// Retângulos muito baixos (linhas separadoras finas no `.sfm`
  /// original) viram `linha`, igual ao padrão de 1mm de altura que o
  /// editor já usa ao criar uma nova linha manualmente.
  static LabelElementModel _parseRect(XmlElement shape) {
    final altura = _double(shape, 'h') / _dotsPerMm;
    return LabelElementModel(
      labelId: 0,
      tipo: altura <= 2 ? LabelElementType.linha : LabelElementType.retangulo,
      x: _double(shape, 'x') / _dotsPerMm,
      y: _double(shape, 'y') / _dotsPerMm,
      largura: _double(shape, 'w') / _dotsPerMm,
      altura: altura,
    );
  }

  /// A imagem em si (`<img>`, base64) é descartada — o app ainda não
  /// armazena/imprime logotipos (ver `TsplDriver._renderElement`, caso
  /// `logotipo`), então só a posição/tamanho são preservados.
  static LabelElementModel _parseImage(XmlElement shape) {
    return LabelElementModel(
      labelId: 0,
      tipo: LabelElementType.logotipo,
      x: _double(shape, 'x') / _dotsPerMm,
      y: _double(shape, 'y') / _dotsPerMm,
      largura: _double(shape, 'w') / _dotsPerMm,
      altura: _double(shape, 'h') / _dotsPerMm,
    );
  }

  /// Tabela nutricional: não há elemento equivalente no editor. Em vez
  /// de descartar silenciosamente, vira um texto livre no mesmo espaço
  /// avisando o operador para recriar o conteúdo manualmente.
  static LabelElementModel _parseNutInfoTable(XmlElement shape) {
    return LabelElementModel(
      labelId: 0,
      tipo: LabelElementType.textoLivre,
      x: _double(shape, 'x') / _dotsPerMm,
      y: _double(shape, 'y') / _dotsPerMm,
      largura: _double(shape, 'w') / _dotsPerMm,
      altura: _double(shape, 'h') / _dotsPerMm,
      conteudoLivre: '[Tabela nutricional — recriar manualmente]',
    );
  }

  static LabelElementModel _clamp(LabelElementModel e, double larguraMm, double alturaMm) {
    final minAltura = e.tipo == LabelElementType.linha ? _minLinhaAlturaMm : _minSizeMm;
    final largura = e.largura.clamp(_minSizeMm, larguraMm).toDouble();
    final altura = e.altura.clamp(minAltura, alturaMm).toDouble();
    final maxX = (larguraMm - largura).clamp(0, larguraMm).toDouble();
    final maxY = (alturaMm - altura).clamp(0, alturaMm).toDouble();
    return e.copyWith(
      x: e.x.clamp(0, maxX).toDouble(),
      y: e.y.clamp(0, maxY).toDouble(),
      largura: largura,
      altura: altura,
    );
  }

  static String? _text(XmlElement parent, String tag) {
    final matches = parent.findElements(tag);
    return matches.isEmpty ? null : matches.first.innerText;
  }

  static double _double(XmlElement parent, String tag) {
    return double.tryParse(_text(parent, tag) ?? '') ?? 0;
  }
}
