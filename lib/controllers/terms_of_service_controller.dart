import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TermsOfServiceController extends GetxController {
  PageController pageController = PageController();
  RxInt currentPage = 0.obs;

  Future<String> loadTermsAsset(int index) async {
    String filePath;
    if (index == 0) {
      filePath = 'assets/docs/terms_of_service.md';
    } else {
      filePath = 'assets/docs/location_based_service_term.md';
    }
    return await rootBundle.loadString(filePath);
  }

  Future<String> loadPrivacyPolicy() async {
    String filePath = 'assets/docs/privacy_policy.md';
    return await rootBundle.loadString(filePath);
  }
}
