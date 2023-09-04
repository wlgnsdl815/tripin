// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:tripin/model/user_model.dart';

class Friend {
  UserModel imgUrl;
  UserModel nickName;
  String status;
  
  Friend({
    required this.imgUrl,
    required this.nickName,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imgUrl': imgUrl.toMap(),
      'nickName': nickName.toMap(),
      'status': status,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      imgUrl: UserModel.fromMap(map['imgUrl'] as Map<String,dynamic>),
      nickName: UserModel.fromMap(map['nickName'] as Map<String,dynamic>),
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Friend.fromJson(String source) => Friend.fromMap(json.decode(source) as Map<String, dynamic>);
}
