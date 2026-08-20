import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppDateUtils {
  static final DateFormat fullDateTimeFr = DateFormat("d MMMM y 'à' HH'h'mm", 'fr');
  static final DateFormat shortDateFr = DateFormat("d MMM y", 'fr');
  static final DateFormat timeFr = DateFormat("HH'h'mm", 'fr');

  static Future<void> init() async {
    await initializeDateFormatting('fr', null);
  }

  static String formatDate(String isoDate) {
    try {
      final DateTime parsed = DateTime.parse(isoDate);
      return shortDateFr.format(parsed);
    } catch (_) {
      return isoDate;
    }
  }
}