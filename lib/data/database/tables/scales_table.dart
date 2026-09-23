import 'package:drift/drift.dart';

/// Balanças conhecidas/pareadas (ver escopo, item 10).
class Scales extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get endereco => text().unique()();

  /// Nome do enum `ScaleTransportType`.
  TextColumn get tipoConexao => text()();

  /// Identifica qual `ScaleParser` interpreta os bytes recebidos.
  TextColumn get protocolo => text()();

  BoolColumn get padrao => boolean().withDefault(const Constant(false))();
}
