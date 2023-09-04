import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class DBService {
  final String? uid;

  DBService({this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final userInfoRef = FirebaseFirestore.instance
      .collection('user')
      .withConverter(
          fromFirestore: (snapshot, _) => UserModel.fromMap(snapshot.data()!),
          toFirestore: (user, _) => user.toMap());

  // uid로 유저 정보 가져오기
  Future getUserInfoById(String uid) async {
    try {
      DocumentSnapshot<UserModel> res = await userInfoRef.doc(uid).get();
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
}
