import 'package:drift/drift.dart';

import '../../core/utils/app_logger.dart';
import 'app_database.dart';

/// Estratégia de migração do banco de dados.
///
/// Mantida separada de `app_database.dart` para que a evolução do
/// schema (novas colunas/tabelas) fique documentada e isolada em um
/// único lugar. Ao incrementar `DatabaseConstants.schemaVersion`,
/// adicionar aqui o passo correspondente em `onUpgrade`.
MigrationStrategy buildMigrationStrategy(AppDatabase db) {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      AppLogger.i('Criando schema do banco de dados (primeira execução).');
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      AppLogger.i('Migrando banco de dados da versão $from para $to.');
      if (from < 2) {
        await m.createTable(db.auditLog);
      }
      if (from < 3) {
        await m.createTable(db.employees);
        await m.createTable(db.weighingEmployees);
        await m.addColumn(db.weighingHistory, db.weighingHistory.comandaNumero);
      }
    },
    beforeOpen: (details) async {
      await db.customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated) {
        AppLogger.i('Banco de dados criado com sucesso.');
      }
    },
  );
}
