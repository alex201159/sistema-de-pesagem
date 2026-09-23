import 'package:drift/drift.dart';

/// Registro de eventos importantes do sistema (ver escopo, item 38):
/// produto importado/atualizado, arquivo importado, configuração
/// modificada, impressora conectada, impressão realizada, reimpressão,
/// falha de impressão, falha de balança.
class AuditLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get dataHora => dateTime()();

  /// Nome do enum `AuditEventType`.
  TextColumn get tipo => text()();

  TextColumn get descricao => text()();

  /// Detalhes adicionais em texto livre (ex.: nome do arquivo, mac
  /// address da impressora, mensagem de erro) — opcional.
  TextColumn get detalhes => text().nullable()();
}
