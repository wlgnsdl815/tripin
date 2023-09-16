import 'package:flutter/material.dart';
import 'package:tripin/utils/colors.dart';

class CustomTextFiledWithOutForm extends StatelessWidget {
  final TextEditingController? controller;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final bool? filled;
  final Color? borderSideColor;
  final BorderRadius? borderRadius;
  final Widget? prefixIcon;

  const CustomTextFiledWithOutForm({
    Key? key,
    this.controller,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.fillColor,
    this.filled,
    this.borderSideColor,
    this.borderRadius,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines ?? 1,
      controller: controller,
      decoration: InputDecoration(
        fillColor: fillColor ?? PlatformColors.subtitle8,
        filled: filled ?? true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: borderSideColor ?? PlatformColors.subtitle7,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: borderSideColor ?? PlatformColors.subtitle7,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        hintText: hintText ?? "메모를 입력해보세요!",
        hintStyle: hintStyle ?? TextStyle(color: PlatformColors.subtitle4),
        prefixIcon: prefixIcon,
        suffixIconConstraints: BoxConstraints(maxHeight: 30),
      ),
    );
  }
}
