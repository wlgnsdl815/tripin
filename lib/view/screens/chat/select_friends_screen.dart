import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/view/screens/chat/chat_screen.dart';

class SelectFriendsScreen extends GetView<SelectFriendsController> {
  const SelectFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '친구선택',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.userData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.userData[index].nickName),
                    leading: CircleAvatar(),
                    trailing: Obx(
                      () {
                        bool isSelected = controller.participants
                            .contains(controller.userData[index].uid);
                        return IconButton(
                          onPressed: () {
                            if (isSelected) {
                              controller.participants
                                  .remove(controller.userData[index].uid);
                            } else {
                              controller.participants
                                  .add(controller.userData[index].uid);
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
              Get.to(
                () => ChatScreen(roomId),
              );
            },
            child: Text('채팅방 생성'),
          ),
        ],
      ),
    );
  }
}
