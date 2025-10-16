import 'package:intl/intl.dart';

extension StringExtension on String {
  double? toDouble() {
    return double.tryParse(this);
  }

  int? toInt() {
    return int.tryParse(this);
  }

  DateTime? toDate() {
    DateFormat dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    return dateFormat.parse(this);
  }
}

extension DateTimeExtension on DateTime {
  String toDDMMYYYY() {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(this);
  }

  String toYYYYMMDD() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(this);
  }
}
