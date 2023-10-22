import 'package:flutter_naver_map/flutter_naver_map.dart';

class MarkerModel {
  final String id; // 마커 ID
  final NLatLng position; // 마커의 위치
  final String title; // 마커의 타이틀
  final String subTitle; // 마커의 서브타이틀

  final int order; // 마커 순서
  final int timeStamp; // 날짜 timeStamp
  final int dateIndex;
  final String userNickName;

  MarkerModel({
    required this.id,
    required this.position,
    required this.title,
    required this.subTitle,
    required this.order,
    required this.timeStamp,
    required this.dateIndex,
    required this.userNickName,
  });

  // Firestore 문서를 모델 객체로 변환
  factory MarkerModel.fromMap(Map<String, dynamic> map) {
    return MarkerModel(
      id: map['id'] as String,
      position: NLatLng(map['latitude'], map['longitude']),
      title: map['title'] as String,
      subTitle: map['subTitle'] as String,
      order: map['order'] as int,
      timeStamp: map['timeStamp'] as int,
      dateIndex: map['dateIndex'] as int,
      userNickName: map['userNickName'] as String,
    );
  }

  // 모델 객체를 Firestore 문서로 변환
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'title': title,
      'subTitle': subTitle,
      'order': order,
      'timeStamp': timeStamp,
      'dateIndex': dateIndex,
      'userNickName': userNickName,
    };
  }
}
