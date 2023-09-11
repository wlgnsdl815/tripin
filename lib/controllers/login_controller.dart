import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';

class LoginController extends GetxController {
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController pwEditingController = TextEditingController();
  final TextEditingController pw2EditingController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final RxString _email = ''.obs;
  final RxString _pw = ''.obs;

  final AuthController _authController = AuthController();
  String get email => _email.value;
  String get pw => _pw.value;
  set email(String value) => _email(value);
  set pw(String value) => _pw(value);

  bool isValidEmail(String? email) {
    final RegExp regex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email!);
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

  logOut() {
    _authController.logOut();
  }
}
