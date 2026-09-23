import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesagem_totem/data/database/app_database.dart';
import 'package:pesagem_totem/data/models/printer_model.dart';
import 'package:pesagem_totem/data/repositories/printer_repository.dart';

void main() {
  late AppDatabase db;
  late PrinterRepository repository;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    repository = PrinterRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  PrinterModel buildPrinter({String endereco = 'AA:BB:CC:DD:EE:FF', bool padrao = false}) {
    return PrinterModel(
      nome: 'PT-380',
      endereco: endereco,
      tipoConexao: PrinterTransportType.bluetoothClassic,
      protocolo: PrinterProtocolType.tspl,
      padrao: padrao,
    );
  }

  test('salva e lista impressoras', () async {
    await repository.save(buildPrinter());
    final all = await repository.getAll();

    expect(all, hasLength(1));
    expect(all.first.protocolo, PrinterProtocolType.tspl);
  });

  test('marcar uma impressora como padrão desmarca as demais', () async {
    await repository.save(buildPrinter(endereco: 'AA:AA:AA:AA:AA:AA', padrao: true));
    await repository.save(buildPrinter(endereco: 'BB:BB:BB:BB:BB:BB', padrao: true));

    final defaultPrinter = await repository.getDefault();
    expect(defaultPrinter?.endereco, 'BB:BB:BB:BB:BB:BB');
  });

  test('salvar novamente com o mesmo endereço atualiza em vez de duplicar', () async {
    await repository.save(buildPrinter(endereco: 'AA:AA:AA:AA:AA:AA'));
    await repository.save(buildPrinter(endereco: 'AA:AA:AA:AA:AA:AA').copyWith(nome: 'Renomeada'));

    final all = await repository.getAll();
    expect(all, hasLength(1));
    expect(all.first.nome, 'Renomeada');
  });

  test('updateLastConnection grava a data da última conexão', () async {
    final id = await repository.save(buildPrinter());
    final when = DateTime(2026, 8, 25, 14, 0);
    await repository.updateLastConnection(id, when);

    final all = await repository.getAll();
    expect(all.first.ultimaConexao, when);
  });
}
