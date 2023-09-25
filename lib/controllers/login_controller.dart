import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/view/screens/my_page_screen.dart';

class LoginController extends GetxController {
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController pwEditingController = TextEditingController();
  final TextEditingController pw2EditingController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController pwFindEmailController = TextEditingController();
  final RxString _email = ''.obs;
  final RxString _pw = ''.obs;
  final RxBool isButtonActivated = false.obs;
  final RxBool isNicknameValid = false.obs;
  final RxBool isEmailValid = false.obs;
  final RxBool isPasswordValid = false.obs;
  final RxBool isPasswordConfirmValid = false.obs;

  final AuthController _authController = AuthController();
  String get email => _email.value;
  String get pw => _pw.value;
  set email(String value) => _email(value);
  set pw(String value) => _pw(value);

  RxBool get allValidationsPassed => (isNicknameValid.value &&
          isEmailValid.value &&
          isPasswordValid.value &&
          isPasswordConfirmValid.value)
      .obs;

  // bool isValidEmail(String? email) {
  //   final RegExp regex =
  //       RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  //   return regex.hasMatch(email!);
  // }

  bool validateNickname(String value) {
    final pattern = RegExp(r'^[a-zA-Z0-9\uAC00-\uD7A3]+$'); // 영문, 숫자, 한글만 허용
    return pattern.hasMatch(value);
  }

  bool validateEmail(String value) {
    final pattern =
        RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return pattern.hasMatch(value);
  }

  bool validatePassword(String value) {
    final pattern = RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9]).{8,20}$');
    return pattern.hasMatch(value);
  }

  loginWithEmail() {
    _authController.loginWithEmail(
      emailEditingController.text,
      pwEditingController.text,
    );
    print(emailEditingController.text);
    print(pwEditingController.text);
  }

  signUp() {
    if (pwEditingController.text == pw2EditingController.text) {
      _authController.signUp(
        emailEditingController.text,
        pwEditingController.text,
        nickNameController.text,
      );
      return;
    }
    print('회원가입 실패. 두 개의 비밀번호 다름');
  }

  // 비밀번호 찾기
  Future<void> passwordFind() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: pwFindEmailController.text);

      showDialog(
        context: Get.context!,
        builder: (context) {
          return Theme(
            data: ThemeData.dark(),
            child: CupertinoAlertDialog(
              content: Text(
                '메일이 전송되었습니다.\n메일함을 확인해주세요.',
                style: TextStyle(color: PlatformColors.subtitle5),
              ),
              title: Text('메일 전송 완료'),
              actions: [
                TextButton(
                  onPressed: () {
                    // 페이지로 이동
                    Get.back();
                    Get.back();
                  },
                  child: Text('확인'),
                ),
              ],
            ),
          );
        },
      );
      pwFindEmailController.clear();
      isButtonActivated.value = false;
    } catch (e) {
      print('Firebase Authentication 오류: $e');
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          Get.snackbar('오류', '이메일을 찾을 수 없습니다.');
        }
      }
    }
  }

  activeButton() {
    if (pwFindEmailController.text.isNotEmpty) {
      isButtonActivated.value = true;
    } else {
      isButtonActivated.value = false;
    }
  }

  logOut() {
    _authController.logOut();
  }
}
