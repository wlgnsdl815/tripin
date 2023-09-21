import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/view/screens/chat/chat_list_screen.dart';
import 'package:tripin/view/screens/friend_screen.dart';
import 'package:tripin/view/screens/my_page_screen.dart';

import '../model/chat_room_model.dart';
import '../service/db_service.dart';
import '../view/screens/calendar_screen.dart';

class HomeController extends GetxController {
  var pageController = PageController();
  RxInt curPage = 0.obs;

  List<Widget> screens = [
    FriendScreen(),
    ChatListScreen(),
    CalendarScreen(),
    MyPageScreen(),
  ];

  onPageTapped(int v) {
    curPage(v);
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
    curPage(0);
  }
}
