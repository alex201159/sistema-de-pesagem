import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/audit_log_model.dart';

/// Acesso a dados do registro de auditoria (ver escopo, item 38).
class AuditRepository {
  final AppDatabase _db;

  AuditRepository(this._db);

  AuditLogModel _mapRow(AuditLogData row) => AuditLogModel(
        id: row.id,
        dataHora: row.dataHora,
        tipo: AuditEventType.values.firstWhere((e) => e.name == row.tipo),
        descricao: row.descricao,
        detalhes: row.detalhes,
      );

  Future<int> insert(AuditLogModel model) {
    return _db.into(_db.auditLog).insert(AuditLogCompanion.insert(
          dataHora: model.dataHora,
          tipo: model.tipo.name,
          descricao: model.descricao,
          detalhes: Value(model.detalhes),
        ));
  }

  Future<List<AuditLogModel>> getRecent({int limit = 200}) async {
    final rows = await (_db.select(_db.auditLog)
          ..orderBy([(t) => OrderingTerm(expression: t.dataHora, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
    return rows.map(_mapRow).toList();
  }

  Stream<List<AuditLogModel>> watchRecent({int limit = 200}) {
    final q = _db.select(_db.auditLog)
      ..orderBy([(t) => OrderingTerm(expression: t.dataHora, mode: OrderingMode.desc)])
      ..limit(limit);
    return q.watch().map((rows) => rows.map(_mapRow).toList());
  }
}
