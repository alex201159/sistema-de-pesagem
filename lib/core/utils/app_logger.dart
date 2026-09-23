import 'package:logger/logger.dart';

/// Logger central do aplicativo.
///
/// Usar sempre `AppLogger.i`/`AppLogger.e`/etc. em vez de `print`, para
/// que os logs tenham nível, timestamp e possam futuramente ser
/// redirecionados para arquivo (auditoria, ver escopo item 38).
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 5,
      lineLength: 100,
      colors: false,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void d(String message) => _logger.d(message);
  static void i(String message) => _logger.i(message);
  static void w(String message, [Object? error]) => _logger.w(message, error: error);
  static void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
