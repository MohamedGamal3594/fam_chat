import 'package:intl/intl.dart' as intl;

String formatMessageDate(DateTime dateTime) {
  DateTime now = DateTime.now();

  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    return intl.DateFormat.jm().format(dateTime);
  }

  final yesterday = now.subtract(const Duration(days: 1));
  if (dateTime.year == yesterday.year &&
      dateTime.month == yesterday.month &&
      dateTime.day == yesterday.day) {
    return "Yesterday";
  }

  return intl.DateFormat.yMMMd().format(dateTime);
}

bool isRTL(String text) {
  return intl.Bidi.detectRtlDirectionality(text);
}
