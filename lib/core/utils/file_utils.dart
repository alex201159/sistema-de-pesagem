import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

/// Utilitários de arquivo usados pela importação (local e SMB) para
/// detectar duplicidade e estabilidade de arquivos (ver escopo, itens 7 e 8).
class FileUtils {
  FileUtils._();

  /// Calcula o hash SHA-256 do conteúdo de um arquivo.
  ///
  /// Usado para evitar reimportar um arquivo cujo conteúdo não mudou,
  /// mesmo que nome/data de modificação sejam iguais.
  static Future<String> calculateSha256(File file) async {
    final stream = file.openRead();
    final digest = await sha256.bind(stream).first;
    return digest.toString();
  }

  /// Calcula o hash SHA-256 de bytes já carregados em memória.
  static String calculateSha256Bytes(List<int> bytes) => sha256.convert(bytes).toString();

  /// Retorna um snapshot leve (tamanho + data de modificação) de um
  /// arquivo, usado pelo serviço de verificação de estabilidade sem
  /// precisar ler o conteúdo inteiro repetidamente.
  static Future<FileSnapshot> snapshot(File file) async {
    final stat = await file.stat();
    return FileSnapshot(size: stat.size, modified: stat.modified);
  }

  /// Decodifica bytes tentando primeiro UTF-8 e, em caso de falha,
  /// caindo para Latin-1 (ISO-8859-1), comum em arquivos gerados por
  /// sistemas legados/Windows.
  static String decodeText(List<int> bytes, {String? encoding}) {
    switch (encoding?.toUpperCase()) {
      case 'UTF8':
      case 'UTF-8':
        return utf8.decode(bytes, allowMalformed: true);
      case 'LATIN1':
      case 'ISO-8859-1':
      case 'ISO88591':
        return latin1.decode(bytes);
      default:
        try {
          return utf8.decode(bytes);
        } catch (_) {
          return latin1.decode(bytes);
        }
    }
  }
}

/// Estado leve de um arquivo em um instante (tamanho + data de
/// modificação), usado para comparações sucessivas de estabilidade.
class FileSnapshot {
  final int size;
  final DateTime modified;

  const FileSnapshot({required this.size, required this.modified});

  bool equals(FileSnapshot other) => size == other.size && modified == other.modified;

  @override
  String toString() => 'FileSnapshot(size: $size, modified: $modified)';
}
