import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';

class FriendController extends GetxController{
  Rx<User> get user => Get.find<AuthController>().user!.obs;
  TextEditingController textEditingController = TextEditingController();

  searchFriend(){
    
  }
}