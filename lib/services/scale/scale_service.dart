import '../../data/models/scale_model.dart';

/// Estado de conexão da balança (ver escopo, item 11).
enum ScaleConnectionStatus { semBalanca, conectando, conectada, erro }

/// Uma leitura bruta de peso recebida da balança, em quilogramas.
class ScaleReading {
  final double kg;
  final DateTime timestamp;

  const ScaleReading({required this.kg, required this.timestamp});
}

/// Contrato de comunicação com uma balança.
///
/// Implementações concretas (Bluetooth, BLE, TCP/IP, USB serial, ESP32
/// etc. — ver escopo, item 10) ficam isoladas atrás desta interface,
/// permitindo trocar o hardware sem alterar telas/controllers.
abstract class ScaleService {
  /// Leituras brutas de peso, emitidas continuamente enquanto conectado.
  Stream<ScaleReading> get weightStream;

  /// Cada linha crua recebida do transporte (BLE/serial), antes do
  /// recorte de [ScaleLineWeightParser] — emitida mesmo quando o
  /// recorte configurado não consegue extrair um peso, para permitir
  /// calibrar o recorte na tela de configuração (ver escopo, item 12).
  /// [NullScaleService] (sem balança) não tem dado bruto real e
  /// retorna um stream vazio.
  Stream<String> get rawLineStream;

  /// Estado de conexão da balança.
  Stream<ScaleConnectionStatus> get connectionStatusStream;

  ScaleConnectionStatus get currentStatus;

  Future<void> connect(ScaleModel scale);

  Future<void> disconnect();

  /// Libera recursos internos (streams, timers, conexões). Chamado pelo
  /// [ScaleServiceManager] ao trocar de implementação e pelos
  /// providers ao serem descartados (ver escopo, item 10 — trocar a
  /// balança não deve vazar recursos da implementação anterior).
  void dispose();
}
