import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tripin/controllers/calendar_controller.dart';
import 'package:tripin/controllers/chat/chat_list_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';

class CalenderScreen extends GetView<CalendarController> {
  const CalenderScreen({super.key});
  static const route = '/calender';

  @override
  Widget build(BuildContext context) {
// final ChatListController _chatListController = ChatListController();
//     print('${_chatListController.roomId.value}');

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
      body: TableCalendar(
        firstDay: DateTime.utc(2023, 08, 16),
        lastDay: DateTime.utc(2024, 3, 14),
        focusedDay: _focusedDay,
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
                      controller.addEvent(title: '핑핑이들');
                      Navigator.of(context).pop();
                      Get.back();
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