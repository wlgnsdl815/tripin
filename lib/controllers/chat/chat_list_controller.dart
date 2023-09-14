import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/model/user_model.dart';

class ChatListController extends GetxController {
  RxString roomId = ''.obs;
  RxList<ChatRoom> chatList = <ChatRoom>[].obs;

  StreamSubscription? chatRoomsStreamSubscription; // 추가된 부분: 스트림 구독 객체

  setRoomId(String id) {
    roomId.value = id;
    print('setRoomId: ${roomId.value}');
  }

  getChatList() {
    final firestoreInstance = FirebaseFirestore.instance;
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    // 스트림 구독 시작
    chatRoomsStreamSubscription = firestoreInstance
        .collection('chatRooms')
        .where('participants', arrayContains: currentUserUid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .listen((querySnapshot) async {
      // 콜백 시작
      Set<String> allParticipantUids = {};

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
        ChatRoom chatRoom = ChatRoom.fromMap(chatData.data(), participants);
        tempChatRoomList.add(chatRoom);
      }

      chatList.assignAll(tempChatRoomList); // 변경된 부분: addAll 대신 assignAll 사용
    }); // 콜백 종료
  }

  @override
  void onInit() {
    super.onInit();
    getChatList();
  }

  @override
  void onClose() {
    chatRoomsStreamSubscription?.cancel();
    super.onClose();
  }
}
