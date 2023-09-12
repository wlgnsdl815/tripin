import 'dart:convert';

import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Event {
  String title;
  List<String> checkList;
  Color color;
  
  
  Event({
    required this.title,
    required this.checkList,
    required this.color
  });



  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'checkList': checkList,
      'color' : color,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'] as String,
      checkList: map['checkList'] as List<String>,
      color: map['color'] as Color
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source) as Map<String, dynamic>);
}
