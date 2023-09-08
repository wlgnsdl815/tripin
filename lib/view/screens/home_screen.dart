import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/view/screens/chat/chat_list_screen.dart';
import 'package:tripin/view/screens/chat/select_friends_screen.dart';
import 'package:tripin/view/screens/friend_screen.dart';

import 'edit_profile_screen.dart';

class HomeScreen extends GetView<AuthController> {
  const HomeScreen({super.key});

  static const route = '/home';

  @override
  Widget build(BuildContext context) {
    print('Home: ${controller.userInfo}');
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              controller.logOut();
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
              : '이름: null')),
          Obx(() => Text(controller.userInfo.value != null
              ? controller.userInfo.value!.message
              : '메세지: null')),
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
          ElevatedButton(
            onPressed: () async {
              Get.to(() => FriendScreen());
            },
            child: Text('친구 목록'),
          ),
        ],
      ),
    );
  }
}
