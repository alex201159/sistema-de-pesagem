import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/employee_model.dart';
import '../models/weighing_model.dart';

/// Acesso a dados do histórico de pesagens impressas
/// (ver escopo, itens 33-37).
class WeighingRepository {
  final AppDatabase _db;

  WeighingRepository(this._db);

  WeighingModel _mapRow(WeighingHistoryData row) => WeighingModel(
        id: row.id,
        uuid: row.uuid,
        dataHora: row.dataHora,
        produtoId: row.produtoId,
        codigo: row.codigo,
        descricao: row.descricao,
        peso: row.peso,
        precoKg: row.precoKg,
        valorTotal: row.valorTotal,
        codigoBarras: row.codigoBarras,
        layoutEtiqueta: row.layoutEtiqueta,
        impressora: row.impressora,
        comandaNumero: row.comandaNumero,
        statusImpressao: PrintStatus.fromName(row.statusImpressao),
        quantidadeImpressoes: row.quantidadeImpressoes,
      );

  WeighingHistoryCompanion _toCompanion(WeighingModel model) => WeighingHistoryCompanion(
        id: model.id == null ? const Value.absent() : Value(model.id!),
        uuid: Value(model.uuid),
        dataHora: Value(model.dataHora),
        produtoId: Value(model.produtoId),
        codigo: Value(model.codigo),
        descricao: Value(model.descricao),
        peso: Value(model.peso),
        precoKg: Value(model.precoKg),
        valorTotal: Value(model.valorTotal),
        codigoBarras: Value(model.codigoBarras),
        layoutEtiqueta: Value(model.layoutEtiqueta),
        impressora: Value(model.impressora),
        comandaNumero: Value(model.comandaNumero),
        statusImpressao: Value(model.statusImpressao.name),
        quantidadeImpressoes: Value(model.quantidadeImpressoes),
      );

  /// Registra uma nova pesagem (chamada ao confirmar a impressão,
  /// nunca antes — ver fluxo operacional, escopo item 59).
  Future<int> insert(WeighingModel weighing) =>
      _db.into(_db.weighingHistory).insert(_toCompanion(weighing));

  /// Registra uma venda por comanda (ver `SalesMode.comanda`) e
  /// vincula, na mesma transação, o(s) funcionário(s) que a
  /// atenderam — uma mesma comanda pode ter mais de um funcionário.
  Future<int> insertWithEmployees(
    WeighingModel weighing, {
    List<int> employeeIds = const [],
  }) {
    return _db.transaction(() async {
      final id = await _db.into(_db.weighingHistory).insert(_toCompanion(weighing));
      for (final employeeId in employeeIds) {
        await _db.into(_db.weighingEmployees).insert(
              WeighingEmployeesCompanion.insert(weighingId: id, employeeId: employeeId),
            );
      }
      return id;
    });
  }

  /// Funcionário(s) vinculados a uma venda registrada por comanda
  /// (lista vazia para vendas com etiqueta impressa, sem vínculo).
  Future<List<EmployeeModel>> getEmployeesForWeighing(int weighingId) async {
    final query = _db.select(_db.weighingEmployees).join([
      innerJoin(_db.employees, _db.employees.id.equalsExp(_db.weighingEmployees.employeeId)),
    ])
      ..where(_db.weighingEmployees.weighingId.equals(weighingId));
    final rows = await query.get();
    return rows.map((row) {
      final e = row.readTable(_db.employees);
      return EmployeeModel(
        id: e.id,
        nome: e.nome,
        percentualComissao: e.percentualComissao,
        ativo: e.ativo,
        dataCriacao: e.dataCriacao,
      );
    }).toList();
  }

  Future<void> updateStatus(
    int id, {
    required PrintStatus status,
    int? incrementPrintCount,
  }) async {
    if (incrementPrintCount != null) {
      await _db.customStatement(
        'UPDATE weighing_history SET status_impressao = ?, quantidade_impressoes = quantidade_impressoes + ? WHERE id = ?',
        [status.name, incrementPrintCount, id],
      );
      return;
    }
    await (_db.update(_db.weighingHistory)..where((t) => t.id.equals(id)))
        .write(WeighingHistoryCompanion(statusImpressao: Value(status.name)));
  }

  Future<WeighingModel?> getById(int id) async {
    final row =
        await (_db.select(_db.weighingHistory)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  Future<WeighingModel?> getByUuid(String uuid) async {
    final row = await (_db.select(_db.weighingHistory)..where((t) => t.uuid.equals(uuid)))
        .getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  /// Lista o histórico com filtros opcionais (ver escopo, item 35).
  Future<List<WeighingModel>> query({
    DateTime? from,
    DateTime? to,
    String? codigo,
    PrintStatus? status,
    int limit = 200,
  }) async {
    final q = _db.select(_db.weighingHistory)
      ..orderBy([(t) => OrderingTerm(expression: t.dataHora, mode: OrderingMode.desc)])
      ..limit(limit);

    q.where((t) {
      Expression<bool> predicate = const Constant(true);
      if (from != null) predicate = predicate & t.dataHora.isBiggerOrEqualValue(from);
      if (to != null) predicate = predicate & t.dataHora.isSmallerOrEqualValue(to);
      if (codigo != null && codigo.isNotEmpty) predicate = predicate & t.codigo.equals(codigo);
      if (status != null) predicate = predicate & t.statusImpressao.equals(status.name);
      return predicate;
    });

    final rows = await q.get();
    return rows.map(_mapRow).toList();
  }

  Stream<List<WeighingModel>> watchRecent({int limit = 50}) {
    final q = _db.select(_db.weighingHistory)
      ..orderBy([(t) => OrderingTerm(expression: t.dataHora, mode: OrderingMode.desc)])
      ..limit(limit);
    return q.watch().map((rows) => rows.map(_mapRow).toList());
  }
}
