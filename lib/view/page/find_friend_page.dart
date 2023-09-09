import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/friend_controller.dart';
import 'package:tripin/view/screens/friend_screen.dart';

class FindFriendPage extends GetView<FriendController> {
  const FindFriendPage({super.key});
  static const route = '/findFriend';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 추가', style: TextStyle(color: Colors.black)),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('추가할 친구의 이메일 주소를\n입력해주세요.'),
              SizedBox(
                height: 20,
              ),
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
                    hintText: '이메일을 입력해주세요.(@포함)',
                    // contentPadding: EdgeInsets.all(20),
                    border: InputBorder.none),
              ),
              const SizedBox(),
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final friendUser = controller.friendUser.value;
                  if (friendUser != null) {
                    return Row(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 10,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  friendUser.imgUrl,
                                  fit: BoxFit.fill,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            controller.addFriend(friendUser);
                            // Get.toNamed(FriendScreen.route,
                            //     );
                            controller.searchController.clear();
                            controller.clearSearchResults();
                          },
                          child: Text(
                            friendUser.email,
                            style: TextStyle(color: Colors.black),
                          ),
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
            ],
          ),
        ),
      ),
    );
  }
}
