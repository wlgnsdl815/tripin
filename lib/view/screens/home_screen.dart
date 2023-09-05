import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/controllers/home_controller.dart';
import 'package:tripin/view/screens/chat/chat_list_screen.dart';

import 'package:tripin/view/screens/chat/select_friends_screen.dart';

import 'edit_profile_screen.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  static const route = '/home';

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();
    Get.find<SelectFriendsController>();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _authController.logOut();
            },
            child: Text('로그아웃'),
          ),
          Obx(
            () => Container(
              width: Get.width * 0.5,
              height: Get.width * 0.5,
              child: Image.network(
                  controller.userInfo.value?.imgUrl.isEmpty ?? true
                      ? 'http://picsum.photos/100/100'
                      : controller.userInfo.value!.imgUrl),
            ),
          ),
          Obx(() => Text(controller.userInfo.value != null
              ? controller.userInfo.value!.nickName
              : 'null')),
          ElevatedButton(
            onPressed: () {
              Get.to(() => EditProfileScreen());
            },
            child: Text('프로필 수정'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.to(() => SelectFriendsScreen());
            },
            child: Text('채팅방 만들기'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.to(() => ChatListScreen());
            },
            child: Text('채팅방 목록'),
          ),
        ],
      ),
    );
  }
}
