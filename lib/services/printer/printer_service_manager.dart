import 'dart:async';

import '../../core/utils/app_logger.dart';
import '../../data/models/printer_model.dart';
import 'printer_service.dart';

/// Encaminha para uma implementação [PrinterService] concreta,
/// trocável em tempo de execução — permite que a tela de configuração
/// troque a impressora (mock -> Bluetooth) sem que `WeighingController`
/// precise recriar suas assinaturas de stream (ver escopo, item 27:
/// "possibilitar trocar futuramente... impressora... sem reescrever
/// todo o aplicativo").
class PrinterServiceManager implements PrinterService {
  PrinterServiceManager(PrinterService initial) : _active = initial {
    _pipe(_active);
  }

  PrinterService _active;
  StreamSubscription<PrinterConnectionStatus>? _statusSub;
  final _statusController = StreamController<PrinterConnectionStatus>.broadcast();

  /// Emite o status atual imediatamente para quem começar a ouvir
  /// agora (ex.: reabrindo a tela de configuração depois de já ter
  /// conectado a impressora), e então repassa as próximas mudanças —
  /// sem isso, um novo ouvinte só veria algo quando o status mudasse
  /// de novo, o que nunca acontece com uma impressora já conectada e
  /// estável (mesmo ajuste já usado em [ScaleServiceManager]).
  @override
  Stream<PrinterConnectionStatus> get connectionStatusStream async* {
    yield currentStatus;
    yield* _statusController.stream;
  }

  @override
  PrinterConnectionStatus get currentStatus => _active.currentStatus;

  @override
  Future<void> connect(PrinterModel printer) => _active.connect(printer);

  @override
  Future<void> disconnect() => _active.disconnect();

  @override
  Future<void> printLabel(LabelPrintData data) => _active.printLabel(data);

  /// Substitui a implementação ativa por [implementation] e conecta em
  /// [printer] imediatamente, sem bloquear quem chamou (ver escopo,
  /// item 45) — falhas de conexão chegam via [connectionStatusStream].
  Future<void> useImplementation(PrinterService implementation, PrinterModel printer) async {
    await _retireActive();
    _active = implementation;
    _pipe(_active);
    try {
      await _active.connect(printer);
    } catch (e, st) {
      AppLogger.e('Falha ao conectar na impressora recém-configurada', e, st);
    }
  }

  void _pipe(PrinterService service) {
    _statusSub = service.connectionStatusStream.listen(_statusController.add);
  }

  Future<void> _retireActive() async {
    await _statusSub?.cancel();
    try {
      await _active.disconnect();
    } catch (_) {}
    _active.dispose();
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _active.dispose();
    _statusController.close();
  }
}
