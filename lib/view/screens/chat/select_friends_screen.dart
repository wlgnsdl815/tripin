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
import 'package:tripin/view/widget/list_profile_container.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() {
              double targetHeight =
                  controller.participants.isNotEmpty ? 80.h : 0.0;
              controller.containerHeight.value = targetHeight;
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: controller.containerHeight.value,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        child: Row(
                          children: [
                            Text(
                              '선택 ',
                              style: AppTextStyle.body16M(
                                  color: PlatformColors.subtitle),
                            ),
                            Text(
                              '${controller.participants.length}',
                              style: AppTextStyle.body16M(
                                  color: PlatformColors.primary),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        child: Container(
                          height: 47.0.h,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 16.w),
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.participants.length,
                            itemBuilder: (context, index) {
                              return ListProfileContainer(
                                user: controller.participants[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 20.h),
            CustomTextFiledWithOutForm(
              borderSideColor: Colors.transparent,
              controller: controller.searchFriendController,
              prefixIcon: Icon(
                Icons.search,
                color: PlatformColors.primary,
              ),
              hintText: '친구 이름 또는 이메일 검색',
              onChanged: (value) {
                controller.searchFriend();
              },
            ),
            SizedBox(height: 20.h),
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
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        controller.userData[index].nickName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: ListProfileContainer(
                          user: controller.userData[index]),
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
