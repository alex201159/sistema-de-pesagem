import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// Instância única do banco de dados, compartilhada por toda a
/// aplicação via Riverpod. Fechada automaticamente quando o provider é
/// descartado (ex.: em testes).
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
