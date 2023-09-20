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
          separatorBuilder: (context, index) => Divider(
            color: PlatformColors.subtitle7,
          ),
          itemCount: controller.chatList.length,
          itemBuilder: (context, index) {
            String formattedTime = _dateFormatting(index);

            print(controller.chatList.length);
            return InkWell(
              onTap: () {
                _globalGetXController
                    .setRoomId(controller.chatList[index].roomId);
                controller.setRoomId(controller.chatList[index].roomId);
                _globalGetXController
                    .setRoomTitle(controller.chatList[index].roomTitle);

                Get.toNamed(AppScreens.chat);
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 66.w,
                        height: 66.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: PlatformColors.primary),
                      ),
                      SizedBox(width: 13.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 160.w,
                                  ),
                                  child: Text(
                                    '${controller.chatList[index].roomTitle}',
                                    style: AppTextStyle.body15M(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Image.asset(
                                  'assets/icons/person.png',
                                  width: 9.w,
                                  height: 9.h,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                    '${controller.chatList[index].participants!.length}'),
                                Spacer(),
                                Text(
                                  '${formattedTime}',
                                  style: AppTextStyle.body12M(
                                    color: PlatformColors.subtitle5,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('날짜들어갈 공간'),
                              ],
                            ),
                            Text(
                              '${controller.chatList[index].lastMessage}',
                              style: AppTextStyle.body13R(
                                color: PlatformColors.subtitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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

  String _dateFormatting(int index) {
    DateTime now = DateTime.now();
    DateTime todayMidnight = DateTime(now.year, now.month, now.day);
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        controller.chatList[index].updatedAt);
    String formattedTime;

    if (dateTime.isBefore(todayMidnight)) {
      // 하루 이상 지났으면 날짜형식
      formattedTime = DateFormat('M월 d일').format(dateTime);
    } else {
      // 하루 내이므로 시간 형식
      formattedTime = DateFormat('HH:mm').format(dateTime);
    }
    return formattedTime;
  }
}
