import 'dart:convert';

/// Lê o arquivo `EXCLITEM.txt` (Toledo MGV6) — lista de itens a
/// excluir do MGV6 e de todas as balanças associadas. Layout oficial,
/// largura fixa, sem cabeçalho: `departamento (2) + código (6)` = 8
/// caracteres por linha.
///
/// Espelha `totem_import_sender`'s `ExclItemFileCodec` — os dois lados
/// entendem o mesmo formato, recebido aqui via `POST /exclitem` (ver
/// `ImportServerTaskHandler`). Este app nunca remove produtos de
/// verdade (mesma filosofia da importação): o repositório marca como
/// inativo (ver `ProductRepository.deactivateByCodigos`).
class ExclItemParser {
  ExclItemParser._();

  static const int lineLength = 8;

  static final RegExp _linePattern = RegExp(r'^\d{8}$');

  static List<String> parse(List<int> bytes) {
    final text = _decodeText(bytes);
    final codigos = <String>[];

    for (final rawLine in text.split(RegExp(r'\r?\n'))) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;
      if (line.length < lineLength) continue;

      final prefix = line.substring(0, lineLength);
      if (!_linePattern.hasMatch(prefix)) continue;

      final codigo = int.parse(prefix.substring(2, 8)).toString();
      if (codigo == '0') continue;

      codigos.add(codigo);
    }
    return codigos;
  }

  static String _decodeText(List<int> bytes) {
    try {
      return utf8.decode(bytes);
    } catch (_) {
      return latin1.decode(bytes);
    }
  }
}
