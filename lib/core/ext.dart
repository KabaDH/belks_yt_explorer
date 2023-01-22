import 'package:belks_tube/core/consts.dart';
import 'package:intl/intl.dart';

extension ConvertDateTimeForUi on DateTime {
  String convertDateTimeForUi() {
    if (this == invalidDate) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }
}
