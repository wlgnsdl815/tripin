import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/view/screens/calendar_screen.dart';
import 'package:tripin/view/screens/chat/chat_list_screen.dart';
import 'package:tripin/view/screens/chat/select_friends_screen.dart';
import 'package:tripin/view/screens/friend_screen.dart';

import '../../controllers/home_controller.dart';
import 'edit_profile_screen.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  static const route = '/home';

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    print('Home: ${authController.userInfo}');
    return Scaffold(
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: controller.screens.length,
        itemBuilder: (context, index) {
          return Obx(() => controller.screens[controller.curPage.value]);
        }
      ),
      bottomNavigationBar: Obx(
        () => Container(
          height: 66,
          color: PlatformColors.subtitle8,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: BottomNavigationBar(
            backgroundColor: PlatformColors.subtitle8,
            currentIndex: controller.curPage.value,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            onTap: (value) {
              controller.onPageTapped(value);
            },
            items: [
              BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Image.asset('assets/icons/tab_friends.png', width: 20),
                    SizedBox(height: 5),
                  ],
                ),
                activeIcon: Column(
                  children: [
                    Image.asset('assets/icons/tab_selected_friends.png', width: 20),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Image.asset('assets/icons/tab_chat_list.png', width: 20),
                    SizedBox(height: 5),
                  ],
                ),
                activeIcon: Column(
                  children: [
                    Image.asset('assets/icons/tab_selected_chat_list.png', width: 20),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Image.asset('assets/icons/tab_calendar.png', width: 20),
                    SizedBox(height: 5),
                  ],
                ),
                activeIcon: Column(
                  children: [
                    Image.asset('assets/icons/tab_selected_calendar.png', width: 20),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Image.asset('assets/icons/tab_my_page.png', width: 20),
                    SizedBox(height: 5),
                  ],
                ),
                activeIcon: Column(
                  children: [
                    Image.asset('assets/icons/tab_selected_my_page.png', width: 20),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}