
class UserModel {
  String uid;     // uid
  String email;   // 이메일
  String nickName;  // 이름
  String imgUrl;   // 사진

  UserModel({
    required this.uid,
    required this.email,
    required this.nickName,
    required this.imgUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'email': this.email,
      'nickName': this.nickName,
      'imgUrl': this.imgUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      nickName: map['nickName'] as String,
      imgUrl: map['imgUrl'] as String,
    );
  }
}
