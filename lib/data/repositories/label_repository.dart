import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/label_element_model.dart';
import '../models/label_model.dart';

/// Acesso a dados de perfis de etiqueta e seus elementos
/// (ver escopo, itens 22-26).
class LabelRepository {
  final AppDatabase _db;

  LabelRepository(this._db);

  LabelElementModel _mapElementRow(LabelElement row) => LabelElementModel(
        id: row.id,
        labelId: row.labelId,
        tipo: LabelElementType.values.firstWhere((e) => e.name == row.tipo),
        x: row.x,
        y: row.y,
        largura: row.largura,
        altura: row.altura,
        rotacao: row.rotacao,
        fonteFamilia: row.fonteFamilia,
        fonteTamanho: row.fonteTamanho,
        negrito: row.negrito,
        alinhamento: LabelTextAlign.values.firstWhere((e) => e.name == row.alinhamento),
        conteudoLivre: row.conteudoLivre,
        ordem: row.ordem,
      );

  LabelElementsCompanion _toElementCompanion(LabelElementModel model) => LabelElementsCompanion(
        id: model.id == null ? const Value.absent() : Value(model.id!),
        labelId: Value(model.labelId),
        tipo: Value(model.tipo.name),
        x: Value(model.x),
        y: Value(model.y),
        largura: Value(model.largura),
        altura: Value(model.altura),
        rotacao: Value(model.rotacao),
        fonteFamilia: Value(model.fonteFamilia),
        fonteTamanho: Value(model.fonteTamanho),
        negrito: Value(model.negrito),
        alinhamento: Value(model.alinhamento.name),
        conteudoLivre: Value(model.conteudoLivre),
        ordem: Value(model.ordem),
      );

  LabelsCompanion _toLabelCompanion(LabelModel model) => LabelsCompanion(
        id: model.id == null ? const Value.absent() : Value(model.id!),
        nome: Value(model.nome),
        larguraMm: Value(model.larguraMm),
        alturaMm: Value(model.alturaMm),
        padrao: Value(model.padrao),
        dataCriacao: Value(model.dataCriacao),
        dataAtualizacao: Value(model.dataAtualizacao),
      );

  Future<List<LabelElementModel>> _elementsOf(int labelId) async {
    final rows = await (_db.select(_db.labelElements)
          ..where((t) => t.labelId.equals(labelId))
          ..orderBy([(t) => OrderingTerm(expression: t.ordem)]))
        .get();
    return rows.map(_mapElementRow).toList();
  }

  Future<List<LabelModel>> getAll() async {
    final rows = await (_db.select(_db.labels)
          ..orderBy([(t) => OrderingTerm(expression: t.nome)]))
        .get();
    final result = <LabelModel>[];
    for (final row in rows) {
      final elements = await _elementsOf(row.id);
      result.add(LabelModel(
        id: row.id,
        nome: row.nome,
        larguraMm: row.larguraMm,
        alturaMm: row.alturaMm,
        padrao: row.padrao,
        dataCriacao: row.dataCriacao,
        dataAtualizacao: row.dataAtualizacao,
        elementos: elements,
      ));
    }
    return result;
  }

  Future<LabelModel?> getById(int id) async {
    final row = await (_db.select(_db.labels)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final elements = await _elementsOf(id);
    return LabelModel(
      id: row.id,
      nome: row.nome,
      larguraMm: row.larguraMm,
      alturaMm: row.alturaMm,
      padrao: row.padrao,
      dataCriacao: row.dataCriacao,
      dataAtualizacao: row.dataAtualizacao,
      elementos: elements,
    );
  }

  /// Usado só pelo endpoint de recebimento de etiquetas via rede
  /// (`POST /import-label`) para decidir se uma etiqueta recebida deve
  /// atualizar um perfil já existente com o mesmo nome, em vez de criar
  /// um duplicado — não usado pelo editor local, onde duas etiquetas
  /// "Nova etiqueta" sem nome customizado devem continuar sendo
  /// registros separados.
  Future<LabelModel?> getByNome(String nome) async {
    // `nome` não tem constraint de unicidade no schema (o editor local
    // permite nomes repetidos, ex. várias "Nova etiqueta") — usa a
    // primeira correspondência em vez de `getSingleOrNull` (que lançaria
    // se houvesse mais de uma linha).
    final rows = await (_db.select(_db.labels)..where((t) => t.nome.equals(nome))).get();
    if (rows.isEmpty) return null;
    return getById(rows.first.id);
  }

  Future<LabelModel?> getDefault() async {
    final row =
        await (_db.select(_db.labels)..where((t) => t.padrao.equals(true))).getSingleOrNull();
    if (row == null) return null;
    return getById(row.id);
  }

  /// Salva a etiqueta (cria ou atualiza) e substitui integralmente seus
  /// elementos pelos informados em [model.elementos] — mais simples e
  /// seguro que tentar diffar posições no editor visual.
  Future<int> save(LabelModel model) async {
    return _db.transaction(() async {
      int labelId;
      if (model.id == null) {
        labelId = await _db.into(_db.labels).insert(_toLabelCompanion(model));
      } else {
        labelId = model.id!;
        await (_db.update(_db.labels)..where((t) => t.id.equals(labelId)))
            .write(_toLabelCompanion(model));
        await (_db.delete(_db.labelElements)..where((t) => t.labelId.equals(labelId))).go();
      }

      if (model.padrao) {
        await (_db.update(_db.labels)..where((t) => t.id.equals(labelId).not()))
            .write(const LabelsCompanion(padrao: Value(false)));
      }

      for (final element in model.elementos) {
        await _db
            .into(_db.labelElements)
            .insert(_toElementCompanion(element.copyWith(labelId: labelId)));
      }
      return labelId;
    });
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.labels)..where((t) => t.id.equals(id))).go();
  }
}
