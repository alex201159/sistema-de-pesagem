/// Transporte de comunicação com a balança (ver escopo, item 10).
enum ScaleTransportType {
  bluetoothClassic,
  ble,
  usbSerial,
  tcp,

  /// Porta serial COM real do PC (RS232 nativa ou adaptador USB-serial
  /// enxergado pelo Windows como COMn) — distinto de [usbSerial], que é
  /// a API USB-Host exclusiva do Android (ver escopo, adaptação para
  /// rodar no Windows).
  serialPort;

  String get label => switch (this) {
        ScaleTransportType.bluetoothClassic => 'Bluetooth',
        ScaleTransportType.ble => 'Bluetooth BLE',
        ScaleTransportType.usbSerial => 'USB Serial',
        ScaleTransportType.tcp => 'TCP/IP',
        ScaleTransportType.serialPort => 'Porta Serial (COM)',
      };
}

/// Balança conhecida/pareada.
///
/// [protocolo] identifica qual `ScaleParser` deve interpretar os bytes
/// recebidos (ex.: "toledo_prix3", "filizola_generico", "simulado").
class ScaleModel {
  final int? id;
  final String nome;
  final String endereco;
  final ScaleTransportType tipoConexao;
  final String protocolo;
  final bool padrao;

  const ScaleModel({
    this.id,
    required this.nome,
    required this.endereco,
    required this.tipoConexao,
    required this.protocolo,
    this.padrao = false,
  });

  ScaleModel copyWith({
    int? id,
    String? nome,
    String? endereco,
    ScaleTransportType? tipoConexao,
    String? protocolo,
    bool? padrao,
  }) {
    return ScaleModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      endereco: endereco ?? this.endereco,
      tipoConexao: tipoConexao ?? this.tipoConexao,
      protocolo: protocolo ?? this.protocolo,
      padrao: padrao ?? this.padrao,
    );
  }
}
