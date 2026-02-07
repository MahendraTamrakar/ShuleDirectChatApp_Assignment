import 'package:intl/intl.dart';

class Helpers {
  static String formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();

      if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day) {
        return DateFormat.jm().format(dateTime);
      } else if (now.difference(dateTime).inDays < 7) {
        return DateFormat.E().format(dateTime);
      } else {
        return DateFormat.yMMMd().format(dateTime);
      }
    } catch (e) {
      return '';
    }
  }
}
