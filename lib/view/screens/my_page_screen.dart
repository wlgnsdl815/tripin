
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import 'calendar_screen.dart';
import 'chat/chat_list_screen.dart';
import 'chat/select_friends_screen.dart';
import 'edit_profile_screen.dart';
import 'friend_screen.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              authController.logOut();
            },
            child: Text('로그아웃'),
          ),
          Obx(
                () => Container(
              width: Get.width * 0.5,
              height: Get.width * 0.5,
              child: Image.network(
                  authController.userInfo.value?.imgUrl.isEmpty ?? true
                      ? 'http://picsum.photos/100/100'
                      : authController.userInfo.value!.imgUrl),
            ),
          ),
          Obx(() => Text(authController.userInfo.value != null
              ? authController.userInfo.value!.nickName
              : '이름: null')),
          Obx(() => Text(authController.userInfo.value != null
              ? authController.userInfo.value!.message
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
          ElevatedButton(
            onPressed: () async {
              Get.to(() => CalendarScreen());
            },
            child: Text('캘린더'),
          ),

        ],
      ),
    );
  }
}

