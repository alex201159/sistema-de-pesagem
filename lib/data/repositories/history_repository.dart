import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/import_model.dart';

/// Acesso a dados do histórico de importações (ver escopo, item 9).
///
/// Chamado por `ImportService` ao final de cada tentativa de
/// importação, com sucesso ou falha — todo evento é registrado.
class HistoryRepository {
  final AppDatabase _db;

  HistoryRepository(this._db);

  ImportModel _mapRow(ImportHistoryData row) => ImportModel(
        id: row.id,
        arquivo: row.arquivo,
        tamanho: row.tamanho,
        hash: row.hash,
        dataModificacao: row.dataModificacao,
        dataImportacao: row.dataImportacao,
        quantidadeLinhas: row.quantidadeLinhas,
        produtosNovos: row.produtosNovos,
        produtosAtualizados: row.produtosAtualizados,
        produtosComErro: row.produtosComErro,
        status: ImportStatus.fromName(row.status),
        mensagem: row.mensagem,
        erros: ImportLineError.decodeList(row.erros),
      );

  ImportHistoryCompanion _toCompanion(ImportModel model) => ImportHistoryCompanion(
        id: model.id == null ? const Value.absent() : Value(model.id!),
        arquivo: Value(model.arquivo),
        tamanho: Value(model.tamanho),
        hash: Value(model.hash),
        dataModificacao: Value(model.dataModificacao),
        dataImportacao: Value(model.dataImportacao),
        quantidadeLinhas: Value(model.quantidadeLinhas),
        produtosNovos: Value(model.produtosNovos),
        produtosAtualizados: Value(model.produtosAtualizados),
        produtosComErro: Value(model.produtosComErro),
        status: Value(model.status.name),
        mensagem: Value(model.mensagem),
        erros: Value(ImportLineError.encodeList(model.erros)),
      );

  Future<int> insert(ImportModel import) =>
      _db.into(_db.importHistory).insert(_toCompanion(import));

  /// Verifica se um arquivo com o mesmo hash já foi importado com
  /// sucesso, para evitar reimportar conteúdo inalterado
  /// (ver escopo, item 7).
  Future<bool> wasAlreadyImported(String hash) async {
    final row = await (_db.select(_db.importHistory)
          ..where((t) => t.hash.equals(hash) & t.status.equals(ImportStatus.sucesso.name))
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  Future<List<ImportModel>> getRecent({int limit = 100}) async {
    final rows = await (_db.select(_db.importHistory)
          ..orderBy([(t) => OrderingTerm(expression: t.dataImportacao, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
    return rows.map(_mapRow).toList();
  }

  Stream<List<ImportModel>> watchRecent({int limit = 100}) {
    final q = _db.select(_db.importHistory)
      ..orderBy([(t) => OrderingTerm(expression: t.dataImportacao, mode: OrderingMode.desc)])
      ..limit(limit);
    return q.watch().map((rows) => rows.map(_mapRow).toList());
  }

  Future<ImportModel?> getById(int id) async {
    final row =
        await (_db.select(_db.importHistory)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }
}
