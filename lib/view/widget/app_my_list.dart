import 'package:flutter/material.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';

class MyList extends StatelessWidget {
  const MyList({super.key, required this.text, this.onPressed});
  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return           Padding(
      padding: const EdgeInsets.only(left: 16),
      child: TextButton(
        onPressed: onPressed,
        child: Text(text, style: AppTextStyle.body16M(color: PlatformColors.subtitle),)),
    )
;
  }
}