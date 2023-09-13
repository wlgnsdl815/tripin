import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/model/event_model.dart';
import 'package:tripin/utils/colors.dart';

class CalendarController extends GetxController {
  RxList<Event> events = <Event>[].obs;

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
    QuerySnapshot res = await db.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('calendar').get();

    List snapshotData = res.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    
    snapshotData.map((e) {
      
    });
  }
}
