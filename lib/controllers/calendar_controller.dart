import 'dart:collection';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/model/check_list.dart';
import 'package:tripin/model/enum_color.dart';
import 'package:tripin/model/event_model.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/utils/colors.dart';

class CalendarController extends GetxController {
  UserModel userModel = Get.find<AuthController>().userInfo.value!;
  List<DateTime> selectedDates = [];
  RxString selectedRandomColor = ''.obs;
  Rxn<List<DateTime>> dateRange = Rxn<List<DateTime>>([]);
  Rxn startDate = Rxn();
  Rxn endDate = Rxn();
  RxList<DateTime> allEvent = <DateTime>[].obs;
  RxString selectedCity = ''.obs;
  RxMap<DateTime, dynamic> convertedMap = <DateTime, dynamic>{}.obs;
  RxMap<String, dynamic> checkLists = <String, dynamic>{}.obs;
  TextEditingController checklistController = TextEditingController();
  RxBool isEditing = false.obs;
  String selectedItem = ''; // 선택한 항목을 저장하는 변수

  // void readEvent() async {
  //   var db = FirebaseFirestore.instance;
  //   QuerySnapshot res = await db
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('calendar')
  //       .get();

  //   res.docs.forEach((DocumentSnapshot doc) {
  //     if (doc.exists) {
  //       final color = doc.get('color') as String;
  //       print('Color from Firestore: $color');
  //     }
  //   });

  //   List snapshotData =
  //       res.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

  //   snapshotData.map((e) {
  //     // 원하는 작업 수행
  //   });
  // }

  void readAllEvent(List? joinedTrip) {
    log('${userModel.joinedTrip!.length}', name: 'readAllEvent호출시 joinedTrip');

    if (joinedTrip != null && joinedTrip.isNotEmpty) {
      joinedTrip.forEach((trip) {
        trip!.dateRange.forEach((element) {
          convertedMap[element] = trip;
        });
      });
    }
    print('맵 :$convertedMap');
    log('${convertedMap.length}', name: 'convertedMap');
  }

  final events = LinkedHashMap(
    equals: isSameDay,
  );

  Map<DateTime, dynamic> getEventsForDay(DateTime day) {
    return events[day] ?? {};
  }

  void generateRandomColor() {
    selectedRandomColor.value = CalendarColors.getRandomColor();
  }

  void toggleCheck() {
    userModel.joinedTrip!.forEach((chatRoom) {
      chatRoom!.checkList = chatRoom.checkList ?? [];
    });
    print('체크리스트 :$checkLists');
  }

void showAddChecklistDialog(BuildContext context) {
  TextEditingController checklistController = TextEditingController();

  Get.defaultDialog(
    title: selectedItem.isNotEmpty ? '체크리스트 편집' : '체크리스트 항목 추가',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: checkLists.keys.map((item) {
            return Row(
              children: [
                Radio<String>(
                  value: item,
                  groupValue: selectedItem,
                  onChanged: (String? value) {
                    if (value != null) {
                      // Radio 버튼을 선택할 때 selectedItem 업데이트
                      selectedItem = value;
                      checklistController.text = value;
                      Get.back(); // 다이얼로그 닫기
                      showAddChecklistDialog(context); // 새 다이얼로그 열기
                    }
                  },
                ),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        TextField(
          controller: checklistController,
          decoration: InputDecoration(
            labelText: selectedItem.isNotEmpty ? '항목 이름 수정' : '새 항목 이름',
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            String checkListName = checklistController.text.trim();

            if (selectedItem.isNotEmpty) {
              // 기존 항목을 수정하는 경우
              if (checkListName.isNotEmpty) {
                checkLists[checkListName] = checkLists[selectedItem];
                checkLists.remove(selectedItem);
                selectedItem = ''; // 수정 완료 후 selectedItem 초기화
              }
            } else {
              // 새 항목을 추가하는 경우
              if (checkListName.isNotEmpty) {
                checkLists[checkListName] = false;
              }
            }

            Get.back(); // 다이얼로그 닫기
          },
          child: Text(selectedItem.isNotEmpty ? '수정' : '추가'),
        ),
      ],
    ),
  );
}


  @override
  void onInit() {
    super.onInit();
    readAllEvent(userModel.joinedTrip);
    events.addAll(convertedMap);
    generateRandomColor();
  }
}
