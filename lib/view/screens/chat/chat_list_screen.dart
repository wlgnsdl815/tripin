import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tripin/controllers/chat/chat_list_controller.dart';
import 'package:tripin/controllers/global_getx_controller.dart';
import 'package:tripin/utils/app_screens.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';

class ChatListScreen extends GetView<ChatListController> {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalGetXController _globalGetXController =
        Get.find<GlobalGetXController>();
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
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                controller.chatList[index].updatedAt);
            String formattedTime = DateFormat('HH:mm').format(dateTime);
            print(controller.chatList.length);
            return InkWell(
              onTap: () {
                _globalGetXController
                    .setRoomId(controller.chatList[index].roomId);
                controller.setRoomId(controller.chatList[index].roomId);

                Get.toNamed(AppScreens.chat);
              },
              child: ListTile(
                title: Text(
                    '${controller.chatList[index].roomTitle} ${controller.chatList[index].participants!.length}, ${formattedTime}'),
                subtitle: Text(
                    '${controller.chatList[index].participants![0].email}'),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PlatformColors.primary,
        onPressed: () {
          Get.toNamed(AppScreens.selectFriends);
        },
        child: Image.asset(
          'assets/icons/create_chat_room.png',
          width: 25.w,
          height: 25.h,
        ),
      ),
    );
  }
}
