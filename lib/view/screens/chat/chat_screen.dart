import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/chat_controller.dart';
import 'package:tripin/controllers/home_controller.dart';
import 'package:tripin/model/chat_message_model.dart';

class ChatScreen extends GetView<ChatController> {
  final String roomId;
  const ChatScreen(
    this.roomId, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(roomId),
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
                    roomId,
                  );
                },
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<Map<dynamic, dynamic>>(
        stream: controller.getMessage(roomId),
        builder: (context, snapshot) {
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
                // 메세지들을 하나씩 담아주고
                final message = messageList[index];
                // 그 메세지의 발신자가 현재 로그인한 유저의 이름과 같은지 검사
                final isMe = message.sender ==
                    FirebaseAuth.instance.currentUser!.displayName;
                print(message.sender);
                return Container(
                  margin: EdgeInsets.all(8),
                  child: Align(
                    alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.sender,
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: isMe ? Colors.blue : Colors.grey[200],
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
