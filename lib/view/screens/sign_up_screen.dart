import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:tripin/utils/colors.dart';
import 'package:tripin/view/widget/custom_formfield.dart';

import '../../controllers/login_controller.dart';
import '../../utils/text_styles.dart';

class SignUpScreen extends GetView<LoginController> {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(controller.isNicknameValid.value);
    return Scaffold(
      backgroundColor: PlatformColors.subtitle7,
      appBar: AppBar(
        backgroundColor: PlatformColors.subtitle8,
        foregroundColor: Colors.black,
        title: Text(
          '회원가입',
          style: AppTextStyle.header18(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '닉네임',
                  style: AppTextStyle.body13B(),
                ),
                SizedBox(height: 7.h),
                Obx(
                  () => CustomFormField(
                    borderSide: BorderSide.none,
                    controller: controller.nickNameController,
                    hintText: '닉네임을 입력하세요',
                    hintStyle: AppTextStyle.body12M(color: Color(0xff777777)),
                    fillColor: Colors.white,
                    filled: true,
                    isValid: controller.isNicknameValid.value,
                    invalidText: '특수문자와 공백은 포함될 수 없습니다.',
                    validText: '사용가능한 닉네임입니다.',
                    borderRadius: BorderRadius.circular(10),
                    onChanged: (text) {
                      controller.isNicknameValid.value =
                          controller.validateNickname(text);
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  '이메일',
                  style: AppTextStyle.body13B(),
                ),
                SizedBox(height: 7.h),
                Obx(
                  () => CustomFormField(
                    borderSide: BorderSide.none,
                    controller: controller.emailEditingController,
                    hintText: '이메일을 입력하세요',
                    hintStyle: AppTextStyle.body12M(color: Color(0xff777777)),
                    fillColor: Colors.white,
                    filled: true,
                    isValid: controller.isEmailValid.value,
                    invalidText: '이메일 형식이 맞지 않습니다.',
                    validText: '사용가능한 이메일입니다.',
                    borderRadius: BorderRadius.circular(10),
                    onChanged: (text) {
                      controller.isEmailValid.value =
                          controller.validateEmail(text);
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  '비밀번호',
                  style: AppTextStyle.body13B(),
                ),
                SizedBox(height: 7.h),
                Obx(
                  () => CustomFormField(
                    icon: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          controller.obscurePw1.value =
                              !controller.obscurePw1.value;
                        },
                        child: Image.asset(
                          'assets/icons/lock.png',
                          width: 13.w,
                          height: 16.w,
                          color: controller.obscurePw1.value
                              ? Color(0xff777777)
                              : PlatformColors.primary,
                        ),
                      ),
                    ),
                    obscureText: controller.obscurePw1.value,
                    borderSide: BorderSide.none,
                    controller: controller.pwEditingController,
                    hintText: '비밀번호를 입력하세요',
                    hintStyle: AppTextStyle.body12M(color: Color(0xff777777)),
                    fillColor: Colors.white,
                    filled: true,
                    isValid: controller.isPasswordValid.value,
                    invalidText: '8자리 이상 20자리 이하의 영문 숫자 혼합이어야 합니다.',
                    validText: '사용가능한 비밀번호입니다.',
                    borderRadius: BorderRadius.circular(10),
                    onChanged: (text) {
                      controller.isPasswordValid.value =
                          controller.validatePassword(text);
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  '비밀번호 확인',
                  style: AppTextStyle.body13B(),
                ),
                SizedBox(height: 7.h),
                Obx(
                  () => CustomFormField(
                    icon: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          controller.obscurePw2.value =
                              !controller.obscurePw2.value;
                        },
                        child: Image.asset(
                          'assets/icons/lock.png',
                          width: 13.w,
                          height: 16.w,
                          color: controller.obscurePw2.value
                              ? Color(0xff777777)
                              : PlatformColors.primary,
                        ),
                      ),
                    ),
                    obscureText: controller.obscurePw2.value,
                    borderSide: BorderSide.none,
                    controller: controller.pw2EditingController,
                    hintText: '비밀번호를 한번 더 입력하세요',
                    hintStyle: AppTextStyle.body12M(color: Color(0xff777777)),
                    fillColor: Colors.white,
                    filled: true,
                    isValid: controller.isPasswordConfirmValid.value,
                    invalidText: '입력한 비밀번호가 일치하지 않습니다.',
                    validText: '비밀번호가 일치합니다.',
                    borderRadius: BorderRadius.circular(10),
                    onChanged: (text) {
                      controller.isPasswordConfirmValid.value =
                          text == controller.pwEditingController.text;
                    },
                  ),
                ),
              ],
            ),
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: controller.allValidationsPassed.value
                      ? PlatformColors.primary
                      : Colors.grey, // 비활성화 시 회색으로 표시
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                onPressed: controller.allValidationsPassed.value
                    ? () {
                        controller.signUp();
                      }
                    : null, // allValidationsPassed가 false일 때 null로 설정하여 버튼 비활성화
                child: Text(
                  '완료',
                  style: AppTextStyle.body16B(color: PlatformColors.subtitle8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
