import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/calendar_controller.dart';
import 'package:tripin/controllers/calendar_controller_jihoon.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/view/widget/calendar/day_item_widget.dart';
import 'package:tripin/view/widget/calendar/event_widget.dart';
import 'package:tripin/view/widget/calendar/week_days_widget.dart';

class CalendarScreen2 extends GetView<CalendarControllerJihoon> {
  const CalendarScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Row(
                children: [
                  Obx(() => Text(controller.currentYearMonth.value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                  // Text('해당 년 월 표시'),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      controller.crCalendarController.swipeToPreviousPage();
                    },
                    icon: Icon(Icons.navigate_before),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.crCalendarController.swipeToNextMonth();
                    },
                    icon: Icon(Icons.navigate_next),
                  ),
                ],
              ),
              Container(
                height: 550,
                width: 400,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: CrCalendar(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


