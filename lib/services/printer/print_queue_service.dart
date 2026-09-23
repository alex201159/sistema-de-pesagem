import 'dart:async';

import 'printer_service.dart';

/// Estado de um trabalho de impressão (ver escopo, item 32).
enum PrintJobStatus { pendente, enviando, impresso, erro, cancelado }

class PrintJob {
  final String id;
  final LabelPrintData data;
  PrintJobStatus status;
  String? errorMessage;

  PrintJob({
    required this.id,
    required this.data,
    this.status = PrintJobStatus.pendente,
    this.errorMessage,
  });
}

/// Fila de impressão (ver escopo, item 32): serializa os envios para a
/// impressora — mesmo que duas vendas fossem confirmadas quase ao
/// mesmo tempo, nunca envia duas etiquetas simultaneamente — e mantém
/// um histórico curto do estado de cada tentativa para a UI observar.
class PrintQueueService {
  PrintQueueService(this._printerService);

  final PrinterService _printerService;
  final _jobsController = StreamController<List<PrintJob>>.broadcast();
  final List<PrintJob> _jobs = [];

  /// Encadeia os trabalhos: cada [enqueue] só começa a enviar depois
  /// que o anterior terminou (sucesso ou falha), sem bloquear o
  /// chamador com espera ativa.
  Future<void> _tail = Future.value();

  Stream<List<PrintJob>> get jobsStream => _jobsController.stream;

  List<PrintJob> get jobs => List.unmodifiable(_jobs);

  /// Enfileira e envia uma etiqueta para impressão, retornando quando
  /// essa tentativa específica terminar (o chamador — hoje
  /// `WeighingController` — depende de aguardar o resultado antes de
  /// gravar o histórico, ver escopo item 59).
  Future<void> enqueue(LabelPrintData data, {required String jobId}) {
    final job = PrintJob(id: jobId, data: data);
    _jobs.add(job);
    _emit();

    final previous = _tail;
    final completer = Completer<void>();
    _tail = completer.future.catchError((_) {});

    previous.whenComplete(() async {
      job.status = PrintJobStatus.enviando;
      _emit();
      try {
        await _printerService.printLabel(data);
        job.status = PrintJobStatus.impresso;
        completer.complete();
      } catch (e) {
        job.status = PrintJobStatus.erro;
        job.errorMessage = e.toString();
        completer.completeError(e);
      } finally {
        _emit();
      }
    });

    return completer.future;
  }

  void _emit() => _jobsController.add(List.unmodifiable(_jobs));

  void dispose() => _jobsController.close();
}
