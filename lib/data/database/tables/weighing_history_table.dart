import 'package:drift/drift.dart';

import 'products_table.dart';

/// Histórico de pesagens efetivamente impressas (ver escopo, item 33).
///
/// Registra sempre os valores CONGELADOS no momento da impressão
/// (preço, peso, total, código de barras) — uma reimpressão (item 37)
/// reutiliza esses dados sem recalcular com o preço atual do produto.
class WeighingHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get dataHora => dateTime()();
  IntColumn get produtoId => integer().references(Products, #id)();
  TextColumn get codigo => text()();
  TextColumn get descricao => text()();
  RealColumn get peso => real()();
  RealColumn get precoKg => real()();
  RealColumn get valorTotal => real()();
  TextColumn get codigoBarras => text().nullable()();
  TextColumn get layoutEtiqueta => text().nullable()();
  TextColumn get impressora => text().nullable()();

  /// Número da comanda, quando a venda não foi impressa e sim
  /// registrada para um cliente que trabalha com comandas — nulo nas
  /// vendas com impressão de etiqueta (ver `SalesMode`).
  TextColumn get comandaNumero => text().nullable()();

  /// Nome do enum `PrintStatus` (ver `data/models/weighing_model.dart`).
  TextColumn get statusImpressao =>
      text().withDefault(const Constant('pendente'))();
  IntColumn get quantidadeImpressoes => integer().withDefault(const Constant(0))();
}
