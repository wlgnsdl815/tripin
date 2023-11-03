import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/calendar_controller_jihoon.dart';

import 'package:tripin/controllers/global_getx_controller.dart';

import 'package:tripin/model/user_model.dart';

class ChatSettingController extends GetxController {
  Rxn<UserModel> userInfo = Get.find<AuthController>().userInfo; // 로그인한 유저 정보
  final GlobalGetXController _globalGetXController =
      Get.find<GlobalGetXController>();
  final TextEditingController chatTitleEdit = TextEditingController();
  RxList<String> participantsUid = <String>[].obs;
  CalendarControllerJihoon crCalendarController =
      Get.find<CalendarControllerJihoon>();

  RxString roomTitle = ''.obs;
  RxBool isInputValid = true.obs;
  Rxn<File> selectedImage = Rxn();

  String get computedRoomTitle => _globalGetXController.roomTitle.value;

  // 채팅방 사진 고르기
  selectProfileImage() async {
    var picker = ImagePicker();
    var res = await picker.pickImage(source: ImageSource.gallery);
    if (res != null) {
      selectedImage(File(res.path));
    }
  }

  // 채팅방 사진 업데이트
  upDateChatRoomImage() async {
    await selectProfileImage();
    if (selectedImage.value != null) {
      // 스토리지에 사진 업로드
      var ref = FirebaseStorage.instance
          .ref('chatRoomUrls/${_globalGetXController.roomId}');
      await ref.putFile(selectedImage.value!);
      var downloadUrl = await ref.getDownloadURL();

      // 채팅룸에 Url 넣기
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc('${_globalGetXController.roomId}')
          .update(
        {
          'imgUrl': downloadUrl,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        },
      );
      _globalGetXController.setRoomImageUrl(downloadUrl);
    }
    print('실행됨');
  }

  // 채팅방 이름 업데이트
  upDateChatRoomTitle() async {
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc('${_globalGetXController.roomId}')
        .update(
      {
        'roomTitle': chatTitleEdit.text,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
    );
    _globalGetXController.setRoomTitle(chatTitleEdit.text);
    
    // SelectFriendsController controllers = Get.find<SelectFriendsController>();
    // controllers.updateEventName(chatTitleEdit.text);
    //  CalendarControllerJihoon crCalendarController =
    // Get.find<CalendarControllerJihoon>();
  }

  // 채팅방 나가기 (참가자 목록, User - joinedTrip에서 해당 유저지우기)
  leaveChatRoom() async {
    CollectionReference chatRooms =
        FirebaseFirestore.instance.collection('chatRooms');
    DocumentReference roomDoc =
        chatRooms.doc(_globalGetXController.roomId.value);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentReference userDoc = users.doc(userInfo.value!.uid);

    //    removeChatRoomFromEvents(_globalGetXController.roomId.value);
    // print('이벤트에서 채팅방 삭제됨');
    CalendarControllerJihoon crCalendarController =
        Get.find<CalendarControllerJihoon>();
    print(crCalendarController.crCalendarController.events!.length);
    // crCalendarController.crCalendarController.events!.remove(eventToDelete);
    crCalendarController.crCalendarController.redrawCalendar();
    print(crCalendarController.crCalendarController.events!.length);
    print('지워졌나요? : ${crCalendarController.event}');
    //   crCalendarController.crCalendarController.clearSelected();
    print(crCalendarController.crCalendarController.events!.last.begin);
    print(_globalGetXController.startDate);

    print(
        '이게 될까? : ${crCalendarController.crCalendarController.events!.length}');
    // crCalendarController.crCalendarController.events!.remove(_globalGetXController.startDate == crCalendarController.crCalendarController.events!.map((e) => e.begin).toList());
    // crCalendarController.crCalendarController.events!.removeWhere(
    //     (element) => element.begin == _globalGetXController.startDate);
    // crCalendarController.crCalendarController.dispose();

    // 참가자 리스트에서 현재 사용자를 제거
    await roomDoc.update({
      'participants': FieldValue.arrayRemove([userInfo.value!.uid])
    });
    await userDoc.update({
      'joinedTrip': FieldValue.arrayRemove([_globalGetXController.roomId.value])
    });

    // 최신 상태의 문서 스냅샷을 가져옴
    DocumentSnapshot updatedSnapshot = await roomDoc.get();
    List updatedParticipants = updatedSnapshot.get('participants') ?? [];

    // 참가자 리스트가 비어 있다면 방 삭제
    if (updatedParticipants.isEmpty) {
      await roomDoc.delete();
      print('방이 삭제되었습니다.');
    }

// roomId를 전달하여 해당 채팅방의 이벤트를 제거
    print('3333 : ${crCalendarController.crCalendarController.events!.length}');
  }
}
