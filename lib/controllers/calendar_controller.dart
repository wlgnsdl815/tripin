import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/model/enum_color.dart';
import 'package:tripin/model/event_model.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/utils/colors.dart';

class CalendarController extends GetxController {
  UserModel userModel = Get.find<AuthController>().userInfo.value!;
  // RxList<Event> events = <Event>[].obs;
  List<DateTime> selectedDates = [];
  RxString selectedRandomColor = ''.obs;
  Rxn<List<DateTime>> dateRange = Rxn<List<DateTime>>([]);
  // final CrCalendarController calendarController = CrCalendarController();
  Rxn startDate = Rxn();
  Rxn endDate = Rxn();
  RxList<DateTime> allEvent = <DateTime>[].obs;
  RxString selectedCity = ''.obs;
  RxMap<DateTime, dynamic> convertedMap = <DateTime, dynamic>{}.obs;

  void readEvent() async {
    var db = FirebaseFirestore.instance;
    QuerySnapshot res = await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('calendar')
        .get();

    res.docs.forEach((DocumentSnapshot doc) {
      if (doc.exists) {
        final color = doc.get('color') as String;
        // 이제 color 변수를 사용하여 원하는 작업을 수행할 수 있습니다.
        print('Color from Firestore: $color');
      }
    });

    List snapshotData =
        res.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    snapshotData.map((e) {
      // 원하는 작업 수행
    });
  }

  void readAllEvent() {
    if (userModel.joinedTrip != null && userModel.joinedTrip!.isNotEmpty) {
      userModel.joinedTrip!.forEach((trip) {
        trip!.dateRange.forEach((element) {
          convertedMap[element] = trip;
        });
      });
    }
    print('맵 :$convertedMap');
  }

  final events = LinkedHashMap(
  equals: isSameDay,
);

Map<DateTime, dynamic> getEventsForDay(DateTime day) {
    return events[day] ?? {};

  }
// LinkedHashMap<DateTime, List<ChatRoom>> convertedLinkedMap = LinkedHashMap(
//   equals: isSameDay,
// );

// convertedMap.forEach((date, trip) {
//   if (convertedLinkedMap.containsKey(date)) {
//     // 이미 같은 날짜의 이벤트가 있는 경우 리스트에 추가
//     convertedLinkedMap[date]!.add(trip);
//   } else {
//     // 같은 날짜의 이벤트가 없는 경우 새로운 리스트 생성
//     convertedLinkedMap[date] = [trip];
//   }
// });

// void readCity(){
//   if (userModel.joinedTrip != null) {
//     // 여러 개의 여행이 있는 경우에 대한 처리
//     List<String> cities = [];
//     userModel.joinedTrip!.forEach((element) {
//       if (element != null && !cities.contains(element.city)) {
//         cities.add(element.city);
//       }
//     });
//     print('찍힌 도시 ${selectedCity.value}');
//     }}

  //   void _setTexts(int year, int month) {
  //       // final _appbarTitleNotifier = ValueNotifier<String>('');
  // // final _monthNameNotifier = ValueNotifier<String>('');
  //   final date = DateTime(year, month);
  //   // _appbarTitleNotifier.value = date.format(kAppBarDateFormat);
  //   _monthNameNotifier.value = date.month.toString();
  // }

  void generateRandomColor() {
    selectedRandomColor.value = CalendarColors.getRandomColor();
  }

  @override
  void onInit() {
    super.onInit();
    readAllEvent();
     events.addAll(convertedMap);
    // readCity();
  }
}
