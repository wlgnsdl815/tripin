import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';

/// Widget that represents week days in row above calendar month view.
class WeekDaysWidget extends StatelessWidget {
  const WeekDaysWidget({
    required this.day,
    super.key,
  });

  /// [WeekDay] value from [WeekDaysBuilder].
  final WeekDay day;

  String getKoreanWeekDay(WeekDay day) {
    switch (day) {
      case WeekDay.monday:
        return '월';
      case WeekDay.tuesday:
        return '화';
      case WeekDay.wednesday:
        return '수';
      case WeekDay.thursday:
        return '목';
      case WeekDay.friday:
        return '금';
      case WeekDay.saturday:
        return '토';
      case WeekDay.sunday:
        return '일';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor;
    switch (day) {
      case WeekDay.saturday:
        textColor = Colors.blue;
        break;
      case WeekDay.sunday:
        textColor = Colors.red;
        break;
      default:
        textColor = Colors.black;
    }
    return SizedBox(
      height: 50,
      child: Center(
        child: Text(
          getKoreanWeekDay(day),
          style: TextStyle(
            color: textColor,
            fontSize: 17.0,
          ),
        ),
      ),
    );
  }
}
