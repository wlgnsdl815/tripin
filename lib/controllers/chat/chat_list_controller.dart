import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/global_getx_controller.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/model/user_model.dart';

import '../../service/db_service.dart';
import '../auth_controller.dart';

class ChatListController extends GetxController {
  final roomId = ''.obs;
  final chatList = <ChatRoom>[].obs;
  // final chatList = Get.find<AuthController>().userInfo.value!.joinedTrip!;
  StreamSubscription? chatRoomsStreamSubscription;
  final _globalGetXController = Get.find<GlobalGetXController>();

  void setRoomId(String id) {
    roomId.value = id;
    _globalGetXController.setRoomId(id);
  }

  void _updateChatList(QuerySnapshot querySnapshot) async {
    Set<String> allParticipantUids = {};

    for (var chatData in querySnapshot.docs) {
      List<String> participantUidList =
          List<String>.from(chatData['participants']);
      allParticipantUids.addAll(participantUidList);
    }

    if (allParticipantUids.isEmpty) {
      chatList.clear();
      return;
    }

    final allParticipantsSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: allParticipantUids.toList())
        .get();

    Map<String, UserModel> allParticipantsMap = {
      for (var doc in allParticipantsSnapshots.docs)
        doc.id: UserModel.fromMap(doc.data() as Map<String, dynamic>)
    };

    List<ChatRoom> tempChatRoomList = [
      for (var chatData in querySnapshot.docs)
        ChatRoom.fromMap(
          chatData.data() as Map<String, dynamic>,
          participants: [
            for (var uid in List<String>.from(chatData['participants']))
              if (allParticipantsMap[uid] != null) allParticipantsMap[uid]!
          ],
        )
    ];

    chatList.assignAll(tempChatRoomList);
  }

  void getChatList() {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    chatRoomsStreamSubscription = FirebaseFirestore.instance
        .collection('chatRooms')
        .where('participants', arrayContains: currentUserUid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .listen(_updateChatList);
  }

  // 참여중인 채팅방들 객체로 변환해서 가져오기
  Future<List<ChatRoom?>> readJoinedChatRoom(List joinedTrip) async {
    List<ChatRoom?> chatRoomList = await Future.wait(joinedTrip.map((roomId) async {
      return await DBService().getRoomInfoById(roomId);
    }));
    return chatRoomList;
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
