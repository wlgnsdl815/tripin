import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/utils/colors.dart';

import '../../controllers/login_controller.dart';
import '../../utils/text_styles.dart';

class FindPwScreen extends GetView<LoginController> {
  const FindPwScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlatformColors.subtitle7,
      appBar: AppBar(
        backgroundColor: PlatformColors.subtitle8,
        foregroundColor: Colors.black,
        title: Text('비밀번호 변경', style: AppTextStyle.header18()),
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
                  '비밀번호 재설정',
                  style: AppTextStyle.body13B(),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: PlatformColors.subtitle8,
                    helperText: '비밀번호 재설정 메일을 보냅니다.',
                    helperStyle:
                        AppTextStyle.body10R(color: PlatformColors.negative),
                    hintText: '이메일을 입력하세요',
                  ),
                  controller: controller.pwFindEmailController,
                  onChanged: (_) {
                    controller.activeButton();
                  },
                ),
              ],
            ),
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: PlatformColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: controller.isButtonActivated.value
                    ? () {
                        controller.passwordFind();
                      }
                    : null,
                child: Text(
                  '확인',
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
