/// Modelo de domínio de Produto.
///
/// Independente da implementação de banco de dados (ver
/// `data/database/tables/products_table.dart` para o mapeamento Drift).
/// O [barcode], quando vindo do arquivo de importação, é preservado
/// EXATAMENTE como recebido — nunca recalculado automaticamente
/// (ver escopo, item 3 e 17).
class ProductModel {
  final int? id;

  /// Código do produto conforme o arquivo do ERP (identificador
  /// usado para casar INSERT/UPDATE na importação).
  final String codigo;

  /// PLU, quando o arquivo distinguir de [codigo]. Se o ERP usar um
  /// único identificador, [plu] pode ser igual a [codigo].
  final String plu;

  final String descricao;

  /// Preço por unidade (normalmente por kg).
  final double preco;

  /// Unidade de venda (KG, UN, etc.).
  final String unidade;

  /// Dias de validade a partir da pesagem/impressão. Null/0 = não se aplica.
  final int? validadeDias;

  /// Código de barras EXATAMENTE como importado, quando fornecido pelo
  /// ERP. Pode ser null caso o app precise montá-lo dinamicamente
  /// (ver `services/barcode/barcode_format_service.dart`).
  final String? codigoBarras;

  final String? departamento;

  final bool ativo;

  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  const ProductModel({
    this.id,
    required this.codigo,
    required this.plu,
    required this.descricao,
    required this.preco,
    required this.unidade,
    this.validadeDias,
    this.codigoBarras,
    this.departamento,
    this.ativo = true,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  ProductModel copyWith({
    int? id,
    String? codigo,
    String? plu,
    String? descricao,
    double? preco,
    String? unidade,
    int? validadeDias,
    String? codigoBarras,
    String? departamento,
    bool? ativo,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) {
    return ProductModel(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      plu: plu ?? this.plu,
      descricao: descricao ?? this.descricao,
      preco: preco ?? this.preco,
      unidade: unidade ?? this.unidade,
      validadeDias: validadeDias ?? this.validadeDias,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      departamento: departamento ?? this.departamento,
      ativo: ativo ?? this.ativo,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  String toString() => 'ProductModel(codigo: $codigo, descricao: $descricao, preco: $preco)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          codigo == other.codigo;

  @override
  int get hashCode => Object.hash(id, codigo);
}
