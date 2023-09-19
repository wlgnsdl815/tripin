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
