import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/chat_list_controller.dart';
import 'package:tripin/view/screens/chat/chat_screen.dart';

class ChatListScreen extends GetView<ChatListController> {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    print('리스트를 보여줄 때 현재 유저: $currentUserUid');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '채팅방 목록보기',
        ),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.chatList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.to(() => ChatScreen(controller.chatList[index]['roomId']));
              },
              child: ListTile(
                title: Text(controller.chatList[index]['roomId']),
              ),
            );
          },
        ),
      ),
    );
  }
}
