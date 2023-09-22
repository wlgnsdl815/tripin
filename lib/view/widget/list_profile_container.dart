import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/utils/colors.dart';

class ListProfileContainer extends StatelessWidget {
  final UserModel user;

  const ListProfileContainer({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: 47,
      height: 47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        color: PlatformColors.primary,
      ),
      child: user.imgUrl == ''
          ? Image.asset(
              'assets/icons/chat_default.png',
              fit: BoxFit.cover,
            )
          : Image.network(
              user.imgUrl,
              fit: BoxFit.cover,
            ),
    );
  }
}
