import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/utils/app_logger.dart';
import '../../data/database/app_database.dart';
import '../../data/models/audit_log_model.dart';
import '../../data/models/import_model.dart';
import '../../data/models/label_model.dart';
import '../../data/repositories/audit_repository.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/repositories/label_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/settings_repository.dart';
import 'exclitem_parser.dart';
import 'import_service.dart';
import 'import_validator.dart';
import 'itens_mgv_parser.dart';

/// Servidor HTTP de importação (ver escopo, itens 6 e 43): recebe
/// arquivos enviados pelo app companheiro Windows/Mac que vigia a
/// pasta do ERP (substitui a antiga tentativa de importação via SMB,
/// que nunca chegou a ser implementada de verdade).
///
/// Lógica de transporte pura, independente de como é hospedada: no
/// Android roda dentro do isolate do `flutter_foreground_task`
/// ([ImportServerTaskHandler], que abre sua própria conexão com o
/// banco porque isolates não compartilham objetos Dart); no desktop
/// (Windows/Linux/macOS) roda direto no isolate principal via
/// [BackgroundMonitorService], já que não há a restrição de execução
/// em segundo plano que motiva um foreground service ali.
class ImportHttpServer {
  /// Abre sua própria conexão com o banco (dona do ciclo de vida:
  /// fechada em [stop]) em vez de reaproveitar a do resto do app —
  /// necessário no isolate do `flutter_foreground_task` (Android, que
  /// não compartilha objetos Dart com a UI) e mantido também no
  /// desktop por simplicidade/consistência entre as duas hospedagens.
  factory ImportHttpServer.open() => ImportHttpServer._(AppDatabase());

  ImportHttpServer._(this._db)
      : _settingsRepository = SettingsRepository(_db),
        _productRepository = ProductRepository(_db),
        _auditRepository = AuditRepository(_db),
        _labelRepository = LabelRepository(_db),
        _importService = ImportService(
          parser: ItensMgvParser(),
          validator: ImportValidator(),
          productRepository: ProductRepository(_db),
          historyRepository: HistoryRepository(_db),
        );

  final AppDatabase _db;
  final SettingsRepository _settingsRepository;
  final ProductRepository _productRepository;
  final AuditRepository _auditRepository;
  final LabelRepository _labelRepository;
  final ImportService _importService;

  HttpServer? _server;

  Future<void> start() async {
    final port = await _settingsRepository.getImportServerPort();
    try {
      final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
      _server = server;
      AppLogger.i('Servidor de importação ouvindo na porta $port.');
      server.listen(_handleRequest);
    } catch (e, st) {
      AppLogger.e('Falha ao iniciar o servidor de importação na porta $port', e, st);
      rethrow;
    }
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
    await _db.close();
    AppLogger.i('Servidor de importação encerrado.');
  }

  Future<void> _handleRequest(HttpRequest request) async {
    try {
      if (request.method == 'GET' && request.uri.path == '/status') {
        await _respondJson(request, 200, {'app': 'pesagem_totem', 'status': 'ok'});
        return;
      }

      if (request.method == 'POST' && request.uri.path == '/import') {
        await _handleImport(request);
        return;
      }

      if (request.method == 'POST' && request.uri.path == '/import-label') {
        await _handleImportLabel(request);
        return;
      }

      if (request.method == 'POST' && request.uri.path == '/exclitem') {
        await _handleExclItem(request);
        return;
      }

      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
    } catch (e, st) {
      AppLogger.e('Falha ao atender requisição do servidor de importação', e, st);
      try {
        request.response.statusCode = HttpStatus.internalServerError;
        await request.response.close();
      } catch (_) {}
    }
  }

