import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/chat_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/controllers/home_controller.dart';
import 'package:tripin/model/chat_message_model.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final SelectFriendsController selectFriendsController =
        Get.find<SelectFriendsController>();
    print(selectFriendsController.roomId.value);

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(selectFriendsController.roomId.value),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add),
              ),
              Expanded(
                child: TextField(
                  controller: controller.messageController,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.sendMessage(
                    homeController.userInfo.value!.nickName,
                    controller.messageController.text,
                  );
                },
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<Map<dynamic, dynamic>>(
        stream: controller.getMessage(selectFriendsController.roomId.value),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('대화를 시작해보세요.'));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data is Map<dynamic, dynamic>) {
            Map<dynamic, dynamic> messages = snapshot.data!;
            var messageList = messages.entries
                .map((e) => ChatMessage.fromMap(e.value))
                .toList();

            // timestamp 속성을 기준으로 메시지 리스트 정렬
            messageList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

            return ListView.builder(
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messageList[index].text),
                );
              },
            );
          } else {
            throw Exception();
          }
        },
      ),
    );
  }
}
