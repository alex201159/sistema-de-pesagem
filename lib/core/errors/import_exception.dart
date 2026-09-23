import 'app_exception.dart';

/// Erro ocorrido durante a importação do arquivo de produtos.
///
/// [lineNumber] e [rawLine], quando presentes, identificam exatamente a
/// linha do arquivo que causou o problema (ver regra 55 do escopo: erros
/// de importação nunca devem ser ignorados silenciosamente).
class ImportException extends AppException {
  final int? lineNumber;
  final String? rawLine;

  const ImportException(
    super.message, {
    this.lineNumber,
    this.rawLine,
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    final location = lineNumber != null ? ' [linha $lineNumber]' : '';
    return 'ImportException$location: $message';
  }
}

/// Erro de conexão/acesso à pasta de importação (SMB).
class ImportConnectionException extends AppException {
  const ImportConnectionException(super.message, {super.cause, super.stackTrace});
}

/// Arquivo detectado ainda não está estável (em gravação) e não deve
/// ser importado.
class ImportFileNotStableException extends AppException {
  const ImportFileNotStableException(super.message, {super.cause, super.stackTrace});
}
