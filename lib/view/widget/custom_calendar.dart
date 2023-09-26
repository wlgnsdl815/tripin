import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tripin/controllers/calendar_controller.dart';
import 'package:tripin/model/enum_color.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/page/event_detail_page.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
   PageController _pageController = PageController(initialPage: 0); 
  // 생성자에서 초기화
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // 커스텀 헤더 및 기타 위젯들을 여기에 추가
Container(
          padding: EdgeInsets.all(16),
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300), // 이동 애니메이션 시간 설정
                    curve: Curves.ease, // 이동 애니메이션 커브 설정
                  );
                },
              ),
              Text(
                'Custom Calendar Header',
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                color: Colors.white,
                onPressed: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300), // 이동 애니메이션 시간 설정
                    curve: Curves.ease, // 이동 애니메이션 커브 설정
                  );
                },),]),),
                       TableCalendar(
                    locale: 'ko_KR',
                    firstDay: DateTime.utc(2022, 01, 01),
                    lastDay: DateTime.now().add(Duration(days: 365 * 2)),
                    focusedDay: DateTime.now(),
                    rowHeight: MediaQuery.of(context).size.height / 9.5,
                    calendarStyle: CalendarStyle(
                      holidayTextStyle: TextStyle(color: PlatformColors.negative),
                      // markerDecoration 사용
                      markerDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CalendarColors.getColorByString(
                           Get.find<CalendarController>().selectedRandomColor.value),
                      ),
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      // 선택한 날짜(selectedDay)와 관련된 점(마커)가 있는지 확인
                      bool hasChatEvent = Get.find<CalendarController>().allEvent.any((chatDate) =>
                          chatDate.year == selectedDay.year &&
                          chatDate.month == selectedDay.month &&
                          chatDate.day == selectedDay.day);
                          
                      if (hasChatEvent) {
                        // 관련된 점(마커)가 있다면 원하는 페이지로 이동
                        // Get.to(() => EventDetailPage());
                      }
                    },
                    eventLoader: (day) {
                      // 특정 날짜에 채팅 이벤트가 있는지 확인
                      bool hasChatEvent = Get.find<CalendarController>().allEvent.any((chatDate) =>
                          chatDate.year == day.year &&
                          chatDate.month == day.month &&
                          chatDate.day == day.day);
                          
                      // 이벤트가 있는 경우 해당 날짜 반환, 없는 경우 빈 리스트 반환
                      return hasChatEvent ? [day] : [];
                    },
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleTextStyle: AppTextStyle.body18M(),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: PlatformColors.title,
                      ),
                    ),
                  ),
      ],
    );
  }
}