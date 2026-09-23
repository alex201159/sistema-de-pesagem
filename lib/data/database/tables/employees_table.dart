import 'package:drift/drift.dart';

/// Funcionários/atendentes que podem ser vinculados a uma venda por
/// comanda (sem impressão de etiqueta) para fins de comissionamento
/// (ver `WeighingRepository.insertWithEmployees`).
class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  RealColumn get percentualComissao => real().withDefault(const Constant(0))();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get dataCriacao => dateTime()();
}
