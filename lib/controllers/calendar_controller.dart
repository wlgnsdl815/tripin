import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/model/event_model.dart';
import 'package:tripin/utils/colors.dart';

class CalendarController extends GetxController {
  RxList<Event> events = <Event>[].obs;
  List<DateTime> selectedDates = [];

  void addCheckList({required String title}) async {
    final SelectFriendsController _selectFriendsController =
        Get.find<SelectFriendsController>();

    // print('${_selectFriendsController.roomId.value}');
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection('calendar')
    //     .doc(_selectFriendsController.roomId.value)
    //     .set(eventData.toMap());
    // .collection('chatRooms')
    // .doc(_selectFriendsController.roomId.value)
    // .collection('calendar')
    // .doc()
    // .set(eventData.toMap());
    print('일정이 Firestore에 추가되었습니다.');
  }

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
}