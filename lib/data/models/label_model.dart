import 'label_element_model.dart';

/// Perfil/layout de etiqueta (ver escopo, item 26: "60x40 PADRÃO",
/// "60x40 AÇOUGUE", etc.).
class LabelModel {
  final int? id;
  final String nome;
  final double larguraMm;
  final double alturaMm;
  final bool padrao;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  /// Elementos posicionados na etiqueta. Carregado separadamente pelo
  /// repository (join com a tabela de elementos), pode vir vazio caso
  /// a consulta não os tenha incluído.
  final List<LabelElementModel> elementos;

  const LabelModel({
    this.id,
    required this.nome,
    required this.larguraMm,
    required this.alturaMm,
    this.padrao = false,
    required this.dataCriacao,
    required this.dataAtualizacao,
    this.elementos = const [],
  });

  /// Layout embutido usado quando o operador ainda não criou nenhum
  /// perfil no editor visual (Etapa 6) — garante que a impressão
  /// funcione desde a primeira venda, sem depender de configuração
  /// prévia. 60x40mm, seguindo o exemplo de referência do escopo
  /// (item 25).
  factory LabelModel.builtInDefault() {
    final now = DateTime.now();
    return LabelModel(
      nome: 'Padrão embutido',
      larguraMm: 60,
      alturaMm: 40,
      padrao: false,
      dataCriacao: now,
      dataAtualizacao: now,
      elementos: [
        LabelElementModel(
          labelId: 0,
          tipo: LabelElementType.produto,
          x: 2,
          y: 2,
          largura: 56,
          altura: 6,
          fonteTamanho: 10,
          negrito: true,
          ordem: 0,
        ),
        LabelElementModel(
          labelId: 0,
          tipo: LabelElementType.peso,
          x: 2,
          y: 10,
          largura: 27,
          altura: 6,
          fonteTamanho: 8,
          ordem: 1,
        ),
        LabelElementModel(
          labelId: 0,
          tipo: LabelElementType.precoKg,
          x: 31,
          y: 10,
          largura: 27,
          altura: 6,
          fonteTamanho: 8,
          alinhamento: LabelTextAlign.right,
          ordem: 2,
        ),
        LabelElementModel(
          labelId: 0,
          tipo: LabelElementType.total,
          x: 2,
          y: 18,
          largura: 56,
          altura: 8,
          fonteTamanho: 12,
          negrito: true,
          ordem: 3,
        ),
        LabelElementModel(
          labelId: 0,
          tipo: LabelElementType.codigoBarras,
          x: 2,
          y: 28,
          largura: 56,
          altura: 8,
          ordem: 4,
        ),
        LabelElementModel(
          labelId: 0,
          tipo: LabelElementType.validade,
          x: 2,
          y: 37,
          largura: 56,
          altura: 3,
          fonteTamanho: 6,
          ordem: 5,
        ),
      ],
    );
  }

  /// Serializa para envio via rede (ver escopo — sincronizador Windows/
  /// Mac, `POST /import-label`). `id`/`dataCriacao`/`dataAtualizacao`
  /// ficam fora: são atribuídos/preservados pelo totem ao salvar.
  Map<String, dynamic> toJson() => {
        'nome': nome,
        'larguraMm': larguraMm,
        'alturaMm': alturaMm,
        'elementos': elementos.map((e) => e.toJson()).toList(),
      };

  factory LabelModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return LabelModel(
      nome: json['nome'] as String,
      larguraMm: (json['larguraMm'] as num).toDouble(),
      alturaMm: (json['alturaMm'] as num).toDouble(),
      dataCriacao: now,
      dataAtualizacao: now,
      elementos: (json['elementos'] as List<dynamic>? ?? [])
          .map((e) => LabelElementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  LabelModel copyWith({
    int? id,
    String? nome,
    double? larguraMm,
    double? alturaMm,
    bool? padrao,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    List<LabelElementModel>? elementos,
  }) {
    return LabelModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      larguraMm: larguraMm ?? this.larguraMm,
      alturaMm: alturaMm ?? this.alturaMm,
      padrao: padrao ?? this.padrao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      elementos: elementos ?? this.elementos,
    );
  }
}
