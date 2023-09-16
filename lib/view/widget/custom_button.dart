import 'package:flutter/material.dart';
import 'package:tripin/utils/colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.backgroundColor,
    this.textStyle,
    this.borderRadius,
    this.textPadding,
    this.textMargin,
    this.borderColor,
  }) : super(key: key);

  final VoidCallback onTap;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final String text;
  final BorderRadius? borderRadius;
  final EdgeInsets? textPadding;
  final EdgeInsets? textMargin;
  final Color? borderColor;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: 16,
        ),
        backgroundColor: widget.backgroundColor ?? PlatformColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
          side: BorderSide(color: widget.borderColor ?? Colors.transparent),
        ),
      ),
      onPressed: widget.onTap,
      child: Container(
        padding: widget.textPadding ?? EdgeInsets.zero,
        margin: widget.textMargin ?? EdgeInsets.zero,
        child: Text(
          widget.text,
          style: widget.textStyle ??
              TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
