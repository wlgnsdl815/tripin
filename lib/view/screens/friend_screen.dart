import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/friend_controller.dart';
import 'package:tripin/utils/text_styles.dart';

import 'package:tripin/view/page/find_friend_page.dart';

import '../../utils/colors.dart';
import '../widget/friend_tile.dart';

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
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
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
                  () => Padding(
                    padding: const EdgeInsets.all(18),
                    child: FriendTile(
                        friend: Get.find<AuthController>().userInfo.value!),
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
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: controller.followingList.length,
                            itemBuilder: (context, index) {
                              final friend = controller.followingList[index];
                              return FriendTile(friend: friend);
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 18),
                          ),
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
