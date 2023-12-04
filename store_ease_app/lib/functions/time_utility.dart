import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

String dayOfWeekConverter(
  BuildContext context,
  int dayOfWeek,
) {
  switch (dayOfWeek) {
    case 1:
      return AppLocalizations.of(context)!.monday;
    case 2:
      return AppLocalizations.of(context)!.tuesday;
    case 3:
      return AppLocalizations.of(context)!.wednesday;
    case 4:
      return AppLocalizations.of(context)!.thursday;
    case 5:
      return AppLocalizations.of(context)!.friday;
    case 6:
      return AppLocalizations.of(context)!.saturday;
    case 7:
      return AppLocalizations.of(context)!.sunday;
    default:
      return '';
  }
}

List<String> dayOfWeekConverterList(
    BuildContext context, List<int> dayOfWeekList) {
  return dayOfWeekList.map((dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return AppLocalizations.of(context)!.monday;
      case 2:
        return AppLocalizations.of(context)!.tuesday;
      case 3:
        return AppLocalizations.of(context)!.wednesday;
      case 4:
        return AppLocalizations.of(context)!.thursday;
      case 5:
        return AppLocalizations.of(context)!.friday;
      case 6:
        return AppLocalizations.of(context)!.saturday;
      case 7:
        return AppLocalizations.of(context)!.sunday;
      default:
        return '';
    }
  }).toList();
}

String formatTimeOfDay(
  TimeOfDay timeOfDay,
) {
  return '${timeOfDay.hour.toString().padLeft(2, '0')} : ${timeOfDay.minute.toString().padLeft(2, '0')}';
}

class DateTimeConverter {
  const DateTimeConverter(this.value);

  final DateTime value;

  factory DateTimeConverter.fromString(String time) => DateTimeConverter(
        DateTime.parse(time),
      );

  // 將輸入的UTC+0時間轉換成local，並用成需要的格式
  String toLocalTimeString() => DateFormat('yyyy-MM-dd HH:mm:ss').format(
        value.toLocal(),
      );

  DateTime toDateTime() => value;
}
