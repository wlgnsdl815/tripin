import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
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
  Rx<String> chatMessage = ''.obs;

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
  void sendMessage(String sender, String text, String roomId, String senderUid,
      bool isMap, NLatLng? position, int? dateIndex) async {
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
      isMap: isMap,
      position: position,
      dateIndex: dateIndex,
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
      'updatedAt': newMessage.timestamp,
    });

    messageController.clear();

    print('메세지 전송 성공: ${newMessageRef.path}, ${newMessage.toMap()}');
  }

  // 이 함수는 주어진 roomId에 따른 채팅 메시지 리스트를 스트림으로 반환
  Stream<List<ChatMessage>> getMessage(String roomId) async* {
    // Firebase Realtime Database에서 특정 채팅방의 메시지에 대한 참조를 가져오기
    Query dbRef = _initFirebase()
        .ref()
        .child('chatRooms')
        .child(roomId)
        .child('messages');

    // 해당 참조에서 값이 변경될 때마다 이벤트를 수신합니다.
    await for (var event in dbRef.onValue) {
      DateTime startTime = DateTime.now(); // 성능 측정을 위해 현재 시간을 기록합니다.

      // 만약 메시지가 없다면 빈 리스트를 반환하고 다음 이벤트로 넘어간다
      if (event.snapshot.value == null) {
        yield [];
        continue;
      }

      // 스냅샷 값을 Map 형태로 변환합니다.
      Map<String, dynamic> messages = deepCastMap(event.snapshot.value as Map?);

      // 여러 사용자의 정보를 동시에 가져오기 위해 Future 목록을 생성
      List<Future<ChatMessage>> futures = [];
      for (var e in messages.entries) {
        futures.add(
          // 각 메시지의 발신자 정보를 가져오기
          DBService().getUserInfoById(e.value['sender']).then((sender) {
            // 발신자 정보와 메시지 데이터를 이용해 ChatMessage 객체를 생성
            return ChatMessage.fromMap(sender, e.value);
          }),
        );
      }

      // 모든 발신자 정보를 동시에 가져온다.
      List<ChatMessage> messageList = await Future.wait(futures);

      // 메시지 리스트를 timestamp 기준으로 정렬합니다.
      messageList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      DateTime endTime = DateTime.now(); // 성능 측정을 위해 현재 시간을 다시 기록
      var result =
          endTime.difference(startTime).inMilliseconds; // 시작 시간과의 차이를 계산합니다.
      log('$result milliseconds',
          name: '걸린시간 결과, readMessages'); // 로그에 걸린 시간을 출력

      // 스트림에 메시지 리스트를 전달합니다.
      yield messageList;
    }
  }

  // 주어진 맵 데이터를 재귀적으로 탐색하며 모든 키를 String으로 캐스팅
  Map<String, dynamic> deepCastMap(Map? data) {
    // 입력받은 맵이 null일 경우, 빈 맵을 반환
    if (data == null) return {};

    // map 메서드를 사용해 맵의 각 항목을 반복 처리
    return data.map<String, dynamic>(
      (key, value) {
        // 현재 항목의 값이 또 다른 맵일 경우, 재귀 호출을 통해 그 맵도 처리
        if (value is Map) {
          return MapEntry(key as String, deepCastMap(value));
        } else {
          // 값이 맵이 아닐 경우, 그대로 키를 String으로 캐스팅하고 값을 반환
          return MapEntry(key as String, value);
        }
      },
    );
  }

  Future<UserModel> getSenderInfo(String uid) async {
    UserModel sender = await DBService().getUserInfoById(uid);
    return sender;
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
