import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/data/database/app_database.dart';
import 'package:pesagem_totem/data/models/import_model.dart';
import 'package:pesagem_totem/data/repositories/history_repository.dart';
import 'package:pesagem_totem/data/repositories/product_repository.dart';
import 'package:pesagem_totem/services/import/import_service.dart';
import 'package:pesagem_totem/services/import/import_validator.dart';
import 'package:pesagem_totem/services/import/itens_mgv_parser.dart';

void main() {
  late AppDatabase db;
  late ImportService service;
  late ProductRepository productRepository;
  late File sampleFile;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    productRepository = ProductRepository(db);
    service = ImportService(
      parser: ItensMgvParser(),
      validator: ImportValidator(),
      productRepository: productRepository,
      historyRepository: HistoryRepository(db),
    );
    sampleFile = File('import_samples/ITENSMGV.txt');
  });

  tearDown(() async {
    await db.close();
  });

  test('analyze() do arquivo real: 262 produtos, todos novos, sem erro', () async {
    final preview = await service.analyze(sampleFile);

    expect(preview.quantidadeLinhas, 262);
    expect(preview.novos, 262);
    expect(preview.atualizados, 0);
    expect(preview.produtosComErro, 0);
    expect(preview.produtosValidos, hasLength(262));
  });

  test('execute() grava os produtos e registra sucesso no histórico', () async {
    final preview = await service.analyze(sampleFile);
    final result = await service.execute(preview);

    expect(result.status, ImportStatus.sucesso);
    expect(result.produtosNovos, 262);
    expect(result.id, isNotNull);

    final total = await productRepository.count(onlyActive: false);
    expect(total, 262);

    final abacate = await productRepository.getByCodigo('59');
    expect(abacate, isNotNull);
    expect(abacate!.descricao, 'ABACATE');
    expect(abacate.preco, 6.99);
    expect(abacate.unidade, 'KG');
  });

  test('reimportar o mesmo arquivo atualiza em vez de duplicar', () async {
    final firstPreview = await service.analyze(sampleFile);
    await service.execute(firstPreview);

    final secondPreview = await service.analyze(sampleFile);
    expect(secondPreview.novos, 0);
    expect(secondPreview.atualizados, 262);

    await service.execute(secondPreview);
    final total = await productRepository.count(onlyActive: false);
    expect(total, 262);
  });

  test('wasAlreadyImported reflete o hash após uma importação bem-sucedida', () async {
    final preview = await service.analyze(sampleFile);
    expect(await service.wasAlreadyImported(preview.hash), isFalse);

    await service.execute(preview);
    expect(await service.wasAlreadyImported(preview.hash), isTrue);
  });
}
