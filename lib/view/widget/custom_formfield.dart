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
    // this.validator,
    this.onChanged,
    this.icon,
    this.isValid,
    this.validText = '',
    this.invalidText = '',
  }) : super(key: key);

  final TextEditingController controller;
  final bool obscureText;
  final String? hintText;
  final TextStyle? hintStyle;
  // final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Widget? icon;
  final bool? isValid;
  final String? validText;
  final String? invalidText;
  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: PlatformColors.subtitle5),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: widget.controller.text.isEmpty
                      ? PlatformColors.primary
                      : widget.isValid == true
                          ? PlatformColors.primary
                          : PlatformColors.negative),
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: widget.hintText,
            hintStyle:
                widget.hintStyle ?? TextStyle(color: PlatformColors.subtitle4),
            suffixIconConstraints: BoxConstraints(maxHeight: 30),
            suffixIcon: widget.icon,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          onChanged: widget.onChanged,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 4, bottom: 8),
          child: Text(
            widget.controller.text.isEmpty
                ? widget.validText!
                : widget.isValid == true
                    ? widget.validText!
                    : widget.invalidText!,
            style: TextStyle(
              color: widget.controller.text.isEmpty
                  ? PlatformColors.primary
                  : widget.isValid == true
                      ? PlatformColors.primary
                      : PlatformColors.negative,
            ),
          ),
        ),
      ],
    );
  }
}
