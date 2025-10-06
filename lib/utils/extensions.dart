import 'package:intl/intl.dart';

extension StringExtension on String {
  double? toDouble() {
    return double.tryParse(this);
  }

  int? toInt() {
    return int.tryParse(this);
  }
}
