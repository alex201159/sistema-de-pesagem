import 'package:drift/drift.dart';

/// Perfis/layouts de etiqueta (ver escopo, item 26).
class Labels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  RealColumn get larguraMm => real()();
  RealColumn get alturaMm => real()();
  BoolColumn get padrao => boolean().withDefault(const Constant(false))();
  DateTimeColumn get dataCriacao => dateTime()();
  DateTimeColumn get dataAtualizacao => dateTime()();
}
