import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';
import '../../utils/text_styles.dart';

class FindPwScreen extends GetView<LoginController> {
  const FindPwScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 찾기', style: AppTextStyle.header18()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: '이메일',
            ),
            controller: controller.pwFindEmailController,
          ),
          ElevatedButton(
            onPressed: controller.passwordFind,
            child: Text('찾기'),
          ),
        ],
      ),
    );
  }
}
