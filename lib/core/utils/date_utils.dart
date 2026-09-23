import 'package:intl/intl.dart';

/// Utilitários de formatação e manipulação de datas/horas.
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm:ss');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  static final DateFormat _dateTimeShortFormat = DateFormat('dd/MM/yyyy HH:mm');

  static String formatDate(DateTime date) => _dateFormat.format(date);

  static String formatTime(DateTime date) => _timeFormat.format(date);

  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  static String formatDateTimeShort(DateTime date) =>
      _dateTimeShortFormat.format(date);

  /// Calcula a data de validade a partir de hoje somando
  /// [validadeDias] dias.
  static DateTime calculateExpiryDate(int validadeDias, {DateTime? from}) {
    final base = from ?? DateTime.now();
    return DateTime(base.year, base.month, base.day).add(Duration(days: validadeDias));
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Início do dia (00:00:00) de uma data, útil para filtros de período.
  static DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  /// Fim do dia (23:59:59.999) de uma data, útil para filtros de período.
  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
}
