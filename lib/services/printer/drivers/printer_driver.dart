import '../../../data/models/label_model.dart';
import '../printer_service.dart';

/// Converte uma etiqueta (`LabelModel` + seus elementos) e os dados de
/// uma pesagem (`LabelPrintData`) nos comandos/bytes do protocolo de
/// uma impressora térmica (ver escopo, itens 28-29).
///
/// Bluetooth é apenas o transporte ([PrinterService]); ESC/POS, TSPL,
/// CPCL etc. são a linguagem de comandos gerada aqui — por isso a
/// separação: trocar de protocolo é trocar o driver, nunca o
/// transporte.
abstract class PrinterDriver {
  List<int> render(LabelModel label, LabelPrintData data);
}
