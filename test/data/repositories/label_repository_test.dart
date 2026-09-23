import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/data/database/app_database.dart';
import 'package:pesagem_totem/data/models/label_element_model.dart';
import 'package:pesagem_totem/data/models/label_model.dart';
import 'package:pesagem_totem/data/repositories/label_repository.dart';

void main() {
  late AppDatabase db;
  late LabelRepository repository;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    repository = LabelRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  LabelModel buildLabel({String nome = 'Etiqueta teste'}) {
    final now = DateTime.now();
    return LabelModel(
      nome: nome,
      larguraMm: 56,
      alturaMm: 42,
      dataCriacao: now,
      dataAtualizacao: now,
      elementos: [
        const LabelElementModel(
          labelId: 0,
          tipo: LabelElementType.produto,
          x: 2,
          y: 2,
          largura: 50,
          altura: 6,
          alinhamento: LabelTextAlign.center,
        ),
        const LabelElementModel(
          labelId: 0,
          tipo: LabelElementType.codigoBarras,
          x: 2,
          y: 20,
          largura: 40,
          altura: 10,
        ),
      ],
    );
  }

  group('toJson/fromJson', () {
    test('round-trip de LabelModel preserva nome, tamanho e elementos', () {
      final original = buildLabel();
      final decoded = LabelModel.fromJson(original.toJson());

      expect(decoded.nome, original.nome);
      expect(decoded.larguraMm, original.larguraMm);
      expect(decoded.alturaMm, original.alturaMm);
      expect(decoded.elementos, hasLength(2));
      expect(decoded.elementos[0].tipo, LabelElementType.produto);
      expect(decoded.elementos[0].alinhamento, LabelTextAlign.center);
      expect(decoded.elementos[1].tipo, LabelElementType.codigoBarras);
      expect(decoded.elementos[1].largura, 40);
    });

    test('fromJson usa defaults sensatos quando campos opcionais faltam', () {
      final decoded = LabelElementModel.fromJson({
        'tipo': 'textoLivre',
        'x': 1,
        'y': 1,
        'largura': 10,
        'altura': 5,
      });

      expect(decoded.rotacao, 0);
      expect(decoded.fonteFamilia, 'Roboto');
      expect(decoded.alinhamento, LabelTextAlign.left);
      expect(decoded.negrito, isFalse);
    });
  });

  group('getByNome / upsert via rede', () {
    test('getByNome retorna null quando não existe', () async {
      expect(await repository.getByNome('Não existe'), isNull);
    });

    test('getByNome encontra a etiqueta pelo nome', () async {
      await repository.save(buildLabel(nome: 'Açougue'));
      final found = await repository.getByNome('Açougue');

      expect(found, isNotNull);
      expect(found!.elementos, hasLength(2));
    });

    test('receber a mesma etiqueta duas vezes (mesmo nome) atualiza em vez de duplicar', () async {
      // Simula o que o handler /import-label faz: resolve o id pelo
      // nome antes de salvar.
      final first = buildLabel(nome: 'Padaria');
      await repository.save(first);

      final existing = await repository.getByNome('Padaria');
      final updated = LabelModel.fromJson(buildLabel(nome: 'Padaria').toJson()).copyWith(
        id: existing!.id,
        padrao: true,
        larguraMm: 60,
      );
      await repository.save(updated);

      final all = await repository.getAll();
      expect(all.where((l) => l.nome == 'Padaria'), hasLength(1));

      final defaultLabel = await repository.getDefault();
      expect(defaultLabel?.nome, 'Padaria');
      expect(defaultLabel?.larguraMm, 60);
    });
  });
}
