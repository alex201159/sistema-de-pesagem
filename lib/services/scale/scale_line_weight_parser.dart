/// Extrai um peso (kg) de uma linha crua recebida da balança, dado um
/// recorte configurável (posição/tamanho) e casas decimais implícitas
/// para quando o valor vier como inteiro sem separador (ver escopo,
/// item 12 — estabilidade/leitura do peso).
///
/// Portado de uma implementação já validada contra balanças reais que
/// enviam o peso em um protocolo serial de largura fixa: suporta os
/// marcadores de sinal `F` (força zero), `D`/`L` (positivo/negativo)
/// que antecedem o valor em alguns protocolos, além de vírgula ou
/// ponto como separador decimal.
class ScaleLineWeightParser {
  /// Posição inicial do peso na linha (1-based, como exibido ao
  /// operador na tela de configuração).
  final int extractStart;
  final int extractLength;

  /// Casas decimais implícitas quando o valor extraído for um inteiro
  /// puro (ex.: "000485" com 3 casas implícitas = 0.485).
  final int implicitDecimals;

  const ScaleLineWeightParser({
    this.extractStart = 1,
    this.extractLength = 8,
    this.implicitDecimals = 3,
  });

  ScaleLineWeightParser copyWith({
    int? extractStart,
    int? extractLength,
    int? implicitDecimals,
  }) {
    return ScaleLineWeightParser(
      extractStart: extractStart ?? this.extractStart,
      extractLength: extractLength ?? this.extractLength,
      implicitDecimals: implicitDecimals ?? this.implicitDecimals,
    );
  }

  /// Retorna o peso em kg extraído de [line], ou `null` se o recorte
  /// não contiver um valor numérico reconhecível.
  double? extract(String line) {
    final value = _weightSliceWithSign(line).trim();
    if (value.isEmpty) return null;

    final first = value[0].toUpperCase();
    if (first == 'F' || first == 'D' || first == 'L') {
      if (first == 'F') return 0;
      final parsed = _parseUnsigned(value.substring(1).trim());
      if (parsed == null) return null;
      return first == 'L' ? -parsed : parsed;
    }

    if (value.contains('.') || value.contains(',')) {
      return double.tryParse(value.replaceAll(',', '.'));
    }

    if (!RegExp(r'^-?\d+$').hasMatch(value)) return null;
    final integer = int.tryParse(value);
    if (integer == null) return null;
    return integer / _pow10(implicitDecimals);
  }

  double? _parseUnsigned(String source) {
    final clean = source.replaceAll('-', '');
    if (clean.contains('.') || clean.contains(',')) {
      return double.tryParse(clean.replaceAll(',', '.'));
    }
    final integer = int.tryParse(clean);
    if (integer == null) return null;
    return integer / _pow10(implicitDecimals);
  }

  /// Recorta [extractStart]/[extractLength] de [line], estendendo o
  /// início para trás quando houver um marcador de sinal (`-`, `F`,
  /// `D`, `L`) imediatamente antes do recorte configurado.
  String _weightSliceWithSign(String line) {
    final start = (extractStart - 1).clamp(0, line.length);
    final end = (start + extractLength).clamp(start, line.length);
    var signedStart = start;
    var cursor = start - 1;
    while (cursor >= 0 && line[cursor].trim().isEmpty) {
      cursor--;
    }
    if (cursor >= 0) {
      final char = line[cursor].toUpperCase();
      if (char == '-' || char == 'F' || char == 'D' || char == 'L') {
        signedStart = cursor;
      }
    }
    return line.substring(signedStart, end);
  }

  double _pow10(int decimals) {
    var result = 1.0;
    for (var i = 0; i < decimals; i++) {
      result *= 10;
    }
    return result;
  }
}
