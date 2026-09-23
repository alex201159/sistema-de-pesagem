import 'package:drift/drift.dart';

import 'labels_table.dart';

/// Elementos posicionáveis de uma etiqueta (ver escopo, itens 23 e 24).
///
/// Excluídos em cascata quando a etiqueta ([labelId]) é removida.
class LabelElements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get labelId =>
      integer().references(Labels, #id, onDelete: KeyAction.cascade)();

  /// Nome do enum `LabelElementType`.
  TextColumn get tipo => text()();

  RealColumn get x => real()();
  RealColumn get y => real()();
  RealColumn get largura => real()();
  RealColumn get altura => real()();
  RealColumn get rotacao => real().withDefault(const Constant(0))();

  TextColumn get fonteFamilia => text().withDefault(const Constant('Roboto'))();
  RealColumn get fonteTamanho => real().withDefault(const Constant(10))();
  BoolColumn get negrito => boolean().withDefault(const Constant(false))();

  /// Nome do enum `LabelTextAlign`.
  TextColumn get alinhamento => text().withDefault(const Constant('left'))();

  TextColumn get conteudoLivre => text().nullable()();
  IntColumn get ordem => integer().withDefault(const Constant(0))();
}
