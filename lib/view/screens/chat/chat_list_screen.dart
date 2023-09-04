import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/chat_list.dart';
import 'package:tripin/view/screens/chat/chat_screen.dart';

class ChatListScreen extends GetView<ChatListController> {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
