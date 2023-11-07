
import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/calendar_controller_jihoon.dart';
import 'package:tripin/view/widget/calendar/day_item_widget.dart';
import 'package:tripin/view/widget/calendar/event_widget.dart';
import 'package:tripin/view/widget/calendar/week_days_widget.dart';

class CalendarTest extends StatefulWidget {
  const CalendarTest({super.key});

  @override
  State<CalendarTest> createState() => _CalendarTestState();
}

class _CalendarTestState extends State<CalendarTest> {

  CalendarControllerJihoon controller = Get.find<CalendarControllerJihoon>();

  @override
  Widget build(BuildContext context) {
    setState(() {
      print('setState');
      controller.crCalendarController.addEvents(controller.event);
    });
    return CrCalendar(
      forceSixWeek: false,
      maxEventLines: 2,
      eventsTopPadding: 47.0,
      backgroundColor: Colors.white,
      controller: controller.crCalendarController,
      // controller: controller.addChatRoomToCalendar(ChatRoom),
      initialDate: DateTime.now(),
      weekDaysBuilder: (day) => WeekDaysWidget(day: day),
      dayItemBuilder: (builderArgument) =>
          DayItemWidget(properties: builderArgument),
      eventBuilder: (drawer) => EventWidget(drawer: drawer),
      onDayClicked: controller.showDayEventsInModalSheet,
    );
  }
}
