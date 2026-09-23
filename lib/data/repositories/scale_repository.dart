import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/scale_model.dart';

/// Acesso a dados de balanças conhecidas/pareadas (ver escopo, item 10).
class ScaleRepository {
  final AppDatabase _db;

  ScaleRepository(this._db);

  ScaleModel _mapRow(Scale row) => ScaleModel(
        id: row.id,
        nome: row.nome,
        endereco: row.endereco,
        tipoConexao: ScaleTransportType.values.firstWhere((e) => e.name == row.tipoConexao),
        protocolo: row.protocolo,
        padrao: row.padrao,
      );

  ScalesCompanion _toCompanion(ScaleModel model) => ScalesCompanion(
        id: model.id == null ? const Value.absent() : Value(model.id!),
        nome: Value(model.nome),
        endereco: Value(model.endereco),
        tipoConexao: Value(model.tipoConexao.name),
        protocolo: Value(model.protocolo),
        padrao: Value(model.padrao),
      );

  Future<List<ScaleModel>> getAll() async {
    final rows = await (_db.select(_db.scales)..orderBy([(t) => OrderingTerm(expression: t.nome)]))
        .get();
    return rows.map(_mapRow).toList();
  }

  Future<ScaleModel?> getDefault() async {
    final row = await (_db.select(_db.scales)..where((t) => t.padrao.equals(true)))
        .getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  Future<ScaleModel?> getByEndereco(String endereco) async {
    final row =
        await (_db.select(_db.scales)..where((t) => t.endereco.equals(endereco))).getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  /// Salva a balança (cria ou atualiza pelo [endereco], que é único —
  /// `insertOnConflictUpdate` do Drift só detecta conflito pela chave
  /// primária por padrão, por isso a checagem explícita aqui) e,
  /// quando [ScaleModel.padrao] for `true`, garante que nenhuma outra
  /// fique marcada como padrão.
  Future<int> save(ScaleModel model) async {
    return _db.transaction(() async {
      final existing = await getByEndereco(model.endereco);
      int id;
      if (existing == null) {
        id = await _db.into(_db.scales).insert(_toCompanion(model));
      } else {
        id = existing.id!;
        await (_db.update(_db.scales)..where((t) => t.id.equals(id)))
            .write(_toCompanion(model.copyWith(id: id)));
      }
      if (model.padrao) {
        await (_db.update(_db.scales)..where((t) => t.id.equals(id).not()))
            .write(const ScalesCompanion(padrao: Value(false)));
      }
      return id;
    });
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.scales)..where((t) => t.id.equals(id))).go();
  }
}
