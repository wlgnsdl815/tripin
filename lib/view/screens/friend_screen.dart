import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/friend_controller.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';

import 'package:tripin/view/page/find_friend_page.dart';

class FriendScreen extends GetView<FriendController> {
  const FriendScreen({super.key});
  static const route = '/friend';

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();
    print(_authController.userInfo.value!.following);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '',
          textAlign: TextAlign.left,
        ),
        // leading: Text('친구'),
        actions: [
          Icon(Icons.group_add_sharp),
          TextButton(
              onPressed: () {
                Get.toNamed(
                  FindFriendPage.route,
                );
              },
              child: Text(
                '친구 추가',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/friend_background.png'), fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16,84,16,16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SizedBox(
                  child: Text('지금, 소중한 사람들과 함께\n여행을 만들어보세요:)', style: AppTextStyle.header18(color: Colors.white),),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder<String?>(
                              future: Get.find<AuthController>()
                                  .getUserProfilePhotoUrl(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('오류 발생: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return SizedBox();
                                } else {
                                  return AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey,
                                        ),
                                        child: Image.network(
                                          Get.find<AuthController>()
                                                  .userInfo
                                                  .value
                                                  ?.imgUrl ??
                                              '로딩중...',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            Get.find<AuthController>()
                                    .userInfo
                                    .value
                                    ?.nickName ??
                                '로딩중...', style: AppTextStyle.header15(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 18,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(80),
                                bottom: Radius.circular(80)),
                            border: Border.all(color: Colors.black)),
                        child: Center(
                          child: Text(Get.find<AuthController>()
                                  .userInfo
                                  .value
                                  ?.message ??
                              '로딩중...'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              Text('친구'),

              Obx(
                () => Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                      itemCount: controller.followingList.length,
                      itemBuilder: (context, index) {
                        final friendList = controller.followingList[index];
                        return Dismissible(
                          key: Key(friendList.uid),
                          background: Container(
                            color: Colors.red, // 스와이프할 때 배경색 설정
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // ElevatedButton(onPressed: () {}, child: Text('삭제')),
                          onDismissed: (direction) {
                            controller.deleteFriend(friendList);
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: Text('친구가 삭제되었습니다.'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: ListTile(
                            leading: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey,
                                  ),
                                  child: controller.followingList[index]
                                                  .imgUrl !=
                                              null &&
                                          controller.followingList[index].imgUrl
                                              .isNotEmpty
                                      ? Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Image.network(
                                            controller
                                                .followingList[index].imgUrl,
                                            fit: BoxFit.fill,
                                          ))
                                      : Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.grey,
                                          ),
                                        ),

                                  // controller.followingList[index].imgUrl != null &&
                                  //         friend.imgUrl.isNotEmpty
                                  //     ? Image.network(friend.imgUrl)
                                  //     : Container(
                                  //         clipBehavior: Clip.antiAlias,
                                  //         decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.circular(12),
                                  //           color: Colors.grey,
                                  //         ),
                                  //       ),
                                ),
                              ),
                            ),
                            title:
                                Text(controller.followingList[index].nickName),
                          ),
                        );
                      }),
                ),
              ),

              ElevatedButton(
                onPressed: () => Get.find<AuthController>().logOut(),
                child: Text('로그아웃'),
              ),
              SizedBox(height: 20),
              // 선택한 텍스트를 표시하는 부분
            ],
          ),
        ),
      ),
    );
  }
}
