// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:tripin/model/user_model.dart';

import 'enum_color.dart';

class ChatRoom {
  String roomId; // 방 고유 ID
  String lastMessage; // 마지막 메시지
  int updatedAt; // 마지막 업데이트 시간 (타임스탬프)
  List<UserModel>? participants; // 참가자 리스트
  List? participantIdList; // 참가자 uid 리스트 (채팅방 생성, 프로필 상세용)
  DateTime? startDate;
  DateTime? endDate;
  String city;
  List<DateTime> dateRange;
  String roomTitle;
  String? imgUrl;
  List<String>? checkList;

  ChatRoom({
    required this.roomId,
    required this.lastMessage,
    required this.updatedAt,
    this.participants,
    this.participantIdList,
    this.startDate,
    this.endDate,
    required this.city,
    required this.dateRange,
    required this.roomTitle,
    this.imgUrl,
    this.checkList,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'lastMessage': lastMessage,
      'updatedAt': updatedAt,
      'participants': participantIdList,
      'startDate': startDate,
      'endDate': endDate,
      'city': city,
      'dateRange': dateRange,
      'roomTitle': roomTitle,
      'imgUrl': imgUrl,
      'checkList': checkList,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map,
      {List<UserModel>? participants}) {
    List? intDateRange = map['dateRange'];
    DateTime? startDate;
    DateTime? endDate;
    List<DateTime> dateRange = [];
    
    if (intDateRange != null) {
      intDateRange.forEach((element) {
        dateRange.add(DateTime.fromMillisecondsSinceEpoch(element));
      });
      print('데이트레인지1 : $dateRange');
    }

    if (map['startDate'] != null) {
      startDate = DateTime.fromMillisecondsSinceEpoch(map['startDate']);
    }

    if (map['endDate'] != null) {
      endDate = DateTime.fromMillisecondsSinceEpoch(map['endDate']);
    }


    return ChatRoom(
      roomId: map['roomId'] as String,
      lastMessage: map['lastMessage'] as String,
      updatedAt: map['updatedAt'] as int,
      participants: participants,
      participantIdList: map['participants'],
      startDate: startDate, // startDate 추가
      endDate: endDate,
      city: map['city'] ?? '',
      dateRange: dateRange,
      roomTitle: map['roomTitle'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      checkList: map['checkList'] ?? [],
    );
  }

  void forEach(Null Function() param0) {}
}
