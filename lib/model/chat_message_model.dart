// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'user_model.dart';

class ChatMessage {
  String messageId; // 메시지 고유 ID
  UserModel? sender; // 보낸 사람 객체
  String? senderUid; // 보낸 사람의 UID (메세지 전송 시 db에 uid 저장 용도로 사용)
  String text; // 메시지 내용
  int timestamp; // 메시지 전송 시간 (타임스탬프)
  Map<String, bool> isRead; // 읽음 상태
  bool isMap; // 지도에서 보낸 메세지
  NLatLng? position;

  ChatMessage({
    required this.messageId,
    this.sender,
    this.senderUid,
    required this.text,
    required this.timestamp,
    required this.isRead,
    required this.isMap,
    this.position,
  });

  Map<String, dynamic> toMap() {
    print('toMap 호출됨 포지션: $position');
    return {
      'messageId': messageId,
      'sender': senderUid,
      'text': text,
      'timestamp': timestamp,
      'isRead': isRead,
      'isMap': isMap,
      'position': position != null
          ? {'latitude': position!.latitude, 'longitude': position!.longitude}
          : null,
    };
  }

  factory ChatMessage.fromMap(UserModel sender, Map<String, dynamic> map) {
    return ChatMessage(
      messageId: map['messageId'] as String,
      sender: sender,
      text: map['text'] as String,
      timestamp: map['timestamp'] as int,
      isMap: map['isMap'] as bool,
      isRead:
          map['isRead'] != null ? Map<String, bool>.from(map['isRead']) : {},
      position: map['position'] != null
          ? NLatLng(
              map['position']['latitude'],
              map['position']['longitude'],
            )
          : null,
    );
  }
}
