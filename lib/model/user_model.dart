// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'chat_room_model.dart';

class UserModel {
  String uid; // uid
  String email; // 이메일
  String nickName; // 이름
  String imgUrl; // 사진
  String message; // 상태 메세지
  bool isSelected = false;
  List following;
  List? joinedTrip;

  UserModel({
    required this.uid,
    required this.email,
    required this.nickName,
    required this.imgUrl,
    required this.message,
    required this.isSelected,
    required this.following,
    this.joinedTrip,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'nickName': nickName,
      'imgUrl': imgUrl,
      'message': message,
      'isSelected': isSelected,
      'following': following,
      'joinedTrip': joinedTrip ?? [],
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      nickName: map['nickName'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      message: map['message'] ?? '',
      isSelected: map['isSelected'] ?? false, 
      following: map['following'] ?? [],
      joinedTrip: map['joinedTrip'] ?? [],
    );
  }
}