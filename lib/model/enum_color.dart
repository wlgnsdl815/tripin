import 'dart:math';

import 'dart:math';

enum RandomColor {
  purple('purple'),
  yellowGreen('yellowGreen'),
  blue('blue'),
  orange('orange'),
  red('red'),
  green('green'),
  yellow('yellow'),
  seaBule('seaBule'),
  pink('pink');

  final String engColor;

  const RandomColor(this.engColor);

  // 랜덤으로 색 추출
  static String getRandomColor() {
    List<RandomColor> colorList = RandomColor.values;
    int number = Random().nextInt(colorList.length);
    RandomColor randomColor = colorList[number];
    return randomColor.engColor;
  }
}
