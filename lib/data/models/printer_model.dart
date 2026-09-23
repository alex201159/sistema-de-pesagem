/// Transporte de comunicação com a impressora (ver escopo, itens 27-29).
///
/// A separação entre transporte e protocolo é intencional: Bluetooth é
/// o meio, ESC/POS ou TSPL é a linguagem de comandos.
enum PrinterTransportType {
  bluetoothClassic,
  ble,
  usb,
  tcp;

  String get label => switch (this) {
        PrinterTransportType.bluetoothClassic => 'Bluetooth',
        PrinterTransportType.ble => 'Bluetooth BLE',
        PrinterTransportType.usb => 'USB',
        PrinterTransportType.tcp => 'TCP/IP',
      };
}

/// Protocolo/linguagem de comandos da impressora.
enum PrinterProtocolType {
  escPos,
  tspl,
  cpcl,
  zpl;

  String get label => switch (this) {
        PrinterProtocolType.escPos => 'ESC/POS',
        PrinterProtocolType.tspl => 'TSPL',
        PrinterProtocolType.cpcl => 'CPCL',
        PrinterProtocolType.zpl => 'ZPL',
      };
}

/// Impressora térmica conhecida/pareada (ver escopo, item 30).
class PrinterModel {
  final int? id;
  final String nome;

  /// Endereço MAC (Bluetooth) ou host:porta (TCP).
  final String endereco;
  final PrinterTransportType tipoConexao;
  final PrinterProtocolType protocolo;
  final bool padrao;
  final DateTime? ultimaConexao;

  const PrinterModel({
    this.id,
    required this.nome,
    required this.endereco,
    required this.tipoConexao,
    required this.protocolo,
    this.padrao = false,
    this.ultimaConexao,
  });

  PrinterModel copyWith({
    int? id,
    String? nome,
    String? endereco,
    PrinterTransportType? tipoConexao,
    PrinterProtocolType? protocolo,
    bool? padrao,
    DateTime? ultimaConexao,
  }) {
    return PrinterModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      endereco: endereco ?? this.endereco,
      tipoConexao: tipoConexao ?? this.tipoConexao,
      protocolo: protocolo ?? this.protocolo,
      padrao: padrao ?? this.padrao,
      ultimaConexao: ultimaConexao ?? this.ultimaConexao,
    );
  }
}
