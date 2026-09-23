import 'package:drift/drift.dart';

import 'products_table.dart';

/// Histórico de alterações de preço de um produto (ver escopo, item 58).
class ProductPriceHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get produtoId =>
      integer().references(Products, #id, onDelete: KeyAction.cascade)();
  RealColumn get precoAnterior => real()();
  RealColumn get precoNovo => real()();
  DateTimeColumn get data => dateTime()();

  /// Origem da alteração (ex.: "importacao", "manual").
  TextColumn get origem => text()();
}
