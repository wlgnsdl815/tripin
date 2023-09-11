// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:tripin/model/user_model.dart';

// class Friend {
//    String? imgUrl;
//   UserModel nickName;
//   String email;
//   String status;
  
//   Friend({
//     this.imgUrl,
//     required this.nickName,
//     required this.email,
//     required this.status,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'imgUrl': imgUrl,
//       'nickName': nickName.toMap(),
//       'email': email,
//       'status': status,
//     };
//   }

// factory Friend.fromJson(Map<String, dynamic> source) {

//   return Friend(
//     imgUrl: source['imgUrl'] as String,
//     nickName: UserModel.fromMap(source['nickName'] as Map<String, dynamic>),
//     email: source['email'] as String,
//     status: source['status'] as String,
//   );
// }

//   String toJson() => json.encode(toMap());

// }
