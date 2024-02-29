import 'package:intl/intl.dart';

String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime).abs();

  if (difference.inDays == 0 && now.day == dateTime.day && now.month == dateTime.month && now.year == dateTime.year) {
    return 'Today';
  } else if (difference.inDays == 1) {
    return '1d ago';
  } else if (difference.inDays > 1 && difference.inDays <= 30) {
    return '${difference.inDays}d ago';
  } else if (difference.inDays > 30 && now.month == dateTime.month && now.year == dateTime.year) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  } else {
    String month = DateFormat('MMM').format(dateTime);
    return '${dateTime.day} $month ${dateTime.year}';
  }
}

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('dd MMM yy').format(dateTime); // Format date as "28 Feb 24"
  return formattedDate;
}

String formatTime(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedTime = DateFormat.jm().format(dateTime); // Format time as "2:45 PM"
  return formattedTime;
}