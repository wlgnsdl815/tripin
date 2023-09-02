// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/login_controller.dart';
import 'package:tripin/view/screens/sign_up_screen.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  static const route = '/login';

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _authController = Get.find<AuthController>();
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (!controller.isValidEmail(value)) {
                    return '이메일 형식을 확인해주세요';
                  }
                  return null;
                },
                controller: controller.emailEditingController,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.length < 8) {
                    return '비밀번호는 8자리 이상 입력해주세요';
                  }
                  return null;
                },
                controller: controller.pwEditingController,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.loginWithEmail();
                    print('로그인 성공');
                    return;
                  }
                  print('로그인 실패');
                },
                child: Text('이메일로 로그인'),
              ),
              ElevatedButton(
                onPressed: () {
                  _authController.signInWithGoogle();
                },
                child: Text('구글 아이디로 로그인'),
              ),
              ElevatedButton(
                onPressed: () {
                  _authController.loginWithKakao();
                },
                child: Text('카카오 아이디로 로그인'),
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
      ),
    );
  }
}
