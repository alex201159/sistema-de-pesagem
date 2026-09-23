import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/data/database/app_database.dart';
import 'package:pesagem_totem/data/models/scale_model.dart';
import 'package:pesagem_totem/data/repositories/scale_repository.dart';

void main() {
  late AppDatabase db;
  late ScaleRepository repository;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    repository = ScaleRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  ScaleModel buildScale({String endereco = 'AA:BB:CC:DD:EE:FF', bool padrao = false}) {
    return ScaleModel(
      nome: 'Balança de bancada',
      endereco: endereco,
      tipoConexao: ScaleTransportType.ble,
      protocolo: 'generico',
      padrao: padrao,
    );
  }

  test('salva e lista balanças', () async {
    await repository.save(buildScale());
    final all = await repository.getAll();

    expect(all, hasLength(1));
    expect(all.first.endereco, 'AA:BB:CC:DD:EE:FF');
  });

  test('marcar uma balança como padrão desmarca as demais', () async {
    await repository.save(buildScale(endereco: 'AA:AA:AA:AA:AA:AA', padrao: true));
    await repository.save(buildScale(endereco: 'BB:BB:BB:BB:BB:BB', padrao: true));

    final all = await repository.getAll();
    final defaults = all.where((s) => s.padrao).toList();
    expect(defaults, hasLength(1));
    expect(defaults.first.endereco, 'BB:BB:BB:BB:BB:BB');

    final defaultScale = await repository.getDefault();
    expect(defaultScale?.endereco, 'BB:BB:BB:BB:BB:BB');
  });

  test('salvar novamente com o mesmo endereço atualiza em vez de duplicar', () async {
    await repository.save(buildScale(endereco: 'AA:AA:AA:AA:AA:AA'));
    await repository.save(buildScale(endereco: 'AA:AA:AA:AA:AA:AA').copyWith(nome: 'Renomeada'));

    final all = await repository.getAll();
    expect(all, hasLength(1));
    expect(all.first.nome, 'Renomeada');
  });

  test('getDefault retorna null quando nenhuma balança é padrão', () async {
    await repository.save(buildScale());
    expect(await repository.getDefault(), isNull);
  });
}
