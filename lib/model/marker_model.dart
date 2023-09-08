import 'package:flutter_naver_map/flutter_naver_map.dart';

class MarkerModel {
  final String id; // 마커 ID
  final NLatLng position; // 마커의 위치
  final String title; // 마커의 타이틀
  final String description; // 마커에 대한 추가 설명

  MarkerModel({
    required this.id,
    required this.position,
    required this.title,
    required this.description,
  });

  // Firestore 문서를 모델 객체로 변환
  factory MarkerModel.fromMap(Map<String, dynamic> map) {
    return MarkerModel(
      id: map['id'],
      position: NLatLng(map['latitude'], map['longitude']),
      title: map['title'],
      description: map['description'],
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
    };
  }
}
