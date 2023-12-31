import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/view/screens/home_screen.dart';

import '../model/user_model.dart';
import '../service/db_service.dart';

class EditProfileController extends GetxController {
  Rxn<UserModel> userInfo = Get.find<AuthController>().userInfo; // 로그인한 유저 정보
  TextEditingController nickNameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  Rxn<File> selectedImage = Rxn();

  // 이미지 선택
  Future<void> selectProfileImage() async {
    var picker = ImagePicker();
    var res = await picker.pickImage(source: ImageSource.gallery);
    if (res != null) {
      selectedImage(File(res.path));
    }
  }

  // 프로필 수정
  Future<void> editProfile() async {
    if (selectedImage.value != null) {
      // 스토리지에 사진 업로드
      var ref = FirebaseStorage.instance.ref('profile/${userInfo.value!.uid}');
      await ref.putFile(selectedImage.value!);
      var downloadUrl = await ref.getDownloadURL();

      // 유저 정보의 imgUrl에 downloadUrl 넣어주기
      userInfo.value!.imgUrl = downloadUrl;
    }

    if (nickNameController.text != '') userInfo.value!.nickName = nickNameController.text;
    if (messageController != '') userInfo.value!.message = messageController.text;
    await DBService().saveUserInfo(userInfo.value!);

    await Get.find<AuthController>().getUserInfo(userInfo.value!.uid);
    resetInput();
  }

  // 입력값 초기화
  void resetInput() {
    selectedImage(null);
    nickNameController.clear();
    messageController.clear();
  }
}
