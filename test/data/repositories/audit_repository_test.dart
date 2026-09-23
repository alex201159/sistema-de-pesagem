import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/data/database/app_database.dart';
import 'package:pesagem_totem/data/models/audit_log_model.dart';
import 'package:pesagem_totem/data/repositories/audit_repository.dart';

void main() {
  late AppDatabase db;
  late AuditRepository repository;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    repository = AuditRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('insere e lista eventos do mais recente para o mais antigo', () async {
    await repository.insert(AuditLogModel(
      dataHora: DateTime(2026, 1, 1, 10),
      tipo: AuditEventType.arquivoImportado,
      descricao: 'PRODUTOS.TXT: 10 novos',
    ));
    await repository.insert(AuditLogModel(
      dataHora: DateTime(2026, 1, 1, 12),
      tipo: AuditEventType.impressaoRealizada,
      descricao: 'QUEIJO MUSSARELA',
      detalhes: '2125000208105',
    ));

    final recent = await repository.getRecent();
    expect(recent, hasLength(2));
    expect(recent.first.tipo, AuditEventType.impressaoRealizada);
    expect(recent.first.detalhes, '2125000208105');
    expect(recent.last.tipo, AuditEventType.arquivoImportado);
  });
}
