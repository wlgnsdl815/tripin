import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:sfac_design_flutter/sfac_design_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tripin/controllers/calendar_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/controllers/map/map_screen_controller.dart';
import 'package:tripin/controllers/profile_detail_controller.dart';
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
    final SelectFriendsController _selectFriendsController =
        Get.find<SelectFriendsController>();

    print(_selectFriendsController.roomId.value);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.list)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search))
        ],
      ),
      body:
          // Column(
          //   children: [
          //     Row(
          //       children: [
          //       ],
          //     ),
          //     CrCalendar(
          //       controller: controller.calendarController,
          //       eventsTopPadding: 32,
          //       maxEventLines: 3,

          //       // forceSixWeek: true,
          //       // dayItemBuilder: ,
          //       // weekDaysBuilder: (day) => Container(
          //       //   height: 40,
          //       //   child: Center(
          //       //     child: Text(
          //       //       describeEnum(day).substring(0, 1).toUpperCase(),
          //       //       style: TextStyle(
          //       //         color: Colors.purple.withOpacity(0.9),
          //       //       ),
          //       //     ),
          //       //   ),
          //       // ),
          //       // eventBuilder: (drawer) => EventWidget(drawer: drawer),
          //       // onDayClicked: _showDayEventsInModalSheet,
          //       minDate: DateTime.now().subtract(const Duration(days: 1000)),
          //       maxDate: DateTime.now().add(const Duration(days: 180)),
          //       initialDate: DateTime.now(),
          //       onDayClicked: (events, day) {
          //         print(day);
          //         print(events);
          //       },

          //     ),
          //   ],
          // ),

          // CalendarCarousel(
          //   weekFormat: false,
          //   todayButtonColor: PlatformColors.primary,
          //   locale: 'ko_KR',
          // onDayPressed: (selectedDay, focusedDay) {
          //   // 날짜를 선택하면 다이얼로그를 열고 일정을 입력받습니다.
          //   showDialog(
          //     context: context,
          //     builder: (context) {
          //       final TextEditingController eventTextController =
          //           TextEditingController();
          //       return AlertDialog(
          //         title: Text("일정 추가"),
          //         content: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Text("날짜: ${selectedDay.toLocal()}"),
          //             TextField(
          //               controller: eventTextController,
          //               decoration: InputDecoration(labelText: "일정 내용"),
          //             ),
          //           ],
          //         ),
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
        // firstDay: DateTime.now().subtract(Duration(days: 365 * 2)),
         firstDay: DateTime.utc(2022, 01, 01),
        lastDay: DateTime.now().add(Duration(days: 365 * 2)),
        focusedDay: DateTime.now(),
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
// rangeStartDay: Get.find<ProfileDetailController>().joinedChatRoomList.isNotEmpty
//     ? DateTime.fromMillisecondsSinceEpoch(
//         Get.find<ProfileDetailController>().joinedChatRoomList[0]!.startDate ?? 0)
//     : DateTime.now(),       
// rangeStartDay: controller.startDate.value,
rangeStartDay: DateTime.now().add(Duration(days: 2)),
     rangeEndDay: DateTime.now().add(Duration(days: 5)),
        rangeSelectionMode: RangeSelectionMode.toggledOff,
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          rangeStartDecoration: BoxDecoration(
              color:  PlatformColors.primaryLight, shape: BoxShape.circle),
          rangeEndDecoration: BoxDecoration(
              color: PlatformColors.primaryLight, shape: BoxShape.circle),
          // rangeHighlightColor: Color(int.parse(
          //     "0xFF${Get.find<SelectFriendsController>().rangeHighlightColor.value}")),
        ),

        // todayDecoration: BoxDecoration(
        //     color: PlatformColors.primary, shape: BoxShape.circle),
        // eventLoader:,
        // calendarFormat: _calendarFormat,
        // onFormatChanged: (format) {
        //   if (_calendarFormat != format) {
        //     SizedBox();
        //     // Call `setState()` when updating calendar format
        //   }
        // },
        rowHeight: MediaQuery.of(context).size.height/9,
        onDaySelected: (selectedDay, focusedDay) {
          // 날짜를 선택하면 다이얼로그를 열고 일정을 입력받습니다.
          Get.toNamed(EventDetailPage.route);
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     final TextEditingController eventTextController =
          //         TextEditingController();
          //     return AlertDialog(
          //       title: Text("일정 추가"),
          //       content: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Text("날짜: ${selectedDay.toLocal()}"),
          //           TextField(
          //             controller: eventTextController,
          //             decoration: InputDecoration(labelText: "일정 내용"),
          //           ),
          //         ],
          //       ),
          //       actions: [
          //         ElevatedButton(
          //           onPressed: () {
          //             controller.addCheckList(title: '핑핑이들');
          //             Navigator.of(context).pop();
          //             // Get.back();
          //           },
          //           child: Text("추가"),
          //         ),
          //       ],
          //     );
          //   },
          // );
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
