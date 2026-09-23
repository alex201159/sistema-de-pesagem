import 'dart:convert';

/// Resultado geral de uma importação (ver escopo, itens 5 e 9).
enum ImportStatus {
  sucesso,
  parcial,
  erro;

  String get label => switch (this) {
        ImportStatus.sucesso => 'SUCESSO',
        ImportStatus.parcial => 'PARCIAL',
        ImportStatus.erro => 'ERRO',
      };

  static ImportStatus fromName(String name) =>
      ImportStatus.values.firstWhere((e) => e.name == name, orElse: () => ImportStatus.erro);
}

/// Um erro de linha individual, nunca descartado silenciosamente
/// (ver escopo, item 55).
class ImportLineError {
  final int linha;
  final String motivo;
  final String? conteudo;

  const ImportLineError({required this.linha, required this.motivo, this.conteudo});

  Map<String, dynamic> toJson() => {'linha': linha, 'motivo': motivo, 'conteudo': conteudo};

  factory ImportLineError.fromJson(Map<String, dynamic> json) => ImportLineError(
        linha: json['linha'] as int,
        motivo: json['motivo'] as String,
        conteudo: json['conteudo'] as String?,
      );

  static String encodeList(List<ImportLineError> errors) =>
      jsonEncode(errors.map((e) => e.toJson()).toList());

  static List<ImportLineError> decodeList(String? json) {
    if (json == null || json.isEmpty) return const [];
    final decoded = jsonDecode(json) as List<dynamic>;
    return decoded.map((e) => ImportLineError.fromJson(e as Map<String, dynamic>)).toList();
  }
}

/// Registro de uma importação executada (manual ou automática via SMB),
/// persistido em `import_history` (ver escopo, item 9).
class ImportModel {
  final int? id;
  final String arquivo;
  final int tamanho;
  final String hash;
  final DateTime dataModificacao;
  final DateTime dataImportacao;
  final int quantidadeLinhas;
  final int produtosNovos;
  final int produtosAtualizados;
  final int produtosComErro;
  final ImportStatus status;
  final String? mensagem;
  final List<ImportLineError> erros;

  const ImportModel({
    this.id,
    required this.arquivo,
    required this.tamanho,
    required this.hash,
    required this.dataModificacao,
    required this.dataImportacao,
    required this.quantidadeLinhas,
    required this.produtosNovos,
    required this.produtosAtualizados,
    required this.produtosComErro,
    required this.status,
    this.mensagem,
    this.erros = const [],
  });

  ImportModel copyWith({
    int? id,
    String? arquivo,
    int? tamanho,
    String? hash,
    DateTime? dataModificacao,
    DateTime? dataImportacao,
    int? quantidadeLinhas,
    int? produtosNovos,
    int? produtosAtualizados,
    int? produtosComErro,
    ImportStatus? status,
    String? mensagem,
    List<ImportLineError>? erros,
  }) {
    return ImportModel(
      id: id ?? this.id,
      arquivo: arquivo ?? this.arquivo,
      tamanho: tamanho ?? this.tamanho,
      hash: hash ?? this.hash,
      dataModificacao: dataModificacao ?? this.dataModificacao,
      dataImportacao: dataImportacao ?? this.dataImportacao,
      quantidadeLinhas: quantidadeLinhas ?? this.quantidadeLinhas,
      produtosNovos: produtosNovos ?? this.produtosNovos,
      produtosAtualizados: produtosAtualizados ?? this.produtosAtualizados,
      produtosComErro: produtosComErro ?? this.produtosComErro,
      status: status ?? this.status,
      mensagem: mensagem ?? this.mensagem,
      erros: erros ?? this.erros,
    );
  }
}
