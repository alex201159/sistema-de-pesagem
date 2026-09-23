import 'package:drift/drift.dart';

/// Histórico de importações de arquivo (manual ou automática via SMB),
/// ver escopo, item 9.
///
/// [hash] permite detectar que um arquivo com mesmo nome/data não
/// mudou de conteúdo e não precisa ser reimportado (ver escopo, item 7).
/// [erros] guarda a lista de linhas inválidas em JSON (ver
/// `data/models/import_model.dart` -> `ImportLineError`), nunca
/// descartada silenciosamente (ver escopo, item 55).
class ImportHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get arquivo => text()();
  IntColumn get tamanho => integer()();
  TextColumn get hash => text()();
  DateTimeColumn get dataModificacao => dateTime()();
  DateTimeColumn get dataImportacao => dateTime()();
  IntColumn get quantidadeLinhas => integer()();
  IntColumn get produtosNovos => integer()();
  IntColumn get produtosAtualizados => integer()();
  IntColumn get produtosComErro => integer()();

  /// Nome do enum `ImportStatus`.
  TextColumn get status => text()();
  TextColumn get mensagem => text().nullable()();
  TextColumn get erros => text().nullable()();
}
