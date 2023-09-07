import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:sfac_design_flutter/sfac_design_flutter.dart';
import 'package:tripin/controllers/map/map_screen_controller.dart';

class MapScreen extends GetView<MapScreenController> {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!controller.hasPermission.value) {
      controller.hasPermission;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '지도 페이지',
        ),
      ),
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(),
            onMapReady: (controller) {
              print("네이버 맵 로딩됨!");
            },
          ),
          Positioned(
            child: SFDatePicker(
              type: SFCalendarType.range,
              initialDay: DateTime.now(),
            ),
          ),
        ],
      ),
    );
  }
}
