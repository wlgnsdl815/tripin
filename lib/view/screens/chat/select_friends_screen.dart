import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/chat_list_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/utils/app_screens.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/widget/custom_appbar_icon.dart';
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
        leading: CustomAppBarIcon(
          padding: EdgeInsets.only(left: 25),
          image: Image.asset(
            'assets/icons/cancel.png',
            width: 12.w,
            height: 12.h,
          ),
          onTap: () {
            Get.back();
          },
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
                        child: controller.userInfo.value!.imgUrl != ''
                            ? Image.asset(
                                'assets/icons/chat_default.png',
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                controller.userInfo.value!.imgUrl,
                                fit: BoxFit.cover,
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
                                print(controller.participants);
                              }
                            },
                            icon: Icon(
                              Icons.check_circle,
                              color: isSelected
                                  ? PlatformColors.primary
                                  : PlatformColors.subtitle6,
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
