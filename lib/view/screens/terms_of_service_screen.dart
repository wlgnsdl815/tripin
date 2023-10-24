import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/terms_of_service_controller.dart';
import 'package:tripin/utils/colors.dart';

class TermsOfServiceScreen extends GetView<TermsOfServiceController> {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: PlatformColors.title,
        elevation: 0.0,
        title: Text('이용약관'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Image.asset(
            'assets/icons/cancel.png',
            width: 12.w,
            height: 12.h,
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: GestureDetector(
                      onTap: () {
                        controller.pageController.animateToPage(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        controller.currentPage.value = 0;
                      },
                      child: Text('서비스 이용약관'),
                    ),
                  ),
                  Obx(
                    () => Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width / 2,
                      color: controller.currentPage.value == 0
                          ? PlatformColors.title
                          : Color(0xffE8E8E8),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: GestureDetector(
                      onTap: () {
                        controller.pageController.animateToPage(
                          1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        controller.currentPage.value = 1;
                      },
                      child: Text('위치기반 서비스 이용약관'),
                    ),
                  ),
                  Obx(
                    () => Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width / 2,
                      color: controller.currentPage.value == 1
                          ? PlatformColors.title
                          : Color(0xffE8E8E8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: 2,
              itemBuilder: (context, index) {
                return FutureBuilder<String>(
                  future: controller.loadTermsAsset(index),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Markdown(data: snapshot.data!);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
