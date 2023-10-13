import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';
import 'package:tripin/utils/calendar/colors.dart';

/// Widget of day item cell for calendar
class DayItemWidget extends StatelessWidget {
  const DayItemWidget({
    required this.properties,
    super.key,
  });

  final DayItemProperties properties;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 4),
          alignment: Alignment.topCenter,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: properties.isCurrentDay
                  ? Color(0xff4D80EE)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${properties.dayNumber}',
                style: TextStyle(
                  color: properties.isCurrentDay
                      ? Colors.white
                      : Colors.black
                          .withOpacity(properties.isInMonth ? 1 : 0.5),
                  fontSize: 17.0,
                ),
              ),
            ),
          ),
        ),
        if (properties.notFittedEventsCount > 0)
          Container(
            padding: const EdgeInsets.only(right: 2, top: 2),
            alignment: Alignment.topRight,
            child: Text(
              '+${properties.notFittedEventsCount}',
              style: TextStyle(
                fontSize: 10,
                color: violet.withOpacity(properties.isInMonth ? 1 : 0.5),
              ),
            ),
          ),
      ],
    );
  }
}
