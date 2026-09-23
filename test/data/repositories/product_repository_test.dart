import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/data/database/app_database.dart';
import 'package:pesagem_totem/data/models/product_model.dart';
import 'package:pesagem_totem/data/repositories/product_repository.dart';

void main() {
  late AppDatabase db;
  late ProductRepository repository;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    repository = ProductRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  ProductModel buildProduct({String codigo = '00125', String? codigoBarras}) {
    final now = DateTime(2026, 1, 1);
    return ProductModel(
      codigo: codigo,
      plu: codigo,
      descricao: 'QUEIJO MUSSARELA',
      preco: 42.90,
      unidade: 'KG',
      validadeDias: 7,
      codigoBarras: codigoBarras,
      ativo: true,
      dataCriacao: now,
      dataAtualizacao: now,
    );
  }

  test('insere um novo produto e permite buscá-lo pelo código', () async {
    final id = await repository.upsert(buildProduct());
    expect(id, greaterThan(0));

    final found = await repository.getByCodigo('00125');
    expect(found, isNotNull);
    expect(found!.descricao, 'QUEIJO MUSSARELA');
    expect(found.preco, 42.90);
  });

  test('preserva o código de barras exatamente como importado', () async {
    await repository.upsert(buildProduct(codigoBarras: '2125000208105'));
    final found = await repository.getByCodigo('00125');
    expect(found!.codigoBarras, '2125000208105');
  });

  test('upsert com mesmo código atualiza em vez de duplicar', () async {
    await repository.upsert(buildProduct());
    await repository.upsert(buildProduct().copyWith(preco: 45.00));

    final all = await repository.getAll();
    expect(all.length, 1);
    expect(all.first.preco, 45.00);
  });

  test('search encontra por prefixo de código e por trecho da descrição', () async {
    await repository.upsert(buildProduct(codigo: '00125'));
    await repository.upsert(buildProduct(codigo: '00218').copyWith(descricao: 'MUSSARELA FATIADA'));

    final byCode = await repository.search('001');
    expect(byCode.map((p) => p.codigo), contains('00125'));

    final byName = await repository.search('muss');
    expect(byName.length, 2);
  });

  test('deactivate marca o produto como inativo e ele some do watchAll padrão', () async {
    final id = await repository.upsert(buildProduct());
    await repository.deactivate(id);

    final active = await repository.getAll();
    expect(active, isEmpty);

    final all = await repository.getAll(onlyActive: false);
    expect(all.length, 1);
    expect(all.first.ativo, isFalse);
  });

  group('deactivateByCodigos (EXCLITEM.txt)', () {
    test('desativa só os produtos com código na lista, mantendo os demais ativos', () async {
      await repository.upsert(buildProduct(codigo: '00125'));
      await repository.upsert(buildProduct(codigo: '00218'));

      final count = await repository.deactivateByCodigos(['00125']);

      expect(count, 1);
      final ativo = await repository.getByCodigo('00218');
      final inativo = await repository.getByCodigo('00125');
      expect(ativo!.ativo, isTrue);
      expect(inativo!.ativo, isFalse);
    });

    test('ignora códigos que não existem, sem lançar erro', () async {
      await repository.upsert(buildProduct(codigo: '00125'));
      final count = await repository.deactivateByCodigos(['99999']);
      expect(count, 0);
    });

    test('não reconta um produto já inativo', () async {
      final id = await repository.upsert(buildProduct(codigo: '00125'));
      await repository.deactivate(id);

      final count = await repository.deactivateByCodigos(['00125']);
      expect(count, 0);
    });

    test('lista vazia não faz nenhuma consulta desnecessária e retorna 0', () async {
      await repository.upsert(buildProduct(codigo: '00125'));
      final count = await repository.deactivateByCodigos([]);
      expect(count, 0);
    });
  });
}
