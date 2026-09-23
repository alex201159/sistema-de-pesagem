import 'app_exception.dart';

/// Erro relacionado ao servidor HTTP de importação (ver escopo, item 6 —
/// recebe arquivos enviados pelo app companheiro Windows/Mac).
class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause, super.stackTrace});
}

/// Falha ao iniciar o servidor de importação (ex.: porta já em uso).
class ImportServerException extends NetworkException {
  const ImportServerException(super.message, {super.cause, super.stackTrace});
}
