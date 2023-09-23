import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/model/enum_color.dart';
import 'package:tripin/model/event_model.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/utils/colors.dart';

class CalendarController extends GetxController {
  UserModel userModel = Get.find<AuthController>().userInfo.value!;
  RxList<Event> events = <Event>[].obs;
  List<DateTime> selectedDates = [];
  RxString selectedRandomColor = ''.obs;
  Rxn<List<DateTime>> dateRange = Rxn<List<DateTime>>([]);
  // final CrCalendarController calendarController = CrCalendarController();
  Rxn startDate = Rxn();
  Rxn endDate = Rxn();
  RxList<DateTime> allEvent = <DateTime>[].obs;
  RxString selectedCity = ''.obs;

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
    if (userModel.joinedTrip != null) {
      userModel.joinedTrip!.forEach((element) {
        element!.dateRange.forEach((element) {
          allEvent.add(element);
        });
      });
    }
  }

void readCity(){
  if (userModel.joinedTrip != null) {
    // 여러 개의 여행이 있는 경우에 대한 처리
    List<String> cities = [];
    userModel.joinedTrip!.forEach((element) {
      if (element != null && !cities.contains(element.city)) {
        cities.add(element.city);
      }
    });
    print('찍힌 도시 ${selectedCity.value}');
    }}


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
    readCity();
  }
}
