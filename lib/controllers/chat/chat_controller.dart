import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/model/chat_message_model.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final SelectFriendsController _selectFriendsController =
      Get.find<SelectFriendsController>();

  // Firebase 초기화 메서드
  FirebaseDatabase _initFirebase() {
    return FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            "https://sfac-tripin-default-rtdb.asia-southeast1.firebasedatabase.app/");
  }

  // 메시지 전송 메서드
  void sendMessage(String senderId, String text) async {
    print('sendMessage 메서드 호출됨');

    // 데이터베이스 참조를 가져옴
    final ref = _initFirebase()
        .ref("chatRooms/${_selectFriendsController.roomId.value}/messages");

    // 새 메시지 객체 생성
    ChatMessage newMessage = ChatMessage(
      messageId: '',
      sender: senderId,
      text: text,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    DatabaseReference newMessageRef = ref.push();
    newMessage.messageId = newMessageRef.key!;
    await newMessageRef.set(newMessage.toMap());

    print('메세지 전송 성공: ${newMessageRef.path}');
  }

  // 메시지 스트림 가져오기
  Stream<Map<dynamic, dynamic>> getMessage(String roomId) {
    // 쿼리 참조를 가져옴
    Query dbRef = _initFirebase()
        .ref()
        .child('chatRooms')
        .child(roomId)
        .child('messages');

    return dbRef.onValue.map((event) {
      if (event.snapshot.value == null) {
        return {};
      }
      messageController.clear();
      // 반환된 맵을 캐스팅
      return deepCastMap(event.snapshot.value as Map?);
    });
  }

  // 맵 재귀적 캐스팅 메서드
  Map<String, dynamic> deepCastMap(Map? data) {
    if (data == null) return {};

    return data.map<String, dynamic>(
      (key, value) {
        if (value is Map) {
          return MapEntry(key as String, deepCastMap(value));
        } else {
          return MapEntry(key as String, value);
        }
      },
    );
  }
}
