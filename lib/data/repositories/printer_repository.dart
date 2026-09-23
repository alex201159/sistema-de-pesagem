import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/printer_model.dart';

/// Acesso a dados de impressoras térmicas conhecidas/pareadas
/// (ver escopo, item 30).
class PrinterRepository {
  final AppDatabase _db;

  PrinterRepository(this._db);

  PrinterModel _mapRow(Printer row) => PrinterModel(
        id: row.id,
        nome: row.nome,
        endereco: row.endereco,
        tipoConexao: PrinterTransportType.values.firstWhere((e) => e.name == row.tipoConexao),
        protocolo: PrinterProtocolType.values.firstWhere((e) => e.name == row.protocolo),
        padrao: row.padrao,
        ultimaConexao: row.ultimaConexao,
      );

  PrintersCompanion _toCompanion(PrinterModel model) => PrintersCompanion(
        id: model.id == null ? const Value.absent() : Value(model.id!),
        nome: Value(model.nome),
        endereco: Value(model.endereco),
        tipoConexao: Value(model.tipoConexao.name),
        protocolo: Value(model.protocolo.name),
        padrao: Value(model.padrao),
        ultimaConexao: Value(model.ultimaConexao),
      );

  Future<List<PrinterModel>> getAll() async {
    final rows = await (_db.select(_db.printers)
          ..orderBy([(t) => OrderingTerm(expression: t.nome)]))
        .get();
    return rows.map(_mapRow).toList();
  }

  Future<PrinterModel?> getDefault() async {
    final row = await (_db.select(_db.printers)..where((t) => t.padrao.equals(true)))
        .getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  Future<PrinterModel?> getByEndereco(String endereco) async {
    final row = await (_db.select(_db.printers)..where((t) => t.endereco.equals(endereco)))
        .getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  /// Salva a impressora (cria ou atualiza pelo [endereco], que é
  /// único — `insertOnConflictUpdate` do Drift só detecta conflito
  /// pela chave primária por padrão, por isso a checagem explícita
  /// aqui) e, quando [PrinterModel.padrao] for `true`, garante que
  /// nenhuma outra fique marcada como padrão.
  Future<int> save(PrinterModel model) async {
    return _db.transaction(() async {
      final existing = await getByEndereco(model.endereco);
      int id;
      if (existing == null) {
        id = await _db.into(_db.printers).insert(_toCompanion(model));
      } else {
        id = existing.id!;
        await (_db.update(_db.printers)..where((t) => t.id.equals(id)))
            .write(_toCompanion(model.copyWith(id: id)));
      }
      if (model.padrao) {
        await (_db.update(_db.printers)..where((t) => t.id.equals(id).not()))
            .write(const PrintersCompanion(padrao: Value(false)));
      }
      return id;
    });
  }

  Future<void> updateLastConnection(int id, DateTime when) async {
    await (_db.update(_db.printers)..where((t) => t.id.equals(id)))
        .write(PrintersCompanion(ultimaConexao: Value(when)));
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.printers)..where((t) => t.id.equals(id))).go();
  }
}
