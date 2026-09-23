import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../../core/utils/app_logger.dart';
import '../import/import_http_server.dart';

/// Ponto de entrada do isolate do serviço em primeiro plano (ver
/// escopo, item 43) — registrado como `callback` em
/// `FlutterForegroundTask.startService`. Precisa ser uma função de
/// nível superior anotada com `vm:entry-point` para que o Android
/// consiga localizá-la ao recriar o isolate.
@pragma('vm:entry-point')
void importServerTaskEntryPoint() {
  FlutterForegroundTask.setTaskHandler(ImportServerTaskHandler());
}

/// Hospeda o [ImportHttpServer] (lógica HTTP transporte-agnóstica)
/// dentro de um isolate próprio do `flutter_foreground_task` — só
/// Android precisa disso (ver [BackgroundMonitorService]); no desktop
/// o mesmo servidor roda direto no isolate principal.
class ImportServerTaskHandler extends TaskHandler {
  ImportHttpServer? _server;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    final server = ImportHttpServer.open();
    _server = server;
    await server.start();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _server?.stop();
    AppLogger.i('Task handler do servidor de importação encerrado.');
  }
}
