// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String uid; // uid
  String email; // 이메일
  String nickName; // 이름
  String imgUrl; // 사진
  String message; // 상태 메세지
  bool isSelected = false;

  UserModel({
    required this.uid,
    required this.email,
    required this.nickName,
    required this.imgUrl,
    required this.message,
    required this.isSelected,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'nickName': nickName,
      'imgUrl': imgUrl,
      'message': message,
      'isSelected': isSelected,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
