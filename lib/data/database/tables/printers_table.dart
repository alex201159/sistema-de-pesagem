import 'package:drift/drift.dart';

/// Impressoras térmicas conhecidas/pareadas (ver escopo, item 30).
class Printers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();

  /// Endereço MAC (Bluetooth) ou host:porta (TCP).
  TextColumn get endereco => text().unique()();

  /// Nome do enum `PrinterTransportType`.
  TextColumn get tipoConexao => text()();

  /// Nome do enum `PrinterProtocolType`.
  TextColumn get protocolo => text()();

  BoolColumn get padrao => boolean().withDefault(const Constant(false))();
  DateTimeColumn get ultimaConexao => dateTime().nullable()();
}
