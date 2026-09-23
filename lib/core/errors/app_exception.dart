/// Exceção base do aplicativo.
///
/// Todas as exceções específicas de domínio (importação, balança,
/// impressora, etc.) devem estender esta classe para que a camada de UI
/// possa tratá-las de forma uniforme (ex.: exibir [message] ao operador
/// e registrar [cause]/[stackTrace] em log).
class AppException implements Exception {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const AppException(this.message, {this.cause, this.stackTrace});

  @override
  String toString() => 'AppException: $message'
      '${cause != null ? ' (causa: $cause)' : ''}';
}
