import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripin/controllers/global_getx_controller.dart';

class ChatSettingController extends GetxController {
  final GlobalGetXController _globalGetXController =
      Get.find<GlobalGetXController>();
  final TextEditingController chatTitleEdit = TextEditingController();

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
        {'imgUrl': downloadUrl},
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
      {'roomTitle': chatTitleEdit.text},
    );
    _globalGetXController.setRoomTitle(chatTitleEdit.text);
  }

  // 채팅방 나가기 (참가자 목록, User - joinedTrip에서 해당 유저지우기)
  leaveChatRoom() {}
}
