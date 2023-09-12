import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/chat/chat_controller.dart';
import 'package:tripin/model/chat_message_model.dart';
import 'package:tripin/service/db_service.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/screens/chat/map_screen.dart';

import '../../../model/user_model.dart';

class ChatScreen extends GetView<ChatController> {
  final String roomId;

  const ChatScreen({
    super.key,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: PlatformColors.subtitle8,
      appBar: AppBar(
        title: Text(roomId),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: PlatformColors.title,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => MapScreen(
                  roomId: roomId,
                ),
              );
            },
            icon: Icon(Icons.map),
          ),
        ],
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
            // var messageList = messages.entries
            //     .map((e) => ChatMessage.fromMap(e.value))
            //     .toList();

            controller.readMessage(messages, messages.entries);

            // // timestamp 속성을 기준으로 메시지 리스트 정렬
            // messageList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (controller.scrollController.hasClients) {
                controller.scrollController.animateTo(
                  controller.scrollController.position.maxScrollExtent + 100,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }
            });

            return Column(
              children: [
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.messageList.length,
                      itemBuilder: (context, index) {
                        // 메세지들을 하나씩 담아주고
                        final message = controller.messageList[index];
                        // 그 메세지의 발신자가 현재 로그인한 유저의 이름과 같은지 검사
                        final isMe = message.sender!.uid ==
                            _authController.userInfo.value!.uid;
                        print('sender => ${message.sender}');
                        // database에 있는 timestamp를 변환
                        DateTime dateTime =
                            DateTime.fromMillisecondsSinceEpoch(message.timestamp);
                        String formattedTime = DateFormat('HH:mm').format(dateTime);

                            final currentChatDate = dateTime;
                            final currentSender = message.sender!.uid;
                            final minutes =
                                currentChatDate.minute + currentChatDate.hour * 60;

                            bool cutMinutes = (index == 0 ||
                                minutes !=
                                    DateTime.fromMillisecondsSinceEpoch(
                                        controller.messageList[index - 1].timestamp)
                                            .minute +
                                        DateTime.fromMillisecondsSinceEpoch(
                                            controller.messageList[index - 1].timestamp)
                                                .hour *
                                            60);

                            bool showUserName = (index == 0 ||
                                currentSender != controller.messageList[index - 1].sender!.uid ||
                                cutMinutes);
                            bool showTime = false;

                            if (index == controller.messageList.length - 1) {
                              showTime = true;
                            } else {
                              final nextChat = controller.messageList[index + 1];
                              final nextChatDate =
                                  DateTime.fromMillisecondsSinceEpoch(nextChat.timestamp);
                              final nextSender = nextChat.sender!.uid;
                              final nextMinutes =
                                  nextChatDate.minute + nextChatDate.hour * 60;

                              if (minutes != nextMinutes || currentSender != nextSender) {
                                showTime = true;
                              }
                            }

                            return Container(
                              margin: EdgeInsets.all(8),
                              child: Align(
                                alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: (!isMe && showUserName) ? Image.network(
                                          message.sender!.imgUrl.isEmpty ?? true
                                            ? 'http://picsum.photos/100/100'
                                            : message.sender!.imgUrl, fit: BoxFit.cover,) : Container(),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: isMe
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          if (!isMe && showUserName) Text(message.sender!.nickName, style: AppTextStyle.body12R()),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: isMe
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                            children: [
                                              if (isMe && showTime) Text(formattedTime),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius: isMe
                                                    ? const BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      bottomLeft: Radius.circular(10),
                                                      bottomRight: Radius.circular(10),
                                                    )
                                                    : const BorderRadius.only(
                                                      topRight: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10),
                                                      bottomRight: Radius.circular(10),
                                                    ),
                                                  color: isMe ? PlatformColors.chatPrimaryLight : Colors.white,
                                                  border: Border.all(color: PlatformColors.subtitle7)
                                                ),
                                                child: Text(
                                                  message.text,
                                                  style: AppTextStyle.body13M(),
                                                  maxLines: null,
                                                ),
                                              ),
                                              if (!isMe && showTime) Text(formattedTime),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  ),
                  ),
                BottomAppBar(
                  color: Colors.blue,
                  elevation: 0,
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
                              _authController.userInfo.value!.uid,
                              controller.messageController.text,
                              roomId,
                              _authController.userInfo.value!.uid,
                            );
                          },
                          icon: Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            throw Exception();
          }
        },
      ),
    );
  }
}
