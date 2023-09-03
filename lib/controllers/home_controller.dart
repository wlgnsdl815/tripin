
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';
import '../service/db_service.dart';

class HomeController extends GetxController {
  Rxn<UserModel> userInfo = Rxn();    // 로그인한 유저 정보
  
  // 유저 정보 가져오기
  Future getUserInfo() async {
    UserModel res = await DBService().getUserInfoById(FirebaseAuth.instance.currentUser!.uid);
    userInfo(res);
  }
  
  @override
  void onInit() async {
    super.onInit();
    await getUserInfo().then((value) => log(userInfo.value!.nickName, name: 'user'));
  }
}
