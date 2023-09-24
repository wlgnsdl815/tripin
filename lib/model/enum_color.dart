import 'dart:math';

import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/colors.dart';

enum CalendarColors {
  purple('purple', CalendarColor.purple),
  yellowGreen('yellowGreen', CalendarColor.yellowGreen),
  blue('blue', CalendarColor.blue),
  orange('orange', CalendarColor.orange),
  red('red', CalendarColor.red),
  green('green', CalendarColor.green),
  yellow('yellow', CalendarColor.yellow),
  seaBule('seaBule', CalendarColor.seaBule),
  pink('pink', CalendarColor.pink);

  final String engColor;
  final Color color;

  const CalendarColors(this.engColor, this.color);

  // 랜덤으로 색 추출
  static String getRandomColor() {
    List<CalendarColors> colorList = CalendarColors.values;
    int number = Random().nextInt(colorList.length);
    CalendarColors randomColor = colorList[number];
    return randomColor.engColor;
  }

  // string 문자열 받아서 Color 반환
  static Color getColorByString(String stringColor) {
    final colorType = CalendarColors.values.firstWhere(
      (color) => color.engColor == stringColor,
      orElse: () => CalendarColors.purple
    );
    return colorType.color;
  }

  
}
