import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/employee_model.dart';

/// Acesso a dados de funcionários/atendentes comissionados, vinculados
/// a vendas registradas por comanda (ver `SalesMode.comanda`).
class EmployeeRepository {
  final AppDatabase _db;

  EmployeeRepository(this._db);

  EmployeeModel _mapRow(Employee row) => EmployeeModel(
        id: row.id,
        nome: row.nome,
        percentualComissao: row.percentualComissao,
        ativo: row.ativo,
        dataCriacao: row.dataCriacao,
      );

  EmployeesCompanion _toCompanion(EmployeeModel model) => EmployeesCompanion(
        id: model.id == null ? const Value.absent() : Value(model.id!),
        nome: Value(model.nome),
        percentualComissao: Value(model.percentualComissao),
        ativo: Value(model.ativo),
        dataCriacao: Value(model.dataCriacao),
      );

  /// Observa a lista de funcionários em tempo real (usado pela tela de
  /// cadastro e pela seleção de funcionário(s) na tela de pesagem).
  Stream<List<EmployeeModel>> watchAll({bool onlyActive = false}) {
    final query = _db.select(_db.employees)
      ..orderBy([(t) => OrderingTerm(expression: t.nome)]);
    if (onlyActive) {
      query.where((t) => t.ativo.equals(true));
    }
    return query.watch().map((rows) => rows.map(_mapRow).toList());
  }

  Future<List<EmployeeModel>> getAll({bool onlyActive = true}) async {
    final query = _db.select(_db.employees)
      ..orderBy([(t) => OrderingTerm(expression: t.nome)]);
    if (onlyActive) {
      query.where((t) => t.ativo.equals(true));
    }
    final rows = await query.get();
    return rows.map(_mapRow).toList();
  }

  Future<EmployeeModel?> getById(int id) async {
    final row = await (_db.select(_db.employees)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  /// Cria um novo funcionário ou atualiza um existente (quando
  /// [EmployeeModel.id] estiver preenchido). Retorna o [id] persistido.
  Future<int> upsert(EmployeeModel model) async {
    if (model.id == null) {
      return _db.into(_db.employees).insert(_toCompanion(model));
    }
    await (_db.update(_db.employees)..where((t) => t.id.equals(model.id!)))
        .write(_toCompanion(model));
    return model.id!;
  }

  /// Ativa/desativa um funcionário sem removê-lo — mantém a
  /// referência íntegra em vendas já registradas no histórico.
  Future<void> setAtivo(int id, bool ativo) async {
    await (_db.update(_db.employees)..where((t) => t.id.equals(id)))
        .write(EmployeesCompanion(ativo: Value(ativo)));
  }
}
