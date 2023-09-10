
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class AppTextStyle {
  static const semiBold = TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w600);
  static const medium = TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w500);
  static const regular = TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w400);
  static const light = TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w300);

  // header
  static TextStyle header24({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 24.sp, color: color);
  static TextStyle header20({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 20.sp, color: color);
  static TextStyle header18({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 18.sp, color: color);
  static TextStyle header15({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 15.sp, color: color);

  // body
  static TextStyle body18B({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 18.sp, color: color);
  static TextStyle body18M({Color color = PlatformColors.title}) => medium.copyWith(fontSize: 18.sp, color: color);
  static TextStyle body18R({Color color = PlatformColors.title}) => regular.copyWith(fontSize: 18.sp, color: color);

  static TextStyle body17B({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 17.sp, color: color);
  static TextStyle body17M({Color color = PlatformColors.title}) => medium.copyWith(fontSize: 17.sp, color: color);
  static TextStyle body17R({Color color = PlatformColors.title}) => regular.copyWith(fontSize: 17.sp, color: color);

  static TextStyle body16B({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 16.sp, color: color);
  static TextStyle body16M({Color color = PlatformColors.title}) => medium.copyWith(fontSize: 16.sp, color: color);
  static TextStyle body16R({Color color = PlatformColors.title}) => regular.copyWith(fontSize: 16.sp, color: color);

  static TextStyle body15B({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 15.sp, color: color);
  static TextStyle body15M({Color color = PlatformColors.title}) => medium.copyWith(fontSize: 15.sp, color: color);
  static TextStyle body15R({Color color = PlatformColors.title}) => regular.copyWith(fontSize: 15.sp, color: color);

  static TextStyle body14B({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 14.sp, color: color);
  static TextStyle body14M({Color color = PlatformColors.title}) => medium.copyWith(fontSize: 14.sp, color: color);
  static TextStyle body14R({Color color = PlatformColors.title}) => regular.copyWith(fontSize: 14.sp, color: color);

  static TextStyle body13B({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 13.sp, color: color);
  static TextStyle body13M({Color color = PlatformColors.title}) => medium.copyWith(fontSize: 13.sp, color: color);
  static TextStyle body13R({Color color = PlatformColors.title}) => regular.copyWith(fontSize: 13.sp, color: color);

  static TextStyle body12B({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 12.sp, color: color);
  static TextStyle body12M({Color color = PlatformColors.title}) => medium.copyWith(fontSize: 12.sp, color: color);
  static TextStyle body12R({Color color = PlatformColors.title}) => regular.copyWith(fontSize: 12.sp, color: color);

  static TextStyle body11B({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 11.sp, color: color);
  static TextStyle body11M({Color color = PlatformColors.title}) => medium.copyWith(fontSize: 11.sp, color: color);
  static TextStyle body11R({Color color = PlatformColors.title}) => regular.copyWith(fontSize: 11.sp, color: color);

  static TextStyle body10B({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 10.sp, color: color);
  static TextStyle body10M({Color color = PlatformColors.title}) => medium.copyWith(fontSize: 10.sp, color: color);
  static TextStyle body10R({Color color = PlatformColors.title}) => regular.copyWith(fontSize: 10.sp, color: color);

  // button
  static TextStyle button16B({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 16.sp, color: color);
  static TextStyle button16R({Color color = PlatformColors.title}) => regular.copyWith(fontSize: 16.sp, color: color);

  static TextStyle button13B({Color color = PlatformColors.title}) => semiBold.copyWith(fontSize: 13.sp, color: color);
  static TextStyle button13R({Color color = PlatformColors.title}) => regular.copyWith(fontSize: 13.sp, color: color);
}
