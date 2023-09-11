// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tripin/model/marker_model.dart';

class PlanModel {
  final List<int> dateTimestamps; // 날짜들의 타임스탬프
  final String city; // 도시
  final List<MarkerModel> markers; // 마커들

  PlanModel({
    required this.dateTimestamps,
    required this.city,
    required this.markers,
  });

  // 타임스탬프를 DateTime으로 변환하는 함수
  List<DateTime> get dates => dateTimestamps
      .map((timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp))
      .toList();

  Map<String, dynamic> toMap() {
    return {
      'dateTimestamps': dateTimestamps,
      'city': city,
      'markers': markers.map((marker) => marker.toMap()).toList(),
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      dateTimestamps: List<int>.from(map['dateTimestamps'] as List),
      city: map['city'] as String,
      markers: List<MarkerModel>.from(
        (map['markers'] as List).map(
          (markerMap) => MarkerModel.fromMap(markerMap as Map<String, dynamic>),
        ),
      ),
    );
  }
}
