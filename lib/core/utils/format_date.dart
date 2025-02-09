import 'package:intl/intl.dart';

String formatDate(String dateString) {
  final date = DateTime.parse(dateString).toLocal();
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inHours < 2) {
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}  ago';
    } else {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    }
  } else {
    final formattedDate = DateFormat('d MMMM, yyyy').format(date);
    return formattedDate;
  }
}
