import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';
import '../service/db_service.dart';

class HomeController extends GetxController {
  Rxn<UserModel> userInfo = Rxn(); // 로그인한 유저 정보
  final firestoreInstance = FirebaseFirestore.instance;

  // 유저 정보 가져오기
  Future getUserInfo() async {
    print('유저 uid가져 옵니다: ${FirebaseAuth.instance.currentUser!.uid}');
    await Future.delayed(Duration(seconds: 1));
    UserModel res = await DBService()
        .getUserInfoById(FirebaseAuth.instance.currentUser!.uid);
    userInfo(res);
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserInfo()
        .then((value) => log(userInfo.value!.nickName, name: 'user'));
  }
}
