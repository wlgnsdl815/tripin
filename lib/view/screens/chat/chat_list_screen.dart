import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/chat_list_controller.dart';
import 'package:tripin/utils/app_screens.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';

class ChatListScreen extends GetView<ChatListController> {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    print('리스트를 보여줄 때 현재 유저: $currentUserUid');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나의 여행 방',
          style: AppTextStyle.header20(),
        ),
        backgroundColor: PlatformColors.subtitle7,
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Obx(
        () => ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: controller.chatList.length,
          itemBuilder: (context, index) {
            print(controller.chatList.length);
            return InkWell(
              onTap: () {
                controller.setRoomId(controller.chatList[index].roomId);
                print(controller.roomId);
                Get.offAndToNamed(AppScreens.chat);
              },
              child: ListTile(
                title: Text(
                    '${controller.chatList[index].roomId}, ${controller.chatList[index].participants!.length}, ${controller.chatList[index].updatedAt}'),
                subtitle: Text(
                    '${controller.chatList[index].participants![0].email}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
