import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/global_getx_controller.dart';

class ChatSettingController extends GetxController {
  final GlobalGetXController _globalGetXController =
      Get.find<GlobalGetXController>();
  final TextEditingController chatTitleEdit = TextEditingController();

  RxString roomTitle = ''.obs;

  String get computedRoomTitle => _globalGetXController.roomTitle.value;

  // 채팅방 사진 업데이트

  // 채팅방 이름 업데이트
  upDateChatRoomTitle() async {
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc('${_globalGetXController.roomId}')
        .update(
      {'roomTitle': chatTitleEdit.text},
    );
    _globalGetXController.setRoomTitle(chatTitleEdit.text);
  }
  // 채팅방 나가기 (참가자 목록에서 해당 유저지우기)
}
