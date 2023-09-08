// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:sfac_design_flutter/sfac_design_flutter.dart';
import 'package:tripin/controllers/map/map_screen_controller.dart';

class MapScreen extends GetView<MapScreenController> {
  final String roomId;
  const MapScreen({required this.roomId, super.key});

  @override
  Widget build(BuildContext context) {
    final List<NMarker> _nMarkerList = controller.nMarkerList;
    if (!controller.hasPermission.value) {
      controller.hasPermission;
      print('Position: ${controller.myPosition.value}');
      print('Current RoomId ${roomId}');
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          '지도 페이지',
        ),
      ),
      body: Stack(
        children: [
          Obx(() {
            // 내 위치를 받아올 때까지 기다린다.
            // 위치를 받을 수 없고 마커가 없으면 로딩 중 표시
            if (!controller.isLocationLoaded.value &&
                controller.nMarkerList.isEmpty) {
              return Center(child: CircularProgressIndicator()); // 로딩 중 표시
            }
            return NaverMap(
              key: ValueKey(controller.nMarkerList.length),
              onMapTapped: (point, latLng) {
                Get.defaultDialog(
                  title: '마커 생성하기',
                  content: Column(
                    children: [
                      TextField(
                        controller: controller.placeTextController,
                        decoration: InputDecoration(
                          hintText: '장소',
                        ),
                      ),
                      TextField(
                        controller: controller.descriptionTextController,
                        decoration: InputDecoration(
                          hintText: '메모',
                        ),
                      ),
                    ],
                  ),
                  cancel: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('취소'),
                  ),
                  confirm: ElevatedButton(
                    onPressed: () {
                      controller.addMarkers(position: latLng, roomId: roomId);
                    },
                    child: Text('생성'),
                  ),
                );
                print(latLng);
              },
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: controller.myPosition.value,
                  zoom: 15,
                  bearing: 0,
                  tilt: 0,
                ),
              ),
              onMapReady: (NMapController) {
                NMapController.addOverlayAll(_nMarkerList.toSet());
                print(controller.markerList);
                print(_nMarkerList);
                print("네이버 맵 로딩됨!");
                for (int i = 0; i < _nMarkerList.length; i++) {
                  final infoText =
                      "${controller.markerList[i].title}${controller.markerList[i].description}";

                  final infoWindow = NInfoWindow.onMarker(
                      id: _nMarkerList[i].info.id, text: infoText);

                  _nMarkerList[i].openInfoWindow(infoWindow);
                }
              },
              onSymbolTapped: (symbolInfo) {
                print(symbolInfo);
              },
            );
          }),
          Positioned(
            child: SFDatePicker(
              type: SFCalendarType.range,
              initialDay: DateTime.now(),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.1, // 처음에는 화면의 10% 크기로 표시
            minChildSize: 0.1, // 최소 크기는 화면의 10%
            maxChildSize: 0.8,
            // 아래는 스크롤이 끝까지 될지 말지 정하는 파라미터
            snapSizes: [0.1, 0.8],
            snap: true,

            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                color: Colors.white,
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  controller: scrollController,
                  itemCount: 25,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 50.0,
                              child: Divider(
                                thickness: 5,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Day1'),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Day2'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return ListTile(title: Text('아이템 $index'));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
