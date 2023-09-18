import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/widget/custom_appbar_icon.dart';
import 'package:tripin/view/widget/custom_button.dart';
import 'package:tripin/view/widget/custom_textfield_without_form.dart';

class ChatSettingScreen extends StatelessWidget {
  const ChatSettingScreen({super.key});

  static const route = '/chatSetting';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: PlatformColors.title,
        leading: CustomAppBarIcon(
          image: Image.asset(
            'assets/icons/cancel.png',
            width: 12.w,
            height: 12.h,
          ),
          padding: EdgeInsets.only(left: 25),
          onTap: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text('채팅방 설정'),
        actions: [
          CustomAppBarIcon(
            text: Text(
              '완료',
              style: AppTextStyle.body16M(),
            ),
            padding: EdgeInsets.only(right: 24.w),
            onTap: () {
              Get.back();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56.h,
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 110.w,
                height: 110.h,
                decoration: BoxDecoration(
                  color: PlatformColors.primary,
                  borderRadius: BorderRadius.circular(16.7.r),
                ),
              ),
              Positioned(
                bottom: -7.h,
                right: -5.w,
                child: GestureDetector(
                  onTap: () {},
                  child: Image.asset('assets/icons/circle_camera.png'),
                ),
                width: 34.w,
                height: 34.h,
              ),
            ],
          ),
          SizedBox(height: 32.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '채팅방 이름',
                  style: AppTextStyle.body13M(),
                ),
                SizedBox(
                  height: 7.h,
                ),
                CustomTextFiledWithOutForm(
                  hintText: '채팅방 이름',
                ),
                SizedBox(height: 335.h),
                CustomButton(
                  backgroundColor: Colors.white,
                  onTap: () {},
                  text: '채팅방 나가기',
                  textStyle: AppTextStyle.body16M(color: Colors.red),
                  borderColor: PlatformColors.subtitle6,
                  textPadding: EdgeInsets.all(15),
                  borderRadius: BorderRadius.circular(53.r),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
