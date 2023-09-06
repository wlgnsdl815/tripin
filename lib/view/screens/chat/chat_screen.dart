import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tripin/controllers/chat/chat_controller.dart';
import 'package:tripin/controllers/home_controller.dart';
import 'package:tripin/model/chat_message_model.dart';

class ChatScreen extends GetView<ChatController> {
  final String roomId;

  const ChatScreen({
    super.key,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController _controller = ScrollController();
    final HomeController homeController = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(roomId),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.map),
          ),
        ],
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
                    homeController.userInfo.value!.uid,
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

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (controller.scrollController.hasClients) {
                controller.scrollController.animateTo(
                  controller.scrollController.position.maxScrollExtent + 100,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }
            });

            return SafeArea(
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  // 메세지들을 하나씩 담아주고
                  final message = messageList[index];
                  // 그 메세지의 발신자가 현재 로그인한 유저의 이름과 같은지 검사
                  final isMe = message.sender ==
                      FirebaseAuth.instance.currentUser!.displayName;
                  print(message.sender);
                  // database에 있는 timestamp를 변환
                  DateTime dateTime =
                      DateTime.fromMillisecondsSinceEpoch(message.timestamp);
                  String formattedTime = DateFormat('HH:mm').format(dateTime);

                  return Container(
                    margin: EdgeInsets.all(8),
                    child: Align(
                      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(message.sender),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (isMe) Text(formattedTime),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color:
                                        isMe ? Colors.blue : Colors.grey[200],
                                  ),
                                  child: Text(
                                    message.text,
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                              ),
                              if (!isMe) Text(formattedTime),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            throw Exception();
          }
        },
      ),
    );
  }
}
