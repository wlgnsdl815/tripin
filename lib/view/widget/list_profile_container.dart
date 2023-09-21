import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/utils/colors.dart';

class ListProfileContainer extends StatelessWidget {
  final int index;
  const ListProfileContainer({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final SelectFriendsController selectFriendsController =
        Get.find<SelectFriendsController>();
    return Container(
      clipBehavior: Clip.antiAlias,
      width: 47,
      height: 47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        color: PlatformColors.primary,
      ),
      child: selectFriendsController.userData[index].imgUrl == ''
          ? Image.asset(
              'assets/icons/chat_default.png',
              fit: BoxFit.cover,
            )
          : Image.network(
              selectFriendsController.userData[index].imgUrl,
              fit: BoxFit.cover,
            ),
    );
  }
}
