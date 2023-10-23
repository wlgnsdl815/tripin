import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/utils/calendar/colors.dart';
import 'package:tripin/view/widget/calendar/day_event_bottom_sheet.dart';

class CalendarControllerJihoon extends GetxController {
  CrCalendarController crCalendarController = CrCalendarController();
  List<CalendarEventModel> eventList = [];

  @override
  void onInit() {
    createExampleEvents();
    print(crCalendarController.events);
    super.onInit();
  }

  void _onCalendarPageChanged(int year, int month) {}
  void createExampleEvents() {
    eventList.add(
      CalendarEventModel(
        name: '✈️ 부산 여행',
        begin: DateTime.now().add(
          Duration(days: 18),
        ),
        end: DateTime.now().add(
          Duration(days: 20),
        ),
        eventColor: eventColors[0],
      ),
    );
    crCalendarController =
        CrCalendarController(onSwipe: _onCalendarPageChanged, events: eventList
            // [
            // CalendarEventModel(
            //   name: '✈️ 부산 여행',
            //   begin: DateTime.now().add(
            //     Duration(days: 18),
            //   ),
            //   end: DateTime.now().add(
            //     Duration(days: 20),
            //   ),
            //   eventColor: eventColors[0],
            // ),
            // CalendarEventModel(
            //   name: '부산 여행',
            //   begin: DateTime.now().add(
            //     Duration(days: 6),
            //   ),
            //   end: DateTime.now().add(
            //     Duration(days: 8),
            //   ),
            //   eventColor: eventColors[1],
            // ),
            // CalendarEventModel(
            //   name: '여행여행',
            //   begin: DateTime.now().add(
            //     Duration(days: 7),
            //   ),
            //   end: DateTime.now().add(
            //     Duration(days: 10),
            //   ),
            //   eventColor: eventColors[3],
            // ),
            // CalendarEventModel(
            //   name: '오늘 부터',
            //   begin: DateTime.now(),
            //   end: DateTime.now().add(
            //     Duration(days: 1),
            //   ),
            //   eventColor: eventColors[3],
            // ),
            // ],
            );
  }

  void showDayEventsInModalSheet(
      List<CalendarEventModel> events, DateTime day) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
        isScrollControlled: true,
        context: Get.context!,
        builder: (context) => DayEventsBottomSheet(
              events: events,
              day: day,
              screenHeight: MediaQuery.of(context).size.height,
            ));
  }
}
