import '../../data/models/printer_model.dart';

/// Dados já calculados de uma etiqueta, prontos para impressão —
/// desacoplados de layout visual (isso é o `LabelRenderer`, Etapa 6).
class LabelPrintData {
  final String produto;
  final String codigo;

  /// Peso em kg quando o produto é vendido por peso; quantidade de
  /// unidades quando [porUnidade] é `true` — ver
  /// `LabelPlaceholderResolver`, que formata o elemento `peso` da
  /// etiqueta de acordo.
  final double peso;

  final double precoKg;
  final double total;
  final String codigoBarras;
  final DateTime dataHora;
  final DateTime? validade;

  /// `true` quando [peso] representa uma quantidade de unidades (não
  /// peso em kg) — ver `WeighingState.porUnidade`.
  final bool porUnidade;

  const LabelPrintData({
    required this.produto,
    required this.codigo,
    required this.peso,
    required this.precoKg,
    required this.total,
    required this.codigoBarras,
    required this.dataHora,
    this.validade,
    this.porUnidade = false,
  });
}

enum PrinterConnectionStatus { desconectada, conectando, conectada, erro }

/// Contrato de comunicação com a impressora térmica.
///
/// O transporte (Bluetooth/BLE/USB/TCP — ver escopo, item 27) e o
/// protocolo de comandos (ESC/POS, TSPL — ver escopo, item 29) ficam
/// atrás desta interface única, permitindo trocar o hardware sem
/// alterar telas/controllers.
abstract class PrinterService {
  Stream<PrinterConnectionStatus> get connectionStatusStream;

  PrinterConnectionStatus get currentStatus;

  Future<void> connect(PrinterModel printer);

  Future<void> disconnect();

  /// Envia uma etiqueta para impressão. Deve lançar
  /// [PrinterException]/subclasses em caso de falha — nunca falhar
  /// silenciosamente (a operação de pesagem não pode se perder).
  Future<void> printLabel(LabelPrintData data);

  /// Libera recursos internos (streams, conexões). Chamado pelo
  /// [PrinterServiceManager] ao trocar de implementação e pelos
  /// providers ao serem descartados.
  void dispose();
}
