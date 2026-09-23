/// Tipos de elemento suportados pelo editor de etiquetas
/// (ver escopo, itens 22 e 24).
enum LabelElementType {
  produto,
  codigo,
  plu,
  peso,
  precoKg,
  total,
  data,
  hora,
  validade,
  codigoBarras,
  qrCode,
  textoLivre,
  logotipo,
  linha,
  retangulo;

  /// Placeholder textual correspondente, quando o elemento representa
  /// um campo dinâmico (ver escopo, item 24).
  String? get placeholder => switch (this) {
        LabelElementType.produto => '{PRODUTO}',
        LabelElementType.codigo => '{CODIGO}',
        LabelElementType.plu => '{PLU}',
        LabelElementType.peso => '{PESO}',
        LabelElementType.precoKg => '{PRECO_KG}',
        LabelElementType.total => '{TOTAL}',
        LabelElementType.data => '{DATA}',
        LabelElementType.hora => '{HORA}',
        LabelElementType.validade => '{VALIDADE}',
        LabelElementType.codigoBarras => '{CODIGO_BARRAS}',
        LabelElementType.qrCode => null,
        LabelElementType.textoLivre => null,
        LabelElementType.logotipo => null,
        LabelElementType.linha => null,
        LabelElementType.retangulo => null,
      };
}

enum LabelTextAlign { left, center, right }

/// Um elemento posicionável dentro de uma etiqueta (arrastável no
/// editor visual, ver escopo item 23).
class LabelElementModel {
  final int? id;
  final int labelId;
  final LabelElementType tipo;

  /// Posição e tamanho em milímetros, relativos ao canto superior
  /// esquerdo da etiqueta.
  final double x;
  final double y;
  final double largura;
  final double altura;

  /// Rotação em graus (0, 90, 180, 270).
  final double rotacao;

  final String fonteFamilia;
  final double fonteTamanho;
  final bool negrito;
  final LabelTextAlign alinhamento;

  /// Conteúdo livre, usado apenas quando [tipo] é [LabelElementType.textoLivre].
  final String? conteudoLivre;

  /// Ordem de empilhamento (z-index) dentro da etiqueta.
  final int ordem;

  const LabelElementModel({
    this.id,
    required this.labelId,
    required this.tipo,
    required this.x,
    required this.y,
    required this.largura,
    required this.altura,
    this.rotacao = 0,
    this.fonteFamilia = 'Roboto',
    this.fonteTamanho = 10,
    this.negrito = false,
    this.alinhamento = LabelTextAlign.left,
    this.conteudoLivre,
    this.ordem = 0,
  });

  /// Serializa para envio via rede (ver escopo — sincronizador Windows/
  /// Mac, `POST /import-label`). `id`/`labelId` ficam fora: são
  /// atribuídos pelo totem ao salvar, não fazem parte do transporte.
  Map<String, dynamic> toJson() => {
        'tipo': tipo.name,
        'x': x,
        'y': y,
        'largura': largura,
        'altura': altura,
        'rotacao': rotacao,
        'fonteFamilia': fonteFamilia,
        'fonteTamanho': fonteTamanho,
        'negrito': negrito,
        'alinhamento': alinhamento.name,
        'conteudoLivre': conteudoLivre,
        'ordem': ordem,
      };

  factory LabelElementModel.fromJson(Map<String, dynamic> json) {
    return LabelElementModel(
      labelId: 0,
      tipo: LabelElementType.values.firstWhere((e) => e.name == json['tipo']),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      largura: (json['largura'] as num).toDouble(),
      altura: (json['altura'] as num).toDouble(),
      rotacao: (json['rotacao'] as num?)?.toDouble() ?? 0,
      fonteFamilia: json['fonteFamilia'] as String? ?? 'Roboto',
      fonteTamanho: (json['fonteTamanho'] as num?)?.toDouble() ?? 10,
      negrito: json['negrito'] as bool? ?? false,
      alinhamento: LabelTextAlign.values.firstWhere(
        (e) => e.name == json['alinhamento'],
        orElse: () => LabelTextAlign.left,
      ),
      conteudoLivre: json['conteudoLivre'] as String?,
      ordem: (json['ordem'] as num?)?.toInt() ?? 0,
    );
  }

  LabelElementModel copyWith({
    int? id,
    int? labelId,
    LabelElementType? tipo,
    double? x,
    double? y,
    double? largura,
    double? altura,
    double? rotacao,
    String? fonteFamilia,
    double? fonteTamanho,
    bool? negrito,
    LabelTextAlign? alinhamento,
    String? conteudoLivre,
    int? ordem,
  }) {
    return LabelElementModel(
      id: id ?? this.id,
      labelId: labelId ?? this.labelId,
      tipo: tipo ?? this.tipo,
      x: x ?? this.x,
      y: y ?? this.y,
      largura: largura ?? this.largura,
      altura: altura ?? this.altura,
      rotacao: rotacao ?? this.rotacao,
      fonteFamilia: fonteFamilia ?? this.fonteFamilia,
      fonteTamanho: fonteTamanho ?? this.fonteTamanho,
      negrito: negrito ?? this.negrito,
      alinhamento: alinhamento ?? this.alinhamento,
      conteudoLivre: conteudoLivre ?? this.conteudoLivre,
      ordem: ordem ?? this.ordem,
    );
  }
}
