import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../../core/utils/app_logger.dart';
import '../import/import_http_server.dart';
import 'import_server_task_handler.dart';

/// Controla o servidor HTTP de importação (ver escopo, itens 6 e 43) —
/// inicialização, permissões e start/stop a partir da configuração de
/// importação automática.
///
/// Android tem uma restrição de execução em segundo plano que motiva
/// hospedar o servidor dentro de um foreground service
/// ([ImportServerTaskHandler], isolate próprio). No desktop
/// (Windows/Linux/macOS) essa restrição não existe — o processo roda
/// continuamente enquanto o app está aberto — então o
/// [ImportHttpServer] é hospedado direto aqui, no isolate principal.
class BackgroundMonitorService {
  BackgroundMonitorService._();

  static bool _initialized = false;
  static ImportHttpServer? _desktopServer;

  static void _ensureInitialized() {
    if (_initialized || !defaultTargetPlatform.isAndroidOrIOS) return;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'pesagem_totem_import_server',
        channelName: 'Servidor de Importação',
        channelDescription:
            'Recebe arquivos de produtos enviados pelo computador da loja.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        // O servidor HTTP atende sob demanda (evento de rede), não
        // precisa de um tick periódico — nunca um loop Dart solto
        // (ver escopo, item 43).
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
        allowWakeLock: true,
      ),
    );
    _initialized = true;
  }

  static Future<bool> start() async {
    if (!defaultTargetPlatform.isAndroidOrIOS) {
      if (_desktopServer != null) return true;
      try {
        final server = ImportHttpServer.open();
        await server.start();
        _desktopServer = server;
        return true;
      } catch (e, st) {
        AppLogger.e('Falha ao iniciar o servidor de importação (desktop)', e, st);
        return false;
      }
    }

    _ensureInitialized();

    if (await FlutterForegroundTask.isRunningService) return true;

    await FlutterForegroundTask.requestNotificationPermission();

    final result = await FlutterForegroundTask.startService(
      notificationTitle: 'Sistema de Pesagem',
      notificationText: 'Servidor de importação ativo',
      callback: importServerTaskEntryPoint,
    );

    if (result is ServiceRequestFailure) {
      AppLogger.e('Falha ao iniciar o servidor de importação', result.error);
      return false;
    }
    return true;
  }

  static Future<void> stop() async {
    if (!defaultTargetPlatform.isAndroidOrIOS) {
      await _desktopServer?.stop();
      _desktopServer = null;
      return;
    }

    if (!await FlutterForegroundTask.isRunningService) return;
    await FlutterForegroundTask.stopService();
  }

  /// Espelha o estado do servidor no desktop, onde não há
  /// `FlutterForegroundTask.isRunningService` para consultar.
  static Future<bool> get isRunningService async {
    if (!defaultTargetPlatform.isAndroidOrIOS) return _desktopServer != null;
    return FlutterForegroundTask.isRunningService;
  }
}

extension on TargetPlatform {
  bool get isAndroidOrIOS => this == TargetPlatform.android || this == TargetPlatform.iOS;
}
