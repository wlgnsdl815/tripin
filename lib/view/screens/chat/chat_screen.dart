import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/chat/chat_controller.dart';
import 'package:tripin/controllers/global_getx_controller.dart';
import 'package:tripin/controllers/map/map_screen_controller.dart';
import 'package:tripin/model/chat_message_model.dart';
import 'package:tripin/utils/app_screens.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/screens/chat/chat_setting_screen.dart';
import 'package:tripin/view/widget/custom_appbar_icon.dart';

class ChatScreen extends GetView<ChatController> {
  static const route = '/chat';

  const ChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.find<AuthController>();
    final GlobalGetXController _globalGetXController =
        Get.find<GlobalGetXController>();
    final scrollController = controller.createScrollController();
    final MapScreenController _mapScreenController =
        Get.find<MapScreenController>();

    print(
        '_globalGetXController in ChatScreen roomId: ${_globalGetXController.roomId}');

    return Scaffold(
      backgroundColor: PlatformColors.subtitle8,
      appBar: AppBar(
        leading: CustomAppBarIcon(
          padding: EdgeInsets.only(left: 0),
          image: Image.asset(
            'assets/icons/back.png',
            width: 7.w,
            height: 14.h,
          ),
          onTap: () {
            Get.back();
          },
        ),
        title: Obx(
          () => Text(_globalGetXController.roomTitle.value),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: PlatformColors.title,
        actions: [
          CustomAppBarIcon(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            image: Image.asset(
              'assets/icons/setting.png',
              width: 18.w,
              height: 18.w,
            ),
            onTap: () {
              Get.toNamed(ChatSettingScreen.route);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ChatMessage>>(
        stream: controller.getMessage(_globalGetXController.roomId.value),
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

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            }
            controller.messageList.value = snapshot.data!;
          });
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Obx(() => ListView.separated(
                          controller: scrollController,
                          itemCount: controller.messageList.length + 1,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 7),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Container(
                                height: 60,
                              );
                            } else {
                              int newIndex = index - 1;
                              // 메세지들을 하나씩 담아주고
                              final message = controller.messageList[newIndex];
                              // 그 메세지의 발신자가 현재 로그인한 유저의 이름과 같은지 검사

                              final isMe = message.sender!.uid ==
                                  _authController.userInfo.value!.uid;
                              // database에 있는 timestamp를 변환
                              DateTime dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      message.timestamp);
                              String formattedTime =
                                  DateFormat('HH:mm').format(dateTime);
                              final currentChatDate = dateTime;
                              final currentSender = message.sender!.uid;
                              final minutes = currentChatDate.minute +
                                  currentChatDate.hour * 60;

                              bool cutMinutes = (newIndex == 0 ||
                                  minutes !=
                                      DateTime.fromMillisecondsSinceEpoch(
                                                  controller
                                                      .messageList[newIndex - 1]
                                                      .timestamp)
                                              .minute +
                                          DateTime.fromMillisecondsSinceEpoch(
                                                      controller
                                                          .messageList[
                                                              newIndex - 1]
                                                          .timestamp)
                                                  .hour *
                                              60);

                              bool showUserName = (newIndex == 0 ||
                                  currentSender !=
                                      controller.messageList[newIndex - 1]
                                          .sender!.uid ||
                                  cutMinutes);
                              bool showTime = false;

                              if (newIndex ==
                                  controller.messageList.length - 1) {
                                showTime = true;
                              } else {
                                final nextChat =
                                    controller.messageList[newIndex + 1];
                                final nextChatDate =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        nextChat.timestamp);
                                final nextSender = nextChat.sender!.uid;
                                final nextMinutes = nextChatDate.minute +
                                    nextChatDate.hour * 60;

                                if (minutes != nextMinutes ||
                                    currentSender != nextSender) {
                                  showTime = true;
                                }
                              }
                              return Container(
                                child: Align(
                                  alignment: isMe
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 0, 8, 0),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: (!isMe && showUserName)
                                              ? message.sender!.imgUrl.isEmpty
                                                  ? Image.asset(
                                                      'assets/icons/chat_default.png',
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      message.sender!.imgUrl,
                                                      fit: BoxFit.cover,
                                                    )
                                              : Container(),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: isMe
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            if (!isMe && showUserName)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Text(
                                                  message.sender!.nickName,
                                                  style: AppTextStyle.body12R(),
                                                ),
                                              ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment: isMe
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              children: [
                                                if (isMe && showTime)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6),
                                                    child: Text(
                                                      formattedTime,
                                                      style:
                                                          AppTextStyle.body12M(
                                                        color: PlatformColors
                                                            .subtitle4,
                                                      ),
                                                    ),
                                                  ),
                                                GestureDetector(
                                                  onTap: message.isMap
                                                      ? () {
                                                          Get.toNamed(
                                                            AppScreens.map,
                                                            arguments: {
                                                              'position':
                                                                  message
                                                                      .position,
                                                              'dateIndex':
                                                                  message
                                                                      .dateIndex,
                                                            },
                                                          );
                                                        }
                                                      : null,
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 11,
                                                            vertical: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: isMe
                                                          ? const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            )
                                                          : const BorderRadius
                                                              .only(
                                                              topRight: Radius
                                                                  .circular(
                                                                10,
                                                              ),
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                      color: message.isMap
                                                          ? PlatformColors
                                                              .primary
                                                          : isMe
                                                              ? PlatformColors
                                                                  .chatPrimaryLight
                                                              : Colors.white,
                                                      border: Border.all(
                                                        color: PlatformColors
                                                            .subtitle7,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      message.text,
                                                      softWrap: true,
                                                      style: AppTextStyle.body13M(
                                                          color: message.isMap
                                                              ? Colors.white
                                                              : PlatformColors
                                                                  .title),
                                                      maxLines: null,
                                                    ),
                                                  ),
                                                ),
                                                if (!isMe && showTime)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6),
                                                    child: Text(
                                                      formattedTime,
                                                      style: AppTextStyle.body12M(
                                                          color: PlatformColors
                                                              .subtitle4),
                                                    ),
                                                  ),
                                                if (isMe) SizedBox(width: 12),
                                              ],
                                            ),
                                            if (!isMe && showTime)
                                              SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(AppScreens.map);
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: PlatformColors.chatPrimaryLight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1, color: PlatformColors.strokeColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/map.png',
                                  width: 15, height: 15),
                              SizedBox(width: 8),
                              Obx(
                                () => Text(
                                  _mapScreenController.dateRange.isEmpty
                                      ? '여행 일정과 장소를 선택해주세요'
                                      : '일정 ${DateFormat('y.MM.dd').format(_mapScreenController.dateRange.first)} ~ ${DateFormat('MM.dd').format(_mapScreenController.dateRange.last)} l 장소 ${_globalGetXController.selectedCity}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.body13B(
                                      color: PlatformColors.primary),
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.navigate_next,
                                color: PlatformColors.primary,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(
                            width: 1, color: PlatformColors.subtitle7))),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: PlatformColors.subtitle8,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () {
                                    bool isButtonEnabled =
                                        controller.chatMessage.value != '';
                                    return TextField(
                                      onSubmitted: isButtonEnabled
                                          ? (text) {
                                              controller.sendMessage(
                                                _authController
                                                    .userInfo.value!.uid,
                                                controller
                                                    .messageController.text,
                                                _globalGetXController
                                                    .roomId.value,
                                                _authController
                                                    .userInfo.value!.uid,
                                                false,
                                                null,
                                                null,
                                              );

                                              controller.messageController
                                                  .clear();
                                              controller.chatMessage.value = '';
                                            }
                                          : null,
                                      controller: controller.messageController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '메세지 입력...',
                                        hintStyle: AppTextStyle.body14R(
                                            color: PlatformColors.subtitle2),
                                      ),
                                      onChanged: (value) {
                                        controller.chatMessage.value = value;
                                      },
                                    );
                                  },
                                ),
                              ),
                              Obx(
                                () {
                                  bool isButtonEnabled =
                                      controller.chatMessage.value != '';

                                  return IconButton(
                                    onPressed: isButtonEnabled
                                        ? () {
                                            controller.sendMessage(
                                              _authController
                                                  .userInfo.value!.uid,
                                              controller.messageController.text,
                                              _globalGetXController
                                                  .roomId.value,
                                              _authController
                                                  .userInfo.value!.uid,
                                              false,
                                              null,
                                              null,
                                            );

                                            controller.messageController
                                                .clear();
                                            controller.chatMessage.value = '';
                                          }
                                        : null,
                                    icon: Image.asset(
                                      'assets/icons/send_message.png',
                                      width: 20,
                                      height: 20,
                                      color: isButtonEnabled
                                          ? PlatformColors.primary
                                          : Color(0xffBFBFBF),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
