import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/friend_controller.dart';
import 'package:tripin/utils/text_styles.dart';

import 'package:tripin/view/page/find_friend_page.dart';
import 'package:tripin/view/widget/app_friend_card.dart';

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
          ),
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
                    child: Text(
                      '지금, 소중한 사람들과 함께\n여행을 만들어보세요:)',
                      style: AppTextStyle.header18(color: Colors.white),
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
                    style: AppTextStyle.header15(color: Colors.white),
                    message: Get.find<AuthController>().userInfo.value?.message ??
                        '로딩중...',
                    color: PlatformColors.subtitle8,
                  ),
                )
                // SizedBox(
                //   height: MediaQuery.of(context).size.height / 9,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Row(
                //           children: [
                //             AspectRatio(
                //               aspectRatio: 1 / 1,
                //               child: FutureBuilder<String?>(
                //                 future: Get.find<AuthController>()
                //                     .getUserProfilePhotoUrl(),
                //                 builder: (context, snapshot) {
                //                   if (snapshot.hasError) {
                //                     return Text('오류 발생: ${snapshot.error}');
                //                   } else if (!snapshot.hasData ||
                //                       snapshot.data == null) {
                //                     return SizedBox();
                //                   } else {
                //                     return AspectRatio(
                //                       aspectRatio: 1 / 1,
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(8.0),
                //                         child: Container(
                //                           clipBehavior: Clip.antiAlias,
                //                           decoration: BoxDecoration(
                //                             borderRadius:
                //                                 BorderRadius.circular(20),
                //                             color: Colors.grey,
                //                           ),
                //                           child: Image.network(
                //                             Get.find<AuthController>()
                //                                     .userInfo
                //                                     .value
                //                                     ?.imgUrl ??
                //                                 '로딩중...',
                //                             fit: BoxFit.fill,
                //                           ),
                //                         ),
                //                       ),
                //                     );
                //                   }
                //                 },
                //               ),
                //             ),
                //             Obx(
                //               () => Padding(
                //                 padding: const EdgeInsets.only(left: 8),
                //                 child: Text(
                //                   Get.find<AuthController>()
                //                           .userInfo
                //                           .value
                //                           ?.nickName ??
                //                       '로딩중...',
                //                   style: AppTextStyle.header15(
                //                       color: Colors.white),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       Obx(
                //         () => Container(
                //           width: MediaQuery.of(context).size.width / 2.5,
                //           height: MediaQuery.of(context).size.height / 20,
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.vertical(
                //               top: Radius.circular(80),
                //               bottom: Radius.circular(80),
                //             ),
                //             border: Border.all(color: PlatformColors.subtitle8),
                //           ),
                //           child: Center(
                //             child: Text(Get.find<AuthController>()
                //                     .userInfo
                //                     .value
                //                     ?.message ??
                //                 '로딩중...'),
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: PlatformColors.subtitle8,
              height: MediaQuery.of(context).size.height - 347.675,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('친구'),
                    Obx(
                      () => Expanded(
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
                                          actions: <Widget>[
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
                                    // return await showDialog(
                                    //     context: context,
                                    //     builder: (BuildContext) {
                                    //       return AlertDialog(
                                    //         title: Text("경고"),
                                    //         content: Text("친구를 삭제하시겠습니까?"),
                                    //         actions: <Widget>[
                                    //           ElevatedButton(
                                    //               onPressed: () =>
                                    //                   Navigator.of(context).pop(true),
                                    //               child: Text("확인")),
                                    //           OutlinedButton(
                                    //             onPressed: () =>
                                    //                 Navigator.of(context).pop(false),
                                    //             child: Text("취소"),
                                    //           ),
                                    //         ],
                                    //       );
                                    //     });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.grey,
                                              ),
                                              child: controller
                                                              .followingList[
                                                                  index]
                                                              .imgUrl !=
                                                          null &&
                                                      controller
                                                          .followingList[index]
                                                          .imgUrl
                                                          .isNotEmpty
                                                  ? Container(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: Image.network(
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
                                                                .circular(12),
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
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(controller
                                              .followingList[index].nickName),
                                        ),
                                        // Container(
                                        //   width: MediaQuery.of(context)
                                        //           .size
                                        //           .width /
                                        //       3,
                                        //   height: MediaQuery.of(context)
                                        //           .size
                                        //           .height /
                                        //       30,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.vertical(
                                        //       top: Radius.circular(80),
                                        //       bottom: Radius.circular(80),
                                        //     ),
                                        //     border: Border.all(
                                        //         color: PlatformColors.subtitle),
                                        //   ),
                                        //   child: Center(
                                        //     child: Text( controller
                                        //                     .followingList[
                                        //                         index]
                                        //                     .message,),
                                        //   ),
                                        // ),
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
                                                color: PlatformColors.subtitle),
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
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () => Get.find<AuthController>().logOut(),
          //   child: Text('로그아웃'),
          // ),
          // SizedBox(height: 20),
          // // 선택한 텍스트를 표시하는 부분
        ]));
  }
}
