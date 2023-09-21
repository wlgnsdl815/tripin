import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/model/chat_message_model.dart';

import '../../model/user_model.dart';
import '../../service/db_service.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final SelectFriendsController _selectFriendsController =
      Get.find<SelectFriendsController>();
  RxString _senderFromChatController = ''.obs;
  RxString _senderUidFromChatController = ''.obs;

  final functions = FirebaseFunctions.instance;
  // final ScrollController scrollController = ScrollController();
  RxList<ChatMessage> messageList = <ChatMessage>[].obs;

  String get senderFromChatController => _senderFromChatController.value;
  String get senderUidFromChatController => _senderUidFromChatController.value;

  // ScrollController 인스턴스 생성 메서드
  ScrollController createScrollController() {
    return ScrollController();
  }

  // Firebase 초기화 메서드
  FirebaseDatabase _initFirebase() {
    return FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            "https://sfac-tripin-default-rtdb.asia-southeast1.firebasedatabase.app/");
  }

  // 메시지 전송 메서드
  void sendMessage(
      String sender, String text, String roomId, String senderUid) async {
    _senderFromChatController.value = sender;
    _senderUidFromChatController.value = senderUid;
    print('sendMessage 메서드 호출됨');
    // 채팅방의 모든 참여자 가져오기
    List<String> participants =
        _selectFriendsController.participants.map((e) => e.uid).toList();

    Map<String, bool> initialReadUser = {};
    for (String userId in participants) {
      print('읽은 유저(채팅 보낸 사람 uid): $initialReadUser');
      // 보낸 사용자는 true, 나머지는 false
      initialReadUser[userId] = userId == senderUid;
      print('모든 참가자: ${_selectFriendsController.participants}');
    }

    // 서버의 시간을 활용하는 방법 functions의 index.js에서 정의하고 사용
    // 혹시 나중에 요금의 압박이 있다면 그냥 DateTime.now로 바꾸는 것 고려
    final result = await functions.httpsCallable('addTimestamp').call();
    cf.Timestamp timestamp =
        cf.Timestamp(result.data['_seconds'], result.data['_nanoseconds']);
    DateTime dateTime = timestamp.toDate();

    print('메세지 보낸시각(서버 타임): $dateTime');

    // 데이터베이스 참조를 가져옴
    final ref = _initFirebase().ref("chatRooms/$roomId/messages");

    // 새 메시지 객체 생성
    ChatMessage newMessage = ChatMessage(
      messageId: '',
      senderUid: FirebaseAuth.instance.currentUser!.uid,
      text: text,
      timestamp: dateTime.millisecondsSinceEpoch,
      isRead: initialReadUser,
    );

    DatabaseReference newMessageRef = ref.push();
    newMessage.messageId = newMessageRef.key!;
    await newMessageRef.set(newMessage.toMap());
    print(newMessage.text);
    await cf.FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .update({
      'lastMessage': newMessage.text,
    });

    messageController.clear();

    print('메세지 전송 성공: ${newMessageRef.path}, ${newMessage.toMap()}');
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

      // 반환된 맵을 캐스팅
      return deepCastMap(event.snapshot.value as Map?);
    });
  }

  // 후에 로직을 개선해서 성능 개선해보기
  Future<List<ChatMessage>> readMessage(messages, entries) async {
    List<ChatMessage> messageList = [];
    for (var e in messages.entries) {
      UserModel sender = await DBService().getUserInfoById(e.value['sender']);
      ChatMessage chatMessage = ChatMessage.fromMap(sender, e.value);
      messageList.add(chatMessage);
    }

    log('$messageList', name: 'controller :: messageList');

    // timestamp 속성을 기준으로 메시지 리스트 정렬
    messageList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    this.messageList(messageList);
    return messageList;
  }

  Future<UserModel> getSenderInfo(String uid) async {
    UserModel sender = await DBService().getUserInfoById(uid);
    return sender;
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

  // 유저가 읽었는지 확인
  void updateIsRead(String roomId, String userId) async {
    // 쿼리 참조를 가져옴
    DatabaseReference dbRef = _initFirebase()
        .ref()
        .child('chatRooms')
        .child(roomId)
        .child('messages');

    dbRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        // 데이터를 안전하게 Map으로 변환
        Map<String, dynamic>? messages = Map.from(event.snapshot.value as Map);

        if (messages != null) {
          for (String key in messages.keys) {
            if (messages[key]['isRead'] != null &&
                !messages[key]['isRead'][userId]) {
              dbRef.child(key).child('isRead').update({userId: true});
            }
          }
        }
      }
    });
  }
}
