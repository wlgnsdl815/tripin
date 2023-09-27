import 'package:flutter/material.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';

class CustomCheckList extends StatelessWidget {
  final String itemName;
  final bool isChecked;
  final Function(bool?) onChanged;

  const CustomCheckList({
    required this.itemName,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              onChanged(!isChecked);
            },
            child: Container(
              width: 20.0, 
              height: 20.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked ? PlatformColors.primary : Colors.transparent,
                border: Border.all(
                  color: isChecked ? PlatformColors.primary: PlatformColors.subtitle4,
                  width: 2.0,
                ),
              ),
              child: isChecked
                  ? null
                  : Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 8.0, // 아이콘의 크기 설정
                    ),
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              itemName,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                decoration: isChecked ? TextDecoration.lineThrough : null,
                color: isChecked ? Colors.grey : Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
