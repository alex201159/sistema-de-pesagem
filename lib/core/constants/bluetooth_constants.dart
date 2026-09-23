/// Constantes relacionadas à comunicação Bluetooth/BLE.
///
/// Mantidas centralizadas para que a troca de balança ou impressora
/// não exija alterações espalhadas pelo código (ver ScaleService e
/// PrinterService em `services/`).
class BluetoothConstants {
  BluetoothConstants._();

  /// Tempo máximo de uma varredura (scan) de dispositivos.
  static const Duration scanTimeout = Duration(seconds: 10);

  /// Tempo máximo aguardando confirmação de conexão.
  static const Duration connectTimeout = Duration(seconds: 8);

  /// Intervalo entre tentativas automáticas de reconexão.
  static const Duration reconnectInterval = Duration(seconds: 15);

  /// Número máximo de tentativas automáticas de reconexão antes de
  /// desistir e sinalizar erro ao usuário.
  static const int maxReconnectAttempts = 5;

  /// UUID de serviço genérico Serial Port Profile (SPP), usado por boa
  /// parte das impressoras térmicas Bluetooth Classic.
  static const String sppServiceUuid = '00001101-0000-1000-8000-00805F9B34FB';

  /// UUIDs do serviço UART Nordic, usado pelo gateway BLE (ESP32) que
  /// faz a ponte entre a balança comum (serial) e o app (ver escopo,
  /// item 10 — "ESP32 BLE"). [uartTxCharacteristic] é a characteristic
  /// pela qual o gateway NOTIFICA leituras (o app recebe/"RX"), e
  /// [uartRxCharacteristic] é aquela em que o app ESCREVE comandos (o
  /// gateway recebe/"RX") — nomes mantidos como no firmware existente.
  static const String uartServiceUuid = '6E400001-B5A3-F393-E0A9-E50E24DCCA9E';
  static const String uartTxCharacteristic = '6E400003-B5A3-F393-E0A9-E50E24DCCA9E';
  static const String uartRxCharacteristic = '6E400002-B5A3-F393-E0A9-E50E24DCCA9E';
}
