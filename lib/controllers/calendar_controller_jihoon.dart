import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
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
  String? roomId;

  @override
  void onInit() {
    chatRoomInfo(userModel.joinedTrip);
    final now = DateTime.now();
    onCalendarPageChanged(now.year, now.month);
    createEvents();
    super.onInit();
    crCalendarController.addListener(() {
          print('이베트 추가또는 삭제 ${crCalendarController.events!.length}');
        },);
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
      event;
    }
  }

  void onCalendarPageChanged(int year, int month) {
    updateCurrentYearMonth(DateTime(year, month));
  }

  void updateCurrentYearMonth(DateTime date) {
    final year = date.year;
    final month = date.month;
    currentYearMonth.value = '$year년 $month월';
  }

  void createEvents() {
    crCalendarController = CrCalendarController(
      onSwipe: (year, month) {
        onCalendarPageChanged(year, month);
      },
      events: event,
    );
  }


// void removeEventFromCalendar(String roomTitle) {
//   print('이벤트 제거 이전: $event');
//     event.removeWhere((eventModel) => eventModel.name == roomTitle);
//     print('이벤트 제거 이후: $event');
// }

// void removeEventFromCalendar(List<ChatRoom?>? joinedTrip) {
//   print('이벤트 제거 이전: $event');
//   if (joinedTrip != null) {
//     joinedTrip.forEach((element) {
//       event.removeWhere((eventModel) => eventModel.begin == element!.startDate && eventModel.end == element.endDate);
//     });
//   }
//   print('이벤트 제거 이후: $event');

//     print('이벤트 제거 이후: $event');
//     crCalendarController = CrCalendarController(
//       onSwipe: (year, month) {
//         onCalendarPageChanged(year, month);
//       },
//       events: event,
//     );
//   }

// void removeEventFromCalendar(List<ChatRoom?>? joinedTrip) {
//   // print('roomId: $roomId');
//   print('이벤트 제거 이전: $event');
//   event.removeWhere((eventModel) => joinedTrip.name == roomId);
//   print('이벤트 제거 이후: $event');
//   crCalendarController = CrCalendarController(
//     onSwipe: (year, month) {
//       onCalendarPageChanged(year, month);
//     },
//     events: event,
//   );
// }

//   void removeEvent(CalendarEventModel event) {
//   // 이벤트를 events 리스트에서 제거
//   event.(event);

//   // crCalendarController를 업데이트하여 변경된 이벤트를 반영
//   crCalendarController.addEvent(event);
// }

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
