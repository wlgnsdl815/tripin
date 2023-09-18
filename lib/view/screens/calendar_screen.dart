import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:sfac_design_flutter/sfac_design_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tripin/controllers/calendar_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/controllers/map/map_screen_controller.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';

class CalendarScreen extends GetView<CalendarController> {
  const CalendarScreen({super.key});
  static const route = '/calender';

  @override
  Widget build(BuildContext context) {
    final SelectFriendsController _selectFriendsController =
        Get.find<SelectFriendsController>();

    final MapScreenController _mapScreenController =
        Get.find<MapScreenController>();
    print(_selectFriendsController.roomId.value);

    CalendarFormat _calendarFormat = CalendarFormat.month;
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.list)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search))
        ],
      ),
      body:
          // CalendarCarousel(
          //   weekFormat: false,
          //   todayButtonColor: PlatformColors.primary,
          //   locale: 'ko_KR',
          //   onDayPressed: (selectedDay, focusedDay) {
          //     // 날짜를 선택하면 다이얼로그를 열고 일정을 입력받습니다.
          //     showDialog(
          //       context: context,
          //       builder: (context) {
          //         final TextEditingController eventTextController =
          //             TextEditingController();
          //         return AlertDialog(
          //           title: Text("일정 추가"),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               Text("날짜: ${selectedDay.toLocal()}"),
          //               TextField(
          //                 controller: eventTextController,
          //                 decoration: InputDecoration(labelText: "일정 내용"),
          //               ),
          //             ],
          //           ),
          //           actions: [
          //             ElevatedButton(
          //               onPressed: () {
          //                 controller.addCheckList(title: '핑핑이들');
          //                 Navigator.of(context).pop();
          //                 // Get.back();
          //               },
          //               child: Text("추가"),
          //             ),
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
          TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2023, 08, 16),
        lastDay: DateTime.utc(2024, 3, 14),
        focusedDay: _focusedDay,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleTextStyle: AppTextStyle.body18M(),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: PlatformColors.title,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: PlatformColors.title,
          ),
        ),
        rangeStartDay: DateTime.now(),
        rangeEndDay: DateTime.now().add(Duration(days: 3)),
        rangeSelectionMode: RangeSelectionMode.toggledOff,
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          rangeStartDecoration: BoxDecoration(
              color: PlatformColors.primaryLight, shape: BoxShape.circle),
          rangeEndDecoration: BoxDecoration(
              color: PlatformColors.primaryLight, shape: BoxShape.circle),
          // rangeHighlightColor: Color(int.parse(
          //     "0xFF${Get.find<SelectFriendsController>().rangeHighlightColor.value}")),
        ),

        // todayDecoration: BoxDecoration(
        //     color: PlatformColors.primary, shape: BoxShape.circle),
        // eventLoader:,
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            SizedBox();
            // Call `setState()` when updating calendar format
          }
        },
        onDaySelected: (selectedDay, focusedDay) {
          // 날짜를 선택하면 다이얼로그를 열고 일정을 입력받습니다.
          showDialog(
            context: context,
            builder: (context) {
              final TextEditingController eventTextController =
                  TextEditingController();
              return AlertDialog(
                title: Text("일정 추가"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("날짜: ${selectedDay.toLocal()}"),
                    TextField(
                      controller: eventTextController,
                      decoration: InputDecoration(labelText: "일정 내용"),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      controller.addCheckList(title: '핑핑이들');
                      Navigator.of(context).pop();
                      // Get.back();
                    },
                    child: Text("추가"),
                  ),
                ],
              );
            },
          );
        },
        // eventLoader: (day) {
        //   final eventsForDay = controller.events.where((event) {
        //     return event.date.year == day.year &&
        //         event.date.month == day.month &&
        //         event.date.day == day.day;
        //   }).toList();
        //   return eventsForDay.map((event) {
        //     return controller.addEvent(event.date, event.title);
        //   }).toList();
        // },
      ),
    );
  }
}