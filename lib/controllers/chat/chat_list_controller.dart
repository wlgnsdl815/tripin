import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/service/db_service.dart';

class ChatListController extends GetxController {
  RxList chatList = [].obs;

  RxString roomId = ''.obs;

  setRoomId(String id) {
    roomId.value = id;
    print('setRoomId: ${roomId.value}');
  }

  getChatList() async {
    final firestoreInstance = FirebaseFirestore.instance;
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    final querySnapshot = await firestoreInstance
        .collection('chatRooms')
        .where('participants',
            arrayContains: currentUserUid) // Cloud Firestore에 색인 추가후 필터링
        .orderBy('updatedAt', descending: true) // 'updatedAt'를 기준으로 내림차순 정렬
        .get();

    chatList.addAll(querySnapshot.docs);
    print(querySnapshot.docs.map((e) => e.data()).toList());

    List<Map<String, dynamic>> chatDataList =
        querySnapshot.docs.map((e) => e.data()).toList();
    List<UserModel> participants = [];

    for (var chatData in chatDataList) {}
    chatDataList.map((e) => ChatRoom.fromMap(e, participants));
  }

  @override
  void onInit() {
    super.onInit();
    getChatList();
  }
}
