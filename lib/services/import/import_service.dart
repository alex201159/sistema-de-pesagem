import 'dart:io';

import 'package:path/path.dart' as p;

import '../../core/errors/import_exception.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/file_utils.dart';
import '../../data/models/import_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/repositories/product_repository.dart';
import 'file_parser.dart';
import 'import_preview.dart';
import 'import_validator.dart';

/// Orquestra a importação de produtos: decodifica (via
/// [ProductFileParser]), valida (via [ImportValidator]), compara com
/// o banco atual e persiste — sempre registrando o resultado no
/// histórico, com sucesso ou falha (ver escopo, itens 5, 9, 55-57).
///
/// Fluxo de duas etapas, espelhando a tela de confirmação (item 5):
/// 1. [analyze] — leitura e validação "a seco", sem gravar nada.
/// 2. [execute] — grava os produtos válidos em uma única transação e
///    registra o histórico.
class ImportService {
  final ProductFileParser _parser;
  final ImportValidator _validator;
  final ProductRepository _productRepository;
  final HistoryRepository _historyRepository;

  ImportService({
    required ProductFileParser parser,
    required ImportValidator validator,
    required ProductRepository productRepository,
    required HistoryRepository historyRepository,
  })  : _parser = parser,
        _validator = validator,
        _productRepository = productRepository,
        _historyRepository = historyRepository;

  Future<ImportPreview> analyze(File file) async {
    final bytes = await file.readAsBytes();
    final stat = await file.stat();
    final fileName = p.basename(file.path);
    final hash = FileUtils.calculateSha256Bytes(bytes);

    if (!_parser.canParse(fileName, bytes)) {
      throw ImportException('Formato de arquivo não reconhecido: $fileName');
    }

    final parseResult = _parser.parse(fileName, bytes);
    final now = DateTime.now();

    final produtosValidos = <ProductModel>[];
    final erros = [...parseResult.errors];

    for (final row in parseResult.rows) {
      final result = _validator.validate(row, now);
      if (result.isValid) {
        produtosValidos.add(result.product!);
      } else {
        erros.add(result.error!);
      }
    }

    var novos = 0;
    var atualizados = 0;
    for (final product in produtosValidos) {
      final existing = await _productRepository.getByCodigo(product.codigo);
      if (existing == null) {
        novos++;
      } else {
        atualizados++;
      }
    }

    return ImportPreview(
      arquivo: fileName,
      tamanho: bytes.length,
      hash: hash,
      dataModificacao: stat.modified,
      produtosValidos: produtosValidos,
      erros: erros,
      novos: novos,
      atualizados: atualizados,
    );
  }

  /// Confirma a importação: grava os produtos válidos do [preview] em
  /// uma única transação e registra o histórico, mesmo em caso de
  /// falha crítica na gravação.
  Future<ImportModel> execute(ImportPreview preview) async {
    ImportStatus status;
    String? mensagem;

    try {
      await _productRepository.upsertAll(preview.produtosValidos);
      status = preview.temErros ? ImportStatus.parcial : ImportStatus.sucesso;
      AppLogger.i(
        'Importação de ${preview.arquivo} concluída: '
        '${preview.novos} novos, ${preview.atualizados} atualizados, '
        '${preview.produtosComErro} com erro.',
      );
    } catch (e, st) {
      AppLogger.e('Falha crítica ao importar ${preview.arquivo}', e, st);
      status = ImportStatus.erro;
      mensagem = 'Falha ao gravar produtos no banco de dados: $e';
    }

    final importModel = ImportModel(
      arquivo: preview.arquivo,
      tamanho: preview.tamanho,
      hash: preview.hash,
      dataModificacao: preview.dataModificacao,
      dataImportacao: DateTime.now(),
      quantidadeLinhas: preview.quantidadeLinhas,
      produtosNovos: preview.novos,
      produtosAtualizados: preview.atualizados,
      produtosComErro: preview.produtosComErro,
      status: status,
      mensagem: mensagem,
      erros: preview.erros,
    );

    final id = await _historyRepository.insert(importModel);
    return importModel.copyWith(id: id);
  }

  /// Verifica se um arquivo com este hash já foi importado com
  /// sucesso — usado pela importação automática (SMB) para evitar
  /// reimportar conteúdo inalterado (ver escopo, item 7). A importação
  /// manual (item 5) não usa este atalho: o operador que escolheu o
  /// arquivo deve poder sempre reimportá-lo.
  Future<bool> wasAlreadyImported(String hash) => _historyRepository.wasAlreadyImported(hash);
}
