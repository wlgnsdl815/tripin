import 'package:flutter_naver_map/flutter_naver_map.dart';

class MarkerModel {
  final String id; // 마커 ID
  final NLatLng position; // 마커의 위치
  final String title; // 마커의 타이틀
  final String description; // 마커에 대한 추가 설명
  final int order; // 마커 순서
  final int timeStamp; // 날짜 timeStamp
  final int dateIndex;

  MarkerModel({
    required this.id,
    required this.position,
    required this.title,
    required this.description,
    required this.order,
    required this.timeStamp,
    required this.dateIndex,
  });

  // Firestore 문서를 모델 객체로 변환
  factory MarkerModel.fromMap(Map<String, dynamic> map) {
    return MarkerModel(
      id: map['id'],
      position: NLatLng(map['latitude'], map['longitude']),
      title: map['title'],
      description: map['description'],
      order: map['order'] ?? 0,
      timeStamp: map['timeStamp'] ?? 0,
      dateIndex: map['dateIndex'] ?? 0,
    );
  }

  // 모델 객체를 Firestore 문서로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'title': title,
      'description': description,
      'order': order,
      'timeStamp': timeStamp,
      'dateIndex': dateIndex,
    };
  }
}
