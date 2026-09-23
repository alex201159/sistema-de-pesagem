import 'app_exception.dart';

/// Erro relacionado à comunicação com a balança.
class ScaleException extends AppException {
  const ScaleException(super.message, {super.cause, super.stackTrace});
}

/// Nenhuma balança configurada ou disponível.
class ScaleNotConfiguredException extends ScaleException {
  const ScaleNotConfiguredException([
    super.message = 'Nenhuma balança configurada.',
  ]);
}

/// Falha ao interpretar os dados recebidos da balança.
class ScaleProtocolException extends ScaleException {
  final String? rawData;

  const ScaleProtocolException(super.message, {this.rawData, super.cause, super.stackTrace});
}
