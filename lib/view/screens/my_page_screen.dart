import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/friend_controller.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/screens/find_pw_screen.dart';
import 'package:tripin/view/screens/privacy_policy.dart';
import 'package:tripin/view/screens/terms_of_service_screen.dart';
import 'package:tripin/view/widget/app_my_list.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});
  static const route = '/myPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          '마이페이지',
          style: AppTextStyle.header15(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 18,
            decoration: BoxDecoration(color: PlatformColors.primary),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '앱 설정',
                style: AppTextStyle.body12B(color: PlatformColors.subtitle8),
              ),
            ),
          ),
          MyList(
            onPressed: () => Get.to(() => FindPwScreen()),
            text: '비밀번호 변경',
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 18,
            decoration: BoxDecoration(color: PlatformColors.primary),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '정보',
                style: AppTextStyle.body12B(color: PlatformColors.subtitle8),
              ),
            ),
          ),
          MyList(
              onPressed: () {
                Get.to(() => TermsOfServiceScreen());
              },
              text: '이용약관'),
          Divider(
            indent: 12.w,
            endIndent: 12.w,
            height: 1,
            thickness: 1,
            color: Color(0xffD9D9D9),
          ),
          MyList(
              onPressed: () {
                Get.to(() => PrivacyPolicyScreen());
              },
              text: '개인정보 처리방침'),
          Divider(
            indent: 12.w,
            endIndent: 12.w,
            height: 1,
            thickness: 1,
            color: Color(0xffD9D9D9),
          ),
          MyList(onPressed: () {}, text: '버전'),
          Divider(
            indent: 12.w,
            endIndent: 12.w,
            height: 1,
            thickness: 1,
            color: Color(0xffD9D9D9),
          ),
          MyList(
              onPressed: () {
                Get.find<AuthController>().logOut();
              },
              text: '로그아웃'),
        ],
      ),
    );
  }
}
