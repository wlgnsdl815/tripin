// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/login_controller.dart';

class SignUpScreen extends GetView<LoginController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

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
                  if (!controller.validateEmail(value!)) {
                    return '이메일 형식을 확인해주세요';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: '이메일',
                ),
                controller: controller.emailEditingController,
              ),
              SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.length < 8) {
                    return '비밀번호는 8자리 이상 입력해주세요';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: '비밀번호',
                ),
                controller: controller.pwEditingController,
              ),
              SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: '비밀번호 확인',
                ),
                controller: controller.pw2EditingController,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: '닉네임',
                ),
                controller: controller.nickNameController,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.signUp();
                    print('회원가입 성공');
                    return;
                  }
                  Get.snackbar('회원가입 실패', '이메일과 패스워드를 확인해주세요');
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
