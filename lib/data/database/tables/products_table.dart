import 'package:drift/drift.dart';

/// Tabela de produtos importados do ERP (ver escopo, item 3).
///
/// [codigo] é o identificador usado para casar INSERT/UPDATE durante a
/// importação (ver escopo, item 56) — por isso é único.
/// [codigoBarras] é preservado exatamente como recebido do arquivo,
/// nunca recalculado automaticamente (ver escopo, item 17).
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text()();
  TextColumn get plu => text()();
  TextColumn get descricao => text()();
  RealColumn get preco => real()();
  TextColumn get unidade => text()();
  IntColumn get validadeDias => integer().nullable()();
  TextColumn get codigoBarras => text().nullable()();
  TextColumn get departamento => text().nullable()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get dataCriacao => dateTime()();
  DateTimeColumn get dataAtualizacao => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {codigo},
      ];
}
