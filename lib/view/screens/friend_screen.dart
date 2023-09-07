import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/friend_controller.dart';
import 'package:tripin/controllers/home_controller.dart';
import 'package:tripin/view/page/find_friend_page.dart';

class FriendScreen extends GetView<FriendController> {
  const FriendScreen({super.key});
  static const route = '/friend';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '친구',
          textAlign: TextAlign.left,
        ),
        // leading: Text('친구'),
        actions: [
          Icon(Icons.group_add_sharp),
          TextButton(
              onPressed: () {
                Get.toNamed(FindFriendPage.route);
              },
              child: Text(
                '친구 추가',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(37),
                                        color: Colors.grey,
                                      ),
                                      child: Image.network(snapshot.data!),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Text(
                        // Get.find<AuthController>().user!.displayName ?? '',
                        Get.find<HomeController>().userInfo.value!.nickName,

                        // controller.fr
                        //iendUser.value?.email ?? '사용자 이메일 없음'
                        // Get.find<AuthController>().user.email
                        // controller
                        //     .editProfileController.nickNameController.text,
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 18,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(80),
                            bottom: Radius.circular(80)),
                        border: Border.all(color: Colors.black)),
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
            ElevatedButton(
              onPressed: () => Get.find<AuthController>().logOut(),
              child: Text('로그아웃'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  color: Colors.lightBlue,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              controller.searchController.clear();
                              controller.clearSearchResults();
                            },
                            child: Icon(Icons.close),
                          ),
                          Text('친구 추가'),
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            TextField(
                              controller: controller.searchController,
                              onEditingComplete: () {
                                controller.searchFriendByEmail();
                              },
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        controller.searchFriendByEmail();
                                      },
                                      icon: Icon(Icons.search)),
                                  filled: true,
                                  hintText: '이메일로 친구 검색',
                                  contentPadding: EdgeInsets.all(10),
                                  border: InputBorder.none),
                            ),
                            const SizedBox(),
                            SizedBox(
                              width: double.infinity,
                              child: Obx(() {
                                final friendUser = controller.friendUser.value;
                                if (friendUser != null) {
                                  return Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                          controller.searchController.clear();
                                          controller.clearSearchResults();
                                        },
                                        child: Text(friendUser.email),
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Text('검색 결과가 없습니다.'),
                                      SizedBox(height: 16),
                                    ],
                                  );
                                }
                              }),
                            ), // SizedBox(
                            //   width: double.infinity,
                            //   child: Obx(() {
                            //     final searchState =
                            //         controller.searchState.value;
                            //     if (searchState == SearchState.Idle) {
                            //       // 검색을 시작하지 않은 초기화 상태일 때 빈 화면을 표시
                            //       return Container();
                            //     } else if (searchState == SearchState.SearchResult) {
                            //       // 검색 결과가 있는 상태
                            //       return SizedBox(
                            //         width: double.infinity,
                            //         child: Column(
                            //           children: [
                            //             ElevatedButton(
                            //               onPressed: () {
                            //                 // 버튼을 눌렀을 때 수행할 작업
                            //               },
                            //               child: Text(controller
                            //                   .friendUser.value!.email),
                            //             ),
                            //             SizedBox(height: 16),
                            //           ],
                            //         ),
                            //       );
                            //     } else if (searchState ==
                            //         SearchState.NoResult) {
                            //       // 검색 결과가 없는 상태
                            //       return Column(
                            //         children: [
                            //           Text('검색 결과가 없습니다.'),
                            //           SizedBox(height: 16),
                            //         ],
                            //       );
                            //     } else {
                            //       // 검색 중인 상태
                            //       return CircularProgressIndicator();
                            //     }
                            //   }),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
