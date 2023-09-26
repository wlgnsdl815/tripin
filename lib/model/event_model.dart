import 'package:flutter/material.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'enum_color.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Event {
  final String title;
  final List<Map> checkList;
  // final Color color;
  final ChatRoom room;
  

  Event({
    required this.title,
    required this.checkList,
    // required this.color,
    required this.room,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'checkList': checkList,
      // 'color': color.value,
      'room': room.toMap(),
    };
  }



  factory Event.fromMap(Map<String, dynamic> map, ChatRoom chatRoom) {
    // Color color = CalendarColors.getColorByString(map['color']);
    return Event(
      title: map['title'] as String,
      checkList: map['checkList'] as List<Map>,
      // color: color,
      room: chatRoom,
    );
  }
}
