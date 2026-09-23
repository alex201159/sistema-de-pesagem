import '../../data/models/import_model.dart';
import '../../data/models/product_model.dart';

/// Resultado de uma análise "a seco" (dry-run) de um arquivo de
/// importação, exibido ao operador antes de confirmar (ver escopo,
/// item 5):
///
/// ```text
/// Arquivo: PRODUTOS.TXT
/// Produtos encontrados: 1847
/// Novos: 37
/// Atualizados: 1810
/// Com erro: 0
/// ```
class ImportPreview {
  final String arquivo;
  final int tamanho;
  final String hash;
  final DateTime dataModificacao;

  /// Produtos que passaram em toda a validação e estão prontos para
  /// serem persistidos caso o operador confirme.
  final List<ProductModel> produtosValidos;

  final List<ImportLineError> erros;
  final int novos;
  final int atualizados;

  const ImportPreview({
    required this.arquivo,
    required this.tamanho,
    required this.hash,
    required this.dataModificacao,
    required this.produtosValidos,
    required this.erros,
    required this.novos,
    required this.atualizados,
  });

  int get produtosComErro => erros.length;

  int get quantidadeLinhas => produtosValidos.length + erros.length;

  bool get temErros => erros.isNotEmpty;
}
