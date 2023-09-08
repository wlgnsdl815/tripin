
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class DBService {
  final String? uid;

  DBService({this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final userRef = FirebaseFirestore.instance.collection('user')
    .withConverter(
      fromFirestore: (snapshot, _) => UserModel.fromMap(snapshot.data()!),
      toFirestore: (user, _) => user.toMap());

  // uid로 유저 정보 가져오기
  Future getUserInfoById(String uid) async {
    try {
      DocumentSnapshot<UserModel> res = await userRef.doc(uid).get();
      if (res.exists) {
        return res.data();
      } else {
        return null;
      }
    } catch (e) {
      log('null', name: 'db_service :: getUserInfoById');
      return null;
    }
  }

  Future saveUserInfo(UserModel user) async {
    DocumentSnapshot userDocSnapshot = await userRef.doc(user.uid).get();

    if (userDocSnapshot.exists) {
      // 문서가 이미 존재하면 업데이트
      await userRef.doc(user.uid).update({
        'nickName': user.nickName,
        'imgUrl': user.imgUrl,
        'message': user.message,
      });
    } else {
      // 문서가 존재하지 않으면 생성
      await userRef.doc(user.uid).set(user);
    }
  }

  getUserInfo(String uid) {}
}
