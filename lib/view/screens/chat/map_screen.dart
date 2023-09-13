// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:sfac_design_flutter/sfac_design_flutter.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/controllers/map/map_screen_controller.dart';
import 'package:tripin/service/geocoding_service.dart';
import 'package:tripin/view/screens/calendar_screen.dart';


class MapScreen extends GetView<MapScreenController> {
  final String roomId;
  const MapScreen({required this.roomId, super.key});

  @override
  Widget build(BuildContext context) {
    final List<NMarker> _nMarkerList = controller.nMarkerList;
    final List<String> citiesName = cities.keys.toList();
    final List<NLatLng> citiesNLatLng = cities.values.toList();
    late NaverMapController naverMapController;
    final SelectFriendsController _selectFriendsController =
        Get.find<SelectFriendsController>();
    if (!controller.hasPermission.value) {
      controller.hasPermission;
      print('Position: ${controller.myPosition.value}');
      print('Current RoomId ${roomId}');
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Obx(
          () => Text(
            '지도 페이지 - Day ${controller.selectedDayIndex.value + 1}',
          ),
        ),
      ),
      body: Stack(
        children: [
          Obx(
            () {
              // 내 위치를 받아올 때까지 기다린다.
              // 위치를 받을 수 없고 마커가 없으면 로딩 중 표시
              if (!controller.isLocationLoaded.value &&
                  controller.nMarkerList.isEmpty) {
                return Center(child: CircularProgressIndicator()); // 로딩 중 표시
              }
              return NaverMap(
                key: ValueKey(DateTime.now().millisecondsSinceEpoch),
                onMapTapped: (point, latLng) async {
                  if (controller.dateRange.isEmpty) {
                    Get.snackbar('알림', '날짜를 먼저 선택해주세요');
                    return;
                  }
                  GeocodingService geocodingService = GeocodingService();
                  Map<String, dynamic> geoData = await geocodingService
                      .naverReverseGeocode(latLng.latitude, latLng.longitude);
                  Get.dialog(
                    Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('메모'),
                          Text('data'),
                          TextField(
                            controller: controller.placeTextController,
                            decoration: InputDecoration(
                              hintText: '메모를 입력해보세요',
                            ),
                          ),
                          SizedBox(
                            height: 50, // 필요한 높이로 설정
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    '취소',
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.addMarkers(
                                      position: latLng,
                                    );
                                  },
                                  child: Text(
                                      'Day ${controller.selectedDayIndex.value + 1}에 추가'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                onMapReady: (NMapController) async {
                  naverMapController = NMapController;

                  NMapController.addOverlayAll(_nMarkerList.toSet());

                  print(controller.markerList);
                  print(_nMarkerList);
                  print("네이버 맵 로딩됨!");
                  controller.showInfoWindow(_nMarkerList); // 정보창 표시
                  controller.addArrowheadPath(
                      NMapController, _nMarkerList); // 경로 표시

                  for (var marker in _nMarkerList) {
                    marker.setOnTapListener((NMarker tappedMarker) {
                      print("Tapped marker with id: ${tappedMarker.info.id}");
                      _showBottomSheet(_nMarkerList);
                      tappedMarker.setIconTintColor(Color(0xFF4D80EE));
                    });
                  }
                },
              );
            },
          ),
          Column(
            children: [
              SFDatePicker(
                type: SFCalendarType.range,
                todayMark: true,
                getSelectedDate: (start, end, selectedDateList, selectedOne) {
                  if (start != null && end != null) {
                    controller.getDatesBetweenAndUpdate(start, end);
                    _selectFriendsController.updateStartAndEndDate(
                        roomId, start, end);
                  } else {
                    print("시작 날짜 또는 종료 날짜 null");
                  }
                },
              ),
              Container(
                color: Colors.white,
                child: ExpansionTile(
                  controller: controller.expansionTileController,
                  backgroundColor: Colors.white,
                  title: Obx(
                    () => Text(
                      controller.selectedCity.value,
                    ),
                  ),
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Table(
                          border: TableBorder.all(),
                          children: List.generate(
                            6,
                            (row) {
                              return TableRow(
                                children: List.generate(3, (column) {
                                  int index = row * 3 + column;
                                  return Obx(
                                    () => GestureDetector(
                                      onTap: () async {
                                        controller.selectedCity.value =
                                            citiesName[index];
                                        await _selectFriendsController
                                            .upDateCity(roomId,
                                                citiesName[index]); // 도시 업데이트

                                        print(
                                            '터치: ${controller.selectedCity.value}');
                                        controller.expansionTileController
                                            .collapse();
                                        controller.selectedCityLatLng.value =
                                            citiesNLatLng[index];
                                        final cameraUpdate =
                                            NCameraUpdate.scrollAndZoomTo(
                                          target: controller
                                              .selectedCityLatLng.value,
                                          zoom: 10,
                                        );
                                        naverMapController
                                            .updateCamera(cameraUpdate);
                                      },
                                      child: Container(
                                        color: controller.selectedCity.value ==
                                                citiesName[index]
                                            ? Colors.amber
                                            : Colors.transparent,
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            citiesName[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      if (controller.timeStamps.isNotEmpty &&
                          controller.selectedCity.value != '') {
                        return ElevatedButton(
                          onPressed: () {},
                          child: Text('완료'),
                        );
                      } else {
                        return SizedBox
                            .shrink(); // 조건이 맞지 않을 때는 아무 것도 보이지 않게 처리
                      }
                    })
                  ],
                ),
              ),
              SizedBox(
                height: 50.0, // 원하는 높이로 조절
                child: Obx(() {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.dateRange.isEmpty
                        ? 1
                        : controller.dateRange.length,
                    itemBuilder: (context, index) {
                      if (controller.dateRange.isEmpty) {
                        return Text('날짜를 선택해주세요');
                      }
                      return ElevatedButton(
                        onPressed: () {
                          controller.onDayButtonTap(index: index);
                          print(controller.selectedDayIndex);
                        },
                        child: Text('Day ${index + 1}'),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              Get.to(() => CalenderScreen());
            },
            child: Text('캘린더'),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     _showBottomSheet(_nMarkerList);
      //     await controller.onDayButtonTap(
      //         index: controller.selectedDayIndex.value); // 선택된 날짜의 마커만 표시
      //   },
      // ),
    );
  }

  void _showBottomSheet(List<NMarker> nMarkerList) {
    // List<NMarker> filteredList = nMarkerList.where((e) => );
    Get.bottomSheet(
      Stack(
        children: [
          // GestureDetector가 스택의 전체를 차지하게 해서
          // DraggableScrollableSheet 외부 영역을 탭하면 닫히게 한다.
          // 이걸 추가하지 않으면 DraggableScrollableSheet에서 ScrollController를 사용하기 때문에 닫히지 않음
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.6, // 초기 크기를 60%로 설정
            maxChildSize: 1, // 최대 크기를 90%로 설정
            snap: true,
            snapSizes: [0.6, 1],
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                height: MediaQuery.of(context).size.height *
                    0.6, // 바텀시트 최소 크기를 맞춰야한다.
                color: Colors.white,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: nMarkerList.length + 1,
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
                            SizedBox(
                              height: 50.0, // 원하는 높이로 조절
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.dateRange.isEmpty
                                    ? 1
                                    : controller.dateRange.length,
                                itemBuilder: (context, index) {
                                  if (controller.dateRange.isEmpty) {
                                    return Text('날짜를 선택해주세요');
                                  }
                                  return ElevatedButton(
                                    onPressed: () {
                                      controller.onDayButtonTap(index: index);
                                      print(controller.selectedDayIndex);
                                      Get.back();
                                    },
                                    child: Text('Day ${index + 1}'),
                                  );
                                },
                              ),
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
      isDismissible: true,
      isScrollControlled: true, // 전체화면 바텀시트 가능
    );
  }
}

final Map<String, NLatLng> cities = {
  '서울': NLatLng(37.5665, 126.9780),
  '경기': NLatLng(37.2749, 127.0093),
  '인천': NLatLng(37.4563, 126.7052),
  '강원': NLatLng(37.8228, 128.1555),
  '강릉': NLatLng(37.7519, 128.8766),
  '대구': NLatLng(35.8714, 128.6014),
  '경주': NLatLng(35.8562, 129.2247),
  '부산': NLatLng(35.1796, 129.0756),
  '울산': NLatLng(35.5384, 129.3114),
  '경남': NLatLng(35.2376, 128.6919),
  '경북': NLatLng(36.4919, 128.8889),
  '광주': NLatLng(35.1595, 126.8526),
  '대전': NLatLng(36.3504, 127.3845),
  '충남': NLatLng(36.6588, 126.6728),
  '충북': NLatLng(36.6359, 127.4913),
  '전남': NLatLng(34.8679, 126.9910),
  '전북': NLatLng(35.7175, 127.1530),
  '제주': NLatLng(33.4890, 126.4983),
};
