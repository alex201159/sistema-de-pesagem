import '../../data/models/import_model.dart';

/// Uma linha de produto já decodificada estruturalmente do arquivo
/// bruto, antes de qualquer validação de regra de negócio (ver
/// `ImportValidator`).
class ParsedProductRow {
  final int lineNumber;
  final String rawLine;

  /// Código de departamento/seção do ERP, preservado como veio no
  /// arquivo (ex.: "010", "011"). Não possui significado assumido por
  /// este app — ver escopo, item 60 (não inventar formato).
  final String departamento;

  /// Código/PLU do produto, já sem zeros à esquerda (ex.: "59"),
  /// pronto para ser digitado no teclado numérico do totem.
  final String codigo;

  final double preco;
  final String descricao;

  /// `true` quando o produto é vendido por unidade (ex.: um bolo
  /// inteiro), `false` quando é vendido por peso/kg (a maioria). Vem
  /// de um bit real do arquivo — ver `ItensMgvParser`.
  final bool porUnidade;

  /// Dias de validade do produto a partir da pesagem/embalagem, vindos
  /// do arquivo — `null` quando o arquivo não define uma validade fixa
  /// (ver `ItensMgvParser` para os valores especiais do layout
  /// oficial). Quando presente, alimenta `ProductModel.validadeDias` e
  /// sai impresso na etiqueta (placeholder `{VALIDADE}`).
  final int? validadeDias;

  const ParsedProductRow({
    required this.lineNumber,
    required this.rawLine,
    required this.departamento,
    required this.codigo,
    required this.preco,
    required this.descricao,
    this.porUnidade = false,
    this.validadeDias,
  });
}

/// Resultado de uma decodificação estrutural de arquivo: linhas que
/// puderam ser decodificadas + erros de linhas que não seguiram o
/// layout esperado. Nenhuma linha inválida é descartada silenciosamente
/// (ver escopo, item 55).
class FileParseResult {
  final List<ParsedProductRow> rows;
  final List<ImportLineError> errors;

  const FileParseResult({required this.rows, required this.errors});
}

/// Contrato para um leitor de arquivo de produtos de um ERP específico.
///
/// Cada sistema externo (ver escopo, item 54) ganha sua própria
/// implementação (ex.: `ItensMgvParser`), permitindo adicionar novos
/// formatos no futuro sem alterar o restante da aplicação.
abstract class ProductFileParser {
  /// Nome identificador do formato (ex.: "ITENSMGV"), usado em logs e
  /// no histórico de importação.
  String get formatName;

  /// Indica se este parser reconhece o arquivo, usado para seleção
  /// automática quando houver mais de um parser registrado.
  bool canParse(String fileName, List<int> bytes);

  /// Decodifica o conteúdo bruto do arquivo em linhas de produto.
  FileParseResult parse(String fileName, List<int> bytes);
}
