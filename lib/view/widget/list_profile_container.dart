import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';

class ListProfileContainer extends StatelessWidget {
  final UserModel user;
  final String? nickName;

  const ListProfileContainer({
    Key? key,
    required this.user,
    this.nickName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          width: 47.w,
          height: 47.h,
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
        ),
        if (nickName != null)
          Text(
            nickName!,
            style: AppTextStyle.body12M(color: PlatformColors.subtitle),
          ),
      ],
    );
  }
}
