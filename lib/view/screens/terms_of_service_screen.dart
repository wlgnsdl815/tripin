import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/terms_of_service_controller.dart';
import 'package:tripin/utils/colors.dart';

class TermsOfServiceScreen extends GetView<TermsOfServiceController> {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String> loadAsset(int index) async {
      String filePath;
      if (index == 0) {
        filePath = 'assets/docs/terms_of_service.md';
      } else {
        filePath = 'assets/docs/location_based_service_term.md';
      }
      return await rootBundle.loadString(filePath);
    }

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
      body: PageView.builder(
        controller: controller.pageController,
        itemCount: 2,
        itemBuilder: (context, index) {
          return FutureBuilder<String>(
            future: loadAsset(index),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Markdown(data: snapshot.data!);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }
}
