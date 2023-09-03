
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripin/view/screens/home_screen.dart';

import '../model/user_model.dart';
import '../service/db_service.dart';
import 'home_controller.dart';

class EditProfileController extends GetxController {
  Rxn<UserModel> userInfo = Get.find<HomeController>().userInfo;    // 로그인한 유저 정보
  TextEditingController nickNameController = TextEditingController();
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

    userInfo.value!.nickName = nickNameController.text;
    await DBService().saveUserInfo(userInfo.value!);

    await Get.find<HomeController>().getUserInfo();

    Get.offAll(() => HomeScreen());
  }
}
