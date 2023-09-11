// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/login_controller.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/view/screens/sign_up_screen.dart';
import 'package:tripin/view/widget/custom_button.dart';
import 'package:tripin/view/widget/custom_formfield.dart';

import 'find_pw_screen.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  static const route = '/login';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final _formKey = GlobalKey<FormState>();
    final _authController = Get.find<AuthController>();

    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/character.png',
                  width: 200,
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '로그인',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Obx(
                  () => Column(
                    children: [
                      CustomFormField(
                        hintText: '이메일을 입력하세요',
                        hintStyle: TextStyle(color: PlatformColors.subtitle4),
                        isValid: controller.isValidEmail(controller.email),
                        validText: '이메일 주소',
                        invalidText: '이메일 형식을 확인해주세요.',
                        controller: controller.emailEditingController,
                        onChanged: (v) {
                          controller.email = v;
                        },
                        icon: controller.email.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  controller.email = '';
                                  controller.emailEditingController.clear();
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.close_rounded),
                                ),
                              )
                            : null,
                      ),
                      CustomFormField(
                        obscureText: true,
                        hintText: '비밀번호를 입력하세요',
                        hintStyle: TextStyle(color: PlatformColors.subtitle4),
                        controller: controller.pwEditingController,
                        isValid: controller.pw.length > 8,
                        validText: '비밀번호',
                        invalidText: '비밀번호는 8자 이상을 입력해주세요.',
                        onChanged: (v) => controller.pw = v,
                        icon: controller.pw.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  controller.pw = '';
                                  controller.pwEditingController.clear();
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.close_rounded),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.to(() => FindPwScreen());
                        },
                        child: Text(
                          '비밀번호 찾기',
                          style: TextStyle(
                            color: PlatformColors.subtitle4,
                          ),
                        ),
                      ),
                      Container(
                        color: PlatformColors.subtitle4,
                        width: 1,
                        height: 12,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => SignUpScreen());
                        },
                        child: Text('회원가입'),
                      ),
                    ],
                  ),
                ),
                Obx(() => CustomButton(
                      text: '이메일로 로그인',
                      backgroundColor: controller.email.isNotEmpty
                          ? PlatformColors.primary
                          : PlatformColors.subtitle4,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          controller.loginWithEmail();
                          return;
                        }
                        print('로그인 실패');
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 1,
                          color: PlatformColors.subtitle5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '또는',
                          style: TextStyle(
                            color: PlatformColors.subtitle5,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          height: 1,
                          color: PlatformColors.subtitle5,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _authController.signInWithGoogle();
                      },
                      child: Image.asset(
                        'assets/icons/google.png',
                        width: 56,
                        height: 56,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        _authController.loginWithKakao();
                      },
                      child: Image.asset(
                        'assets/icons/kakao.png',
                        width: 56,
                        height: 56,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
