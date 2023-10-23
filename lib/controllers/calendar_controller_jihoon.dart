import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/chat/chat_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/utils/calendar/colors.dart';
import 'package:tripin/view/widget/calendar/day_event_bottom_sheet.dart';

class CalendarControllerJihoon extends GetxController {
  CrCalendarController crCalendarController = CrCalendarController();

  UserModel userModel = Get.find<AuthController>().userInfo.value!;
  List<CalendarEventModel> event = [];
  RxString currentYearMonth = ''.obs;
  RxMap<DateTime, dynamic> convertedMap = <DateTime, dynamic>{}.obs;
  var controllers = Get.find<SelectFriendsController>();

  @override
  void onInit() {
    chatRoomInfo(userModel.joinedTrip);
    createExampleEvents();
    super.onInit();
  }

  chatRoomInfo(List<ChatRoom?>? joinedTrip) {
    if (joinedTrip != null) {
      joinedTrip.forEach((element) {
        if (element != null) {
          event.add(CalendarEventModel(
            name: element.roomTitle,
            begin: element.startDate ?? DateTime(0),
            end: element.endDate ?? DateTime(0),
            eventColor: eventColors[0],
          ));
        }
      });
    }
  }

  AddEvent() {}

  void onCalendarPageChanged(int year, int month) {
    updateCurrentYearMonth(DateTime(year, month));
  }

  void updateCurrentYearMonth(DateTime date) {
    final year = date.year;
    final month = date.month;
    currentYearMonth.value = '$year년 $month월';
  }

  void createExampleEvents() {
    crCalendarController = CrCalendarController(
      onSwipe: (year, month) {
        onCalendarPageChanged(year, month);
      },
      events: event,
    );
  }

  void showDayEventsInModalSheet(
    List<CalendarEventModel> events,
    DateTime day,
  ) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      isScrollControlled: true,
      context: Get.context!,
      builder: (context) => DayEventsBottomSheet(
        events: event,
        day: day,
        screenHeight: MediaQuery.of(context).size.height,
      ),
    );
  }
}
