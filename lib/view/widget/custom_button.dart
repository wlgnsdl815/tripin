import 'package:flutter/material.dart';
import 'package:tripin/utils/colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.backgrondColor,
    this.textStyle,
  }) : super(key: key);

  final VoidCallback onTap;
  final Color? backgrondColor;
  final TextStyle? textStyle;
  final String text;

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
        backgroundColor: PlatformColors.primary,
      ),
      onPressed: widget.onTap,
      child: Text(
        widget.text,
        style: widget.textStyle ??
            TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
