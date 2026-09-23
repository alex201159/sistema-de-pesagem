import 'app_exception.dart';

/// Erro relacionado à comunicação ou impressão na impressora térmica.
class PrinterException extends AppException {
  const PrinterException(super.message, {super.cause, super.stackTrace});
}

/// Nenhuma impressora configurada/pareada.
class PrinterNotConfiguredException extends PrinterException {
  const PrinterNotConfiguredException([
    super.message = 'Nenhuma impressora configurada.',
  ]);
}

/// Falha ao conectar ou transmitir dados para a impressora.
class PrinterConnectionException extends PrinterException {
  const PrinterConnectionException(super.message, {super.cause, super.stackTrace});
}

/// Falha ao gerar os comandos do protocolo (ESC/POS, TSPL, etc.).
class PrinterDriverException extends PrinterException {
  const PrinterDriverException(super.message, {super.cause, super.stackTrace});
}
