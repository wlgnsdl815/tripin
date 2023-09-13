import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/model/user_model.dart';

class ChatListController extends GetxController {
  RxString roomId = ''.obs;
  RxList<ChatRoom> chatList = <ChatRoom>[].obs; // 모든 채팅방 리스트

  setRoomId(String id) {
    roomId.value = id;
    print('setRoomId: ${roomId.value}');
  }

  getChatList() async {
    final firestoreInstance = FirebaseFirestore.instance;
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    // 현재 사용자가 참여한 채팅방을 가져옴
    final querySnapshot = await firestoreInstance
        .collection('chatRooms')
        .where('participants', arrayContains: currentUserUid)
        .orderBy('updatedAt', descending: true)
        .get();

    Set<String> allParticipantUids = {}; // 모든 참가자 uid를 저장할 집합

    // 각 채팅방에서 모든 참가자의 uid를 수집
    for (var chatData in querySnapshot.docs) {
      List<String> participantUidList =
          List<String>.from(chatData['participants']);
      allParticipantUids.addAll(participantUidList);
    }

    // 한번의 쿼리로 모든 참가자의 정보를 가져옴, 반복 쿼리를 피해 성능을 향상
    final allParticipantsSnapshots = await firestoreInstance
        .collection('users')
        .where(FieldPath.documentId, whereIn: allParticipantUids.toList())
        .get();

    // 참가자의 정보를 map에 저장하여 쉽게 액세스
    Map<String, UserModel> allParticipantsMap = {};
    for (var doc in allParticipantsSnapshots.docs) {
      UserModel user = UserModel.fromMap(doc.data());
      allParticipantsMap[doc.id] = user;
    }

    List<ChatRoom> tempChatRoomList = [];

    // 채팅방의 정보를 구축
    // 참가자의 정보는 이미 가져온 map에서 가져옴
    for (var chatData in querySnapshot.docs) {
      List<UserModel> participants = [];
      List<String> participantUidList =
          List<String>.from(chatData['participants']);
      for (var participantUid in participantUidList) {
        if (allParticipantsMap[participantUid] != null) {
          participants.add(allParticipantsMap[participantUid]!);
        }
      }
      ChatRoom chatRoom = ChatRoom.fromMap(
          chatData.data() as Map<String, dynamic>, participants);
      tempChatRoomList.add(chatRoom);
    }

    // 최종적으로 구축된 채팅방 목록을 chatList에 추가
    chatList.addAll(tempChatRoomList);
    log('$chatList', name: 'getChatList :: chatList');
  }

  @override
  void onInit() async {
    super.onInit();
    await getChatList();
  }
}
