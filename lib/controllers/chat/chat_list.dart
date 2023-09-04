import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController {
  RxList chatList = [].obs;

  getChatList() async {
    final firestoreInstance = FirebaseFirestore.instance;

    final querySnapshot = await firestoreInstance
        .collection('chatRooms')
        .orderBy('updatedAt', descending: true) // 'updatedAt'를 기준으로 내림차순 정렬
        .get();

    chatList.addAll(querySnapshot.docs);
  }

  @override
  void onInit() {
    super.onInit();
    getChatList();
  }
}
