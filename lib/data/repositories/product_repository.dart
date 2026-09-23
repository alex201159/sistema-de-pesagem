import 'package:drift/drift.dart';

import '../../core/utils/app_logger.dart';
import '../database/app_database.dart';
import '../models/product_model.dart';

/// Acesso a dados de produtos.
///
/// Ponto único de leitura/escrita da tabela `products`. O parser de
/// importação e as telas de seleção de produto dependem apenas desta
/// interface, nunca de SQL/Drift diretamente (ver escopo, item 56 —
/// identificador de casamento INSERT/UPDATE é sempre [ProductModel.codigo]).
class ProductRepository {
  final AppDatabase _db;

  ProductRepository(this._db);

  ProductModel _mapRow(Product row) => ProductModel(
        id: row.id,
        codigo: row.codigo,
        plu: row.plu,
        descricao: row.descricao,
        preco: row.preco,
        unidade: row.unidade,
        validadeDias: row.validadeDias,
        codigoBarras: row.codigoBarras,
        departamento: row.departamento,
        ativo: row.ativo,
        dataCriacao: row.dataCriacao,
        dataAtualizacao: row.dataAtualizacao,
      );

  ProductsCompanion _toCompanion(ProductModel model) => ProductsCompanion(
        id: model.id == null ? const Value.absent() : Value(model.id!),
        codigo: Value(model.codigo),
        plu: Value(model.plu),
        descricao: Value(model.descricao),
        preco: Value(model.preco),
        unidade: Value(model.unidade),
        validadeDias: Value(model.validadeDias),
        codigoBarras: Value(model.codigoBarras),
        departamento: Value(model.departamento),
        ativo: Value(model.ativo),
        dataCriacao: Value(model.dataCriacao),
        dataAtualizacao: Value(model.dataAtualizacao),
      );

  /// Observa a lista de produtos em tempo real (usado pela tela de
  /// seleção de produtos e pela lista de produtos cadastrados).
  Stream<List<ProductModel>> watchAll({bool onlyActive = true}) {
    final query = _db.select(_db.products)
      ..orderBy([(t) => OrderingTerm(expression: t.descricao)]);
    if (onlyActive) {
      query.where((t) => t.ativo.equals(true));
    }
    return query.watch().map((rows) => rows.map(_mapRow).toList());
  }

  Future<List<ProductModel>> getAll({bool onlyActive = true}) async {
    final query = _db.select(_db.products)
      ..orderBy([(t) => OrderingTerm(expression: t.descricao)]);
    if (onlyActive) {
      query.where((t) => t.ativo.equals(true));
    }
    final rows = await query.get();
    return rows.map(_mapRow).toList();
  }

  Future<ProductModel?> getByCodigo(String codigo) async {
    final row = await (_db.select(_db.products)..where((t) => t.codigo.equals(codigo)))
        .getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  Future<ProductModel?> getById(int id) async {
    final row = await (_db.select(_db.products)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  /// Pesquisa por código (prefixo) ou descrição (contém), usada pela
  /// busca de produto na tela principal (ver escopo, item 14).
  Future<List<ProductModel>> search(String query, {int limit = 30}) async {
    final term = query.trim();
    if (term.isEmpty) return [];
    final likeTerm = '%$term%';
    final q = _db.select(_db.products)
      ..where((t) => t.ativo.equals(true) & (t.codigo.like('$term%') | t.descricao.like(likeTerm)))
      ..orderBy([(t) => OrderingTerm(expression: t.descricao)])
      ..limit(limit);
    final rows = await q.get();
    return rows.map(_mapRow).toList();
  }

  /// Insere um novo produto ou atualiza um existente com o mesmo
  /// [ProductModel.codigo]. Retorna o [id] do produto persistido.
  ///
  /// Não é a rota usada pela importação em massa (ver
  /// `ImportService`, que processa em lote/transação) — destinado a
  /// cadastro manual e testes.
  Future<int> upsert(ProductModel product) async {
    return _db.transaction(() async {
      final existing = await getByCodigo(product.codigo);
      if (existing == null) {
        return _db.into(_db.products).insert(_toCompanion(product));
      }
      final updated = product.copyWith(id: existing.id);
      await (_db.update(_db.products)..where((t) => t.id.equals(existing.id!)))
          .write(_toCompanion(updated));
      return existing.id!;
    });
  }

  /// Insere/atualiza uma lista de produtos em uma ÚNICA transação —
  /// usado pela importação em massa para garantir atomicidade: se um
  /// erro crítico ocorrer no meio do lote, tudo é revertido, evitando
  /// banco parcialmente atualizado (ver escopo, item 57).
  Future<List<int>> upsertAll(List<ProductModel> products) async {
    return _db.transaction(() async {
      final ids = <int>[];
      for (final product in products) {
        final existing = await getByCodigo(product.codigo);
        if (existing == null) {
          ids.add(await _db.into(_db.products).insert(_toCompanion(product)));
        } else {
          final updated = product.copyWith(id: existing.id);
          await (_db.update(_db.products)..where((t) => t.id.equals(existing.id!)))
              .write(_toCompanion(updated));
          ids.add(existing.id!);
        }
      }
      return ids;
    });
  }

  Future<void> deactivate(int id) async {
    await (_db.update(_db.products)..where((t) => t.id.equals(id))).write(
      ProductsCompanion(ativo: const Value(false), dataAtualizacao: Value(DateTime.now())),
    );
    AppLogger.i('Produto id=$id desativado.');
  }

  /// Desativa em lote todos os produtos com um dos [codigos] dados
  /// (nunca remove de verdade — ver `ExclItemParser`/`EXCLITEM.txt`).
  /// Retorna quantos produtos foram realmente desativados (ignora
  /// códigos que não existem ou já estavam inativos).
  Future<int> deactivateByCodigos(List<String> codigos) async {
    if (codigos.isEmpty) return 0;
    final count = await (_db.update(_db.products)
          ..where((t) => t.codigo.isIn(codigos) & t.ativo.equals(true)))
        .write(
      ProductsCompanion(ativo: const Value(false), dataAtualizacao: Value(DateTime.now())),
    );
    if (count > 0) AppLogger.i('$count produto(s) desativado(s) via EXCLITEM.');
    return count;
  }

  Future<int> count({bool onlyActive = true}) async {
    final query = _db.selectOnly(_db.products)
      ..addColumns([_db.products.id.count()]);
    if (onlyActive) {
      query.where(_db.products.ativo.equals(true));
    }
    final row = await query.getSingle();
    return row.read(_db.products.id.count()) ?? 0;
  }
}
