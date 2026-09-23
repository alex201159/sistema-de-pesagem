/// Parâmetros de comunicação serial (RS232) usados tanto pelo gateway
/// BLE quanto pelo adaptador USB-OTG (ver escopo, item 10).
///
/// Portado de uma configuração já validada em campo contra balanças
/// comuns (protocolo serial padrão de balanças Toledo/Filizola e
/// similares) — os valores default e a lista [scanCandidates]
/// refletem os protocolos mais comuns nesse tipo de equipamento.
class SerialProtocol {
  final int baud;

  /// 'N' (nenhuma), 'E' (par) ou 'O' (ímpar).
  final String parity;
  final int stopBits;
  final int dataBits;

  const SerialProtocol({
    required this.baud,
    required this.parity,
    required this.stopBits,
    required this.dataBits,
  });

  String get label => '$baud $dataBits$parity$stopBits';

  /// Código de paridade no mesmo esquema usado pelo plugin `usb_serial`
  /// (`UsbPort.PARITY_NONE/ODD/EVEN` = 0/1/2).
  int get parityCode => switch (parity) {
        'O' => 1,
        'E' => 2,
        _ => 0,
      };

  /// Comando aceito pelo firmware do gateway BLE para configurar a
  /// serial antes de iniciar a leitura (ver [BleGatewayScaleService]).
  String get gatewayConfigCommand => 'STCFG:$baud:$parity:$stopBits:$dataBits';

  static const List<int> bauds = [1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200];
  static const List<String> parities = ['N', 'E', 'O'];
  static const List<String> parityLabels = ['Nenhuma', 'Par', 'Ímpar'];
  static const List<int> stopBitOptions = [1, 2];
  static const List<int> dataBitOptions = [7, 8];

  /// Protocolo padrão quando nada foi configurado ainda: 9600 8N2.
  static const SerialProtocol defaultProtocol =
      SerialProtocol(baud: 9600, parity: 'N', stopBits: 2, dataBits: 8);

  /// Ordem de tentativa do auto-scan de protocolo — dos mais comuns aos
  /// mais raros em balanças de bancada.
  static const List<SerialProtocol> scanCandidates = [
    SerialProtocol(baud: 9600, parity: 'N', stopBits: 2, dataBits: 8),
    SerialProtocol(baud: 9600, parity: 'N', stopBits: 1, dataBits: 8),
    SerialProtocol(baud: 4800, parity: 'N', stopBits: 1, dataBits: 8),
    SerialProtocol(baud: 4800, parity: 'N', stopBits: 2, dataBits: 8),
    SerialProtocol(baud: 19200, parity: 'N', stopBits: 1, dataBits: 8),
    SerialProtocol(baud: 2400, parity: 'N', stopBits: 1, dataBits: 8),
    SerialProtocol(baud: 2400, parity: 'N', stopBits: 2, dataBits: 8),
    SerialProtocol(baud: 19200, parity: 'N', stopBits: 2, dataBits: 8),
    SerialProtocol(baud: 1200, parity: 'N', stopBits: 1, dataBits: 8),
    SerialProtocol(baud: 38400, parity: 'N', stopBits: 1, dataBits: 8),
  ];
}
