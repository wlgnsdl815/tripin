import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/friend_controller.dart';
import 'package:tripin/utils/text_styles.dart';

import 'package:tripin/view/page/find_friend_page.dart';
import 'package:tripin/view/screens/profile_detail_screen.dart';
import 'package:tripin/view/widget/app_friend_card.dart';

import '../../utils/colors.dart';

class FriendScreen extends GetView<FriendController> {
  const FriendScreen({super.key});
  static const route = '/friend';

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();
    print(_authController.userInfo.value?.following);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            '',
            textAlign: TextAlign.left,
            style: AppTextStyle.header18(),
          ),
        ),
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/friend_background.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 84, 16, 16),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '지금, 소중한 사람들과 함께\n여행을 만들어보세요:)',
                          style: AppTextStyle.header18(color: Colors.white),
                        ),
                        // Icon(Icons.search, color: PlatformColors.subtitle8,size: 32,)
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => AppFriend(
                    future: Get.find<AuthController>().getUserProfilePhotoUrl(),
                    image: Image.network(
                      Get.find<AuthController>().userInfo.value?.imgUrl ??
                          '로딩중...',
                      fit: BoxFit.fill,
                    ),
                    nickName:
                        Get.find<AuthController>().userInfo.value?.nickName ??
                            '로딩중...',
                    style: AppTextStyle.header20(color: Colors.white),
                    message:
                        Get.find<AuthController>().userInfo.value?.message ??
                            '로딩중...',
                    color: PlatformColors.subtitle8,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: PlatformColors.subtitle8,
              height: MediaQuery.of(context).size.height - 347.675,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 18,
                    decoration: BoxDecoration(color: PlatformColors.subtitle7),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '친구',
                                style: AppTextStyle.body16B(
                                    color: PlatformColors.subtitle2),
                                textAlign: TextAlign.left,
                              ),
                              Obx(() => Text(
                                  controller.followingList.length.toString(),
                                  style: AppTextStyle.body16B(
                                      color: PlatformColors.subtitle2))),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.person_add_alt_outlined,
                                color: PlatformColors.primary,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.toNamed(
                                      FindFriendPage.route,
                                    );
                                  },
                                  child: Text(
                                    '친구 추가',
                                    style: AppTextStyle.body14B(
                                        color: PlatformColors.primary),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: controller.followingList.length,
                              itemBuilder: (context, index) {
                                final friendList =
                                    controller.followingList[index];
                                return Dismissible(
                                  key: Key(friendList.uid),
                                  background: Container(
                                    color: Colors.red, // 스와이프할 때 배경색 설정
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    controller.deleteFriend(friendList);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text("친구가 삭제되었습니다."),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () => Get.back(),
                                                child: Text("확인")),
                                          ],
                                        );

                                        // return Column(
                                        //   mainAxisSize: MainAxisSize.min,
                                        //   children: [
                                        //     ListTile(
                                        //       title: Text('친구가 삭제되었습니다.'),
                                        //     ),
                                        //   ],
                                        // );
                                      },
                                    );
                                  },
                                  confirmDismiss:
                                      (DismissDirection direction) async {
                                    return await showCupertinoDialog(
                                        context: context,
                                        builder: (BuildContext) {
                                          return Theme(
                                            data: ThemeData.dark(),
                                            child: CupertinoAlertDialog(
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child: Text(
                                                  '친구를 삭제하시겠습니까?',
                                                  style: AppTextStyle.button16B(
                                                      color: PlatformColors
                                                          .subtitle8),
                                                ),
                                              ),
                                              actions: [
                                                CupertinoDialogAction(
                                                  child: Text('취소',
                                                      style: AppTextStyle.body16M(
                                                          color: PlatformColors
                                                              .subtitle8)),
                                                  // isDefaultAction: true,
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                ),
                                                CupertinoDialogAction(
                                                  child: Text(
                                                    '확인',
                                                    style: AppTextStyle.body16M(
                                                        color: PlatformColors
                                                            .primary),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 40, 8),
                                    child: GestureDetector(
                                      onTap: (){
                                        Get.to(ProfileDetailScreen(userModel: controller.followingList[index]), arguments: [controller
                                            .followingList[
                                        index]]);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    15,
                                                child: AspectRatio(
                                                  aspectRatio: 1 / 1,
                                                  child: Container(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                        color: Colors.transparent,
                                                      ),
                                                      child: controller
                                                                      .followingList[
                                                                          index]
                                                                      .imgUrl !=
                                                                  null &&
                                                              controller
                                                                  .followingList[
                                                                      index]
                                                                  .imgUrl
                                                                  .isNotEmpty
                                                          ? Container(
                                                              clipBehavior:
                                                                  Clip.antiAlias,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              child:
                                                                  Image.network(
                                                                controller
                                                                    .followingList[
                                                                        index]
                                                                    .imgUrl,
                                                                fit: BoxFit.fill,
                                                              ))
                                                          : Container(
                                                              clipBehavior:
                                                                  Clip.antiAlias,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Image(
                                                                image: AssetImage(
                                                                  'assets/images/profile_image.png',
                                                                ),
                                                                fit: BoxFit.fill,
                                                              ))),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                  controller.followingList[index]
                                                      .nickName,
                                                  style: AppTextStyle.body16R(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3, // 최대 너비 설정
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(80),
                                                bottom: Radius.circular(80),
                                              ),
                                              border: Border.all(
                                                  color: PlatformColors.primary),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  controller.followingList[index]
                                                      .message,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
