// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:tripin/utils/colors.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    this.hintText,
    this.hintStyle,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final bool obscureText;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? Function(String?)? validator;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: PlatformColors.subtitle4),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: PlatformColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: PlatformColors.negative),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: PlatformColors.negative),
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: widget.hintText,
        hintStyle:
            widget.hintStyle ?? TextStyle(color: PlatformColors.subtitle4),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      controller: widget.controller,
    );
  }
}
