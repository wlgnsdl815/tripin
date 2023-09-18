// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomAppBarIcon extends StatelessWidget {
  final Image? image;
  final Text? text;
  final EdgeInsets padding;
  final Alignment? alignment;
  final Function() onTap;

  const CustomAppBarIcon({
    Key? key,
    this.image,
    this.text,
    required this.padding,
    this.alignment,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Align(
        alignment: alignment ?? Alignment.center,
        child: InkWell(
          onTap: onTap,
          child: image ?? text,
        ),
      ),
    );
  }
}
