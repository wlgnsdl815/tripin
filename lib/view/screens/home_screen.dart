import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const route = '/home';

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _authController.logOut();
          },
          child: Text('로그아웃'),
        ),
      ),
    );
  }
}
