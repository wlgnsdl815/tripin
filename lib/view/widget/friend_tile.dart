import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';

import '../../controllers/friend_controller.dart';
import '../../model/user_model.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../screens/profile_detail_screen.dart';

class FriendTile extends StatelessWidget {
  const FriendTile({Key? key, required this.friend}) : super(key: key);

  final UserModel friend;

  @override
  Widget build(BuildContext context) {
    FriendController controller = Get.find<FriendController>();
    return Dismissible(
      key: Key(friend.uid),
      background: Container(
        color: Colors.red, // 스와이프할 때 배경색 설정
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      onDismissed: (direction) {
        controller.deleteFriend(friend);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("친구가 삭제되었습니다."),
              actions: [
                ElevatedButton(onPressed: () => Get.back(), child: Text("확인")),
              ],
            );
          },
        );
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showCupertinoDialog(
            context: context,
            builder: (BuildContext) {
              return Theme(
                data: ThemeData.dark(),
                child: CupertinoAlertDialog(
                  content: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      '친구를 삭제하시겠습니까?',
                      style: AppTextStyle.button16B(
                          color: PlatformColors.subtitle8),
                    ),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('취소',
                          style: AppTextStyle.body16M(
                              color: PlatformColors.subtitle8)),
                      // isDefaultAction: true,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    CupertinoDialogAction(
                      child: Text(
                        '확인',
                        style:
                            AppTextStyle.body16M(color: PlatformColors.primary),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                    )
                  ],
                ),
              );
            });
      },
      child: GestureDetector(
        onTap: () {
          Get.to(
            ProfileDetailScreen(userModel: friend),
            arguments: [friend]);
        },
        child: Obx(
          ()=> Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 15,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.transparent,
                          ),
                          child: friend.imgUrl.isNotEmpty
                              ? Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Image.network(
                                    friend.imgUrl,
                                    fit: BoxFit.fill,
                                  ))
                              : Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Image(
                                    image: AssetImage(
                                      'assets/icons/chat_default.png',
                                    ),
                                    fit: BoxFit.fill,
                                  ))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      friend.nickName,
                      style: AppTextStyle.body16R(
                        color: friend.uid == Get.find<AuthController>().userInfo.value!.uid
                          ? Colors.white : PlatformColors.title
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: friend.message.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(80),
                        bottom: Radius.circular(80),
                      ),
                      border: Border.all(
                        color: PlatformColors.primary,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          friend.message,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ), //   Container(),
            ],
          ),
        ),
      ),
    );
  }
}
