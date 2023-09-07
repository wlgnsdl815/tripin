
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/edit_profile_controller.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({Key? key}) : super(key: key);
  // static const route = '/editProfile';

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.nickNameController.text = controller.userInfo.value!.nickName;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 수정'),
      ),
      body: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: '닉네임',
            ),
            controller: controller.nickNameController,
          ),
          GestureDetector(
            onTap: controller.selectProfileImage,
            child: Stack(
              children: [
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: Get.width * 0.5,
                      height: Get.width * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: controller.selectedImage.value != null
                            ? FileImage(File(controller.selectedImage.value!.path))
                            : controller.userInfo.value!.imgUrl != ''
                              ? NetworkImage(controller.userInfo.value!.imgUrl) as ImageProvider
                              : NetworkImage('http://picsum.photos/100/100'), // 나중에 디자인 나오면 기본 이미지로 수정
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: controller.editProfile,
            child: Text('수정'),
          ),
        ],
      ),
    );
  }
}

