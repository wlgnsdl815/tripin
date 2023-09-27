import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tripin/controllers/calendar_controller.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/model/enum_color.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/page/event_detail_page.dart';

class CalendarScreen extends GetView<CalendarController> {
  const CalendarScreen({super.key});
  static const route = '/calender';

  @override
  Widget build(BuildContext context) {
    // final profileDetailController = Get.find<ProfileDetailController>();
    // // DateTime selectedStartDay = ;
    // profileDetailController.startDay.value = selectedStartDay;
//     final profileDetailController = Get.find<ProfileDetailController>();
// profileDetailController.setRangeStartDay(controller.startDate.value);
//     controller.calendarController.selectedRange.begin =
//         controller.startDate.value;
//     controller.calendarController.selectedRange.end = controller.endDate.value;
//     print(controller.calendarController.selectedRange.begin);
//     print(controller.startDate.value);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: PlatformColors.subtitle8,
          elevation: 0,
        ),
        body: SafeArea(
          child: Obx(
            () => TableCalendar(
              
              locale: 'ko_KR',
              firstDay: DateTime.utc(2022, 01, 01),
              lastDay: DateTime.now().add(Duration(days: 365 * 2)),
              focusedDay: DateTime.now(),
              rowHeight: MediaQuery.of(context).size.height / 10,
              calendarStyle: CalendarStyle(
                holidayTextStyle: TextStyle(color: PlatformColors.negative),
                // markerDecoration 사용
                markerDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CalendarColors.getColorByString(
                      controller.selectedRandomColor.value),
                ),
              ),
              // onDaySelected: (selectedDay, focusedDay) {
              //   // 선택한 날짜(selectedDay)와 관련된 점(마커)가 있는지 확인
              //   bool hasChatEvent = controller.allEvent.any((chatDate) =>
              //       chatDate.year == selectedDay.year &&
              //       chatDate.month == selectedDay.month &&
              //       chatDate.day == selectedDay.day);

              //   if (hasChatEvent) {
              //     // 관련된 점(마커)가 있다면 원하는 페이지로 이동
              //     Get.to(() => EventDetailPage());
              //   }
              // },
              eventLoader: (day) {
                // day에 해당하는 이벤트 목록 가져오기
                List<dynamic> eventsForDay = [];

                controller.convertedMap.forEach((date, event) {
                  if (date.year == day.year &&
                      date.month == day.month &&
                      date.day == day.day) {
                    eventsForDay.add(event);
                  }
                });

                return eventsForDay;
              },
              onDaySelected: (selectedDay, focusedDay) {
                List<dynamic> eventsForDay = [];

                controller.convertedMap.forEach((date, event) {
                  if (date.year == selectedDay.year &&
                      date.month == selectedDay.month &&
                      date.day == selectedDay.day) {
                    eventsForDay.add(event);
                  }
                });

                for (var event in eventsForDay) {
                  if (event is ChatRoom) {
                    String city = event.city;
                    List<DateTime> dateRange = event.dateRange;

                    print('Selected city: $city');
                    print('Selected date: $dateRange');
                    Get.toNamed(EventDetailPage.route,
                        arguments: {'city': city, 'dateRange': dateRange});
                  }
                }
              },
              // eventLoader: (day) {
              //   return controller.getEventsForDay(day);
              //   // // 특정 날짜에 채팅 이벤트가 있는지 확인
              //   // bool hasChatEvent = controller.allEvent.any((chatDate) =>
              //   //     chatDate.year == day.year &&
              //   //     chatDate.month == day.month &&
              //   //     chatDate.day == day.day);

              //   // // 이벤트가 있는 경우 해당 날짜 반환, 없는 경우 빈 리스트 반환
              //   // return hasChatEvent ? [day] : [];
              // },
              
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: AppTextStyle.body18M(),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: PlatformColors.title,
                ),
              ),
            ),
          ),
        ));
  }
}
