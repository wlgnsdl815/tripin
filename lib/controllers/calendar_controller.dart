import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/model/enum_color.dart';
import 'package:tripin/model/event_model.dart';
import 'package:tripin/utils/colors.dart';

class CalendarController extends GetxController {
  RxList<Event> events = <Event>[].obs;
  List<DateTime> selectedDates = [];
      RxString selectedRandomColor = ''.obs;
  Rxn<List<DateTime>> dateRange = Rxn<List<DateTime>>([]);
  // final CrCalendarController calendarController = CrCalendarController();
  Rxn startDate = Rxn();
  Rxn endDate = Rxn();


  // void addCheckList({required String title}) async {
  //   final SelectFriendsController _selectFriendsController =
  //       Get.find<SelectFriendsController>();

  //   // print('${_selectFriendsController.roomId.value}');
  //   // await FirebaseFirestore.instance
  //   //     .collection('users')
  //   //     .doc(FirebaseAuth.instance.currentUser!.uid)
  //   //     .collection('calendar')
  //   //     .doc(_selectFriendsController.roomId.value)
  //   //     .set(eventData.toMap());
  //   // .collection('chatRooms')
  //   // .doc(_selectFriendsController.roomId.value)
  //   // .collection('calendar')
  //   // .doc()
  //   // .set(eventData.toMap());
  //   print('일정이 Firestore에 추가되었습니다.');
  // }

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


  //   void _setTexts(int year, int month) {
  //       // final _appbarTitleNotifier = ValueNotifier<String>('');
  // // final _monthNameNotifier = ValueNotifier<String>('');
  //   final date = DateTime(year, month);
  //   // _appbarTitleNotifier.value = date.format(kAppBarDateFormat);
  //   _monthNameNotifier.value = date.month.toString();
  // }

  Future<void> fetchChatRoomData() async {
    final CollectionReference chatRoomsCollection =
        FirebaseFirestore.instance.collection('chatRooms');
    try {
      QuerySnapshot chatRoomSnapshot = await chatRoomsCollection.get();
      for (QueryDocumentSnapshot document in chatRoomSnapshot.docs) {
        // Firestore 문서에서 데이터 추출
        String roomId = document['roomId'];
        String lastMessage = document['lastMessage'];
        int updatedAt = document['updatedAt'];
        List<String> participantIdList =
            List<String>.from(document['participants']);
        int? startDate = document['startDate'];
        int? endDate = document['endDate'];
        String city = document['city'];
        List dateRange = List.from(document['dateRange']);

        // 가져온 데이터를 사용하여 ChatRoom 객체를 생성하거나 처리합니다.
        // 이 예제에서는 데이터를 출력합니다.
        print('Room ID: $roomId');
        print('Last Message: $lastMessage');
        // 필요한 작업 수행...
        this.startDate.value = startDate;
        this.endDate.value = endDate;
      }
    } catch (e) {
      print('Error fetching chat room data: $e');
    }
  }
    void generateRandomColor() {
      selectedRandomColor.value = CalendarColors.getRandomColor();
    }

}
