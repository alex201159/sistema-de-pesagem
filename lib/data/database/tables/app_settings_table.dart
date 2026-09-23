import 'package:drift/drift.dart';

/// Armazenamento chave/valor de configurações persistentes
/// (ver escopo, item 47).
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}
