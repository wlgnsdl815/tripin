import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/chat_list_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/view/screens/chat/chat_screen.dart';
import 'package:tripin/view/screens/chat/schedule_screen.dart';

class SelectFriendsScreen extends GetView<SelectFriendsController> {
  const SelectFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _chatListController = Get.find<ChatListController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '친구선택',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => ScheduleScreen());
            },
            child: Text(
              '다음',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.userData.length,
                itemBuilder: (context, index) {
                  if (controller.userData[index].uid ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    return SizedBox();
                  }
                  return ListTile(
                    title: Text(controller.userData[index].nickName),
                    leading: CircleAvatar(),
                    trailing: Obx(
                      () {
                        bool isSelected = controller.participants.any((user) =>
                            user.uid == controller.userData[index].uid);

                        return IconButton(
                          onPressed: () {
                            if (isSelected) {
                              controller.participants
                                  .remove(controller.userData[index]);
                            } else {
                              controller.participants
                                  .add(controller.userData[index]);
                            }
                          },
                          icon: Icon(
                            Icons.circle,
                            color: isSelected ? Colors.blue : Colors.grey,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String roomId = await controller.createChatRoom();
              _chatListController.setRoomId(roomId);
              Get.to(
                () => ChatScreen(
                  roomId: roomId,
                ),
              );
            },
            child: Text('채팅방 생성'),
          ),
        ],
      ),
    );
  }
}