  Future<void> _handleImport(HttpRequest request) async {
    // Nome do arquivo enviado pelo app companheiro. `basename` evita
    // que um cabeçalho malicioso escreva fora do diretório temporário.
    final rawName = request.headers.value('x-file-name') ?? 'arquivo_recebido.txt';
    final fileName = p.basename(rawName);

    final builder = BytesBuilder();
    await for (final chunk in request) {
      builder.add(chunk);
    }
    final bytes = builder.takeBytes();

    final tempDir = await getTemporaryDirectory();
    final file = File(p.join(tempDir.path, fileName));
    await file.writeAsBytes(bytes);

    ImportModel result;
    try {
      final preview = await _importService.analyze(file);
      result = await _importService.execute(preview);
    } finally {
      if (await file.exists()) await file.delete();
    }

    await _auditRepository.insert(AuditLogModel(
      dataHora: DateTime.now(),
      tipo: AuditEventType.arquivoImportado,
      descricao:
          '${result.arquivo}: ${result.produtosNovos} novos, ${result.produtosAtualizados} '
          'atualizados, ${result.produtosComErro} com erro (recebido via rede)',
    ));

    await _respondJson(request, 200, {
      'arquivo': result.arquivo,
      'status': result.status.name,
      'novos': result.produtosNovos,
      'atualizados': result.produtosAtualizados,
      'comErro': result.produtosComErro,
      'mensagem': result.mensagem,
    });
  }

  /// Recebe uma etiqueta editada no sincronizador Windows/Mac (ver
  /// escopo — aba "Etiquetas" do `totem_import_sender`) e a salva como
  /// a etiqueta padrão (usada na impressão). Faz upsert pelo nome: uma
  /// etiqueta com o mesmo nome já existente é atualizada em vez de
  /// duplicada — diferente do editor local, aqui o nome é a identidade
  /// natural da etiqueta entre os dois apps.
  Future<void> _handleImportLabel(HttpRequest request) async {
    final builder = BytesBuilder();
    await for (final chunk in request) {
      builder.add(chunk);
    }
    final bytes = builder.takeBytes();

    late final LabelModel received;
    try {
      final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      received = LabelModel.fromJson(json);
    } catch (e, st) {
      AppLogger.e('Falha ao interpretar etiqueta recebida via rede', e, st);
      await _respondJson(request, 400, {
        'status': 'erro',
        'mensagem': 'Etiqueta inválida: $e',
      });
      return;
    }

    final existing = await _labelRepository.getByNome(received.nome);
    final toSave = received.copyWith(
      id: existing?.id,
      padrao: true,
      dataCriacao: existing?.dataCriacao,
    );
    await _labelRepository.save(toSave);

    await _auditRepository.insert(AuditLogModel(
      dataHora: DateTime.now(),
      tipo: AuditEventType.etiquetaRecebida,
      descricao: 'Etiqueta "${received.nome}" recebida via rede e definida como padrão '
          '(${existing == null ? 'nova' : 'atualizada'}).',
    ));

    await _respondJson(request, 200, {'status': 'ok', 'nome': received.nome});
  }

  /// Recebe um arquivo `EXCLITEM.txt` (ou os bytes já filtrados
  /// equivalentes) enviado pelo sincronizador e desativa os produtos
  /// correspondentes — nunca remove de verdade (ver
  /// `ProductRepository.deactivateByCodigos`). É o único jeito de uma
  /// exclusão feita no ERP realmente deixar de aparecer no totem: sem
  /// isso, um item excluído no ERP mas já importado antes continuaria
  /// ativo aqui para sempre.
  Future<void> _handleExclItem(HttpRequest request) async {
    final builder = BytesBuilder();
    await for (final chunk in request) {
      builder.add(chunk);
    }
    final bytes = builder.takeBytes();

    final codigos = ExclItemParser.parse(bytes);
    final count = await _productRepository.deactivateByCodigos(codigos);

    if (count > 0) {
      await _auditRepository.insert(AuditLogModel(
        dataHora: DateTime.now(),
        tipo: AuditEventType.arquivoImportado,
        descricao: '$count produto(s) desativado(s) via EXCLITEM (recebido via rede).',
      ));
    }

    await _respondJson(request, 200, {'status': 'sucesso', 'desativados': count});
  }

  Future<void> _respondJson(HttpRequest request, int statusCode, Map<String, dynamic> body) async {
    request.response
      ..statusCode = statusCode
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(body));
    await request.response.close();
  }
}
