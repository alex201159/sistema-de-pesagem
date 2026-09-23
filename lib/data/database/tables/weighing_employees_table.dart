import 'package:drift/drift.dart';

import 'employees_table.dart';
import 'weighing_history_table.dart';

/// Vínculo N:N entre uma pesagem registrada e o(s) funcionário(s) que
/// atenderam a venda — uma mesma comanda pode ter mais de um
/// funcionário (ver `WeighingRepository.insertWithEmployees`).
class WeighingEmployees extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get weighingId => integer().references(WeighingHistory, #id)();
  IntColumn get employeeId => integer().references(Employees, #id)();
}
