import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripin/model/chat_room_model.dart';

import '../model/user_model.dart';

class DBService {
  final String? uid;

  DBService({this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final userRef = FirebaseFirestore.instance.collection('users').withConverter(
      fromFirestore: (snapshot, _) => UserModel.fromMap(snapshot.data()!),
      toFirestore: (user, _) => user.toMap());

  final roomRef = FirebaseFirestore.instance
      .collection('chatRooms')
      .withConverter(
          fromFirestore: (snapshot, _) => ChatRoom.fromMap(snapshot.data()!),
          toFirestore: (room, _) => room.toMap());

  // uid로 유저 정보 가져오기
  Future getUserInfoById(String uid) async {
    try {
      DocumentSnapshot<UserModel> res = await userRef.doc(uid).get();
      return res.data();
    } catch (e) {
      log('$e', name: 'db_service :: getUserInfoById');
      return null;
    }
  }

  // 유저 정보 저장
  Future<void> saveUserInfo(UserModel user) async {
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

  // 채팅방 생성 시 초대된 유저들의 joinedTrip 리스트에 roomId 추가
  Future<void> saveJoinedRoomId(
      String roomId, List<String> participantsUidList) async {
    if (participantsUidList.isNotEmpty) {
      for (var uid in participantsUidList) {
        DocumentSnapshot userDocSnapshot = await userRef.doc(uid).get();

        if (userDocSnapshot.exists) {
          await userRef.doc(uid).update({
            'joinedTrip': FieldValue.arrayUnion([roomId])
          });
        }
      }
    }
  }

  // roomId로 채팅방 정보 가져오기
  Future getRoomInfoById(String roomId) async {
    try {
      DocumentSnapshot<ChatRoom> res = await roomRef.doc(roomId).get();
      return res.data();
    } catch (e) {
      log('$e', name: 'db_service :: getRoomInfoById');
      return null;
    }
  }
}
