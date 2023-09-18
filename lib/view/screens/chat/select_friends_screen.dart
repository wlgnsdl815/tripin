import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/chat_list_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/utils/app_screens.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/screens/chat/chat_screen.dart';
import 'package:tripin/view/widget/custom_textfield_without_form.dart';

class SelectFriendsScreen extends GetView<SelectFriendsController> {
  const SelectFriendsScreen({super.key});

  static const route = '/selectFriends';

  @override
  Widget build(BuildContext context) {
    final _chatListController = Get.find<ChatListController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          // 아이콘 나중에 수정하기
          icon: Icon(
            Icons.close,
            color: PlatformColors.title,
          ),
        ),
        title: Text(
          '친구 선택',
          style: AppTextStyle.body16M(),
        ),
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.participants.isEmpty
                  ? null
                  : () async {
                      String roomId = await controller.createChatRoom();
                      _chatListController.setRoomId(roomId);
                      Get.offAndToNamed(AppScreens.chat);
                    },
              child: Obx(
                () => Text(
                  '완료',
                  style: AppTextStyle.body16M(
                    color: controller.participants.isEmpty
                        ? PlatformColors.subtitle6
                        : PlatformColors.title,
                  ),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextFiledWithOutForm(
              prefixIcon: Icon(Icons.search),
              hintText: '친구 이름 또는 이메일 검색',
            ),
            SizedBox(height: 20),
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
                      leading: Container(
                        width: 47,
                        height: 47,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          color: PlatformColors.primary,
                        ),
                      ),
                      trailing: Obx(
                        () {
                          bool isSelected = controller.participants.any(
                              (user) =>
                                  user.uid == controller.userData[index].uid);

                          return IconButton(
                            onPressed: () {
                              if (isSelected) {
                                controller.participants
                                    .remove(controller.userData[index]);
                              } else {
                                controller.participants
                                    .add(controller.userData[index]);
                                print(controller.participants.value);
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
          ],
        ),
      ),
    );
  }
}
