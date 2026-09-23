import 'dart:async';

import '../../core/utils/app_logger.dart';
import '../../data/models/printer_model.dart';
import 'printer_service.dart';

/// Impressora simulada: em vez de imprimir de verdade, apenas registra
/// a etiqueta em log e a expõe em [lastPrinted] (ver escopo, item 53).
///
/// Permite testar todo o fluxo de venda/etiqueta sem uma impressora
/// térmica Bluetooth conectada.
class MockPrinterService implements PrinterService {
  final _statusController = StreamController<PrinterConnectionStatus>.broadcast();
  PrinterConnectionStatus _status = PrinterConnectionStatus.desconectada;

  LabelPrintData? lastPrinted;

  @override
  Stream<PrinterConnectionStatus> get connectionStatusStream => _statusController.stream;

  @override
  PrinterConnectionStatus get currentStatus => _status;

  @override
  Future<void> connect(PrinterModel printer) async {
    _setStatus(PrinterConnectionStatus.conectando);
    await Future.delayed(const Duration(milliseconds: 300));
    _setStatus(PrinterConnectionStatus.conectada);
  }

  @override
  Future<void> disconnect() async {
    _setStatus(PrinterConnectionStatus.desconectada);
  }

  @override
  Future<void> printLabel(LabelPrintData data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    lastPrinted = data;
    AppLogger.i(
      'MockPrinterService: etiqueta "impressa" -> ${data.produto} | '
      '${data.peso} kg | R\$ ${data.total} | ${data.codigoBarras}',
    );
  }

  void _setStatus(PrinterConnectionStatus status) {
    _status = status;
    _statusController.add(status);
  }

  @override
  void dispose() => _statusController.close();
}
