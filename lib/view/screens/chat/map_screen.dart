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
          Obx(
            () {
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
                        controller.addMarkers(position: latLng);
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
                onMapReady: (NMapController) async {
                  final locationOverlay =
                      await NMapController.getLocationOverlay();
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
                  print('$start, $end, $selectedDateList, $selectedOne');
                  print(start?.day ?? DateTime.now().day);
                  controller.getDatesBetween(
                    start ?? DateTime.now(),
                    end ?? DateTime.now(),
                  );
                },
              ),
              Container(
                color: Colors.white,
                child: ExpansionTile(
                  backgroundColor: Colors.white,
                  title: Text('도시선택'),
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
                                      onTap: () {
                                        controller.selectedCity.value =
                                            cities[index];
                                        controller.addPlanToFireStore();
                                        print(
                                            '터치: ${controller.selectedCity.value}');
                                        Get.back();
                                      },
                                      child: Container(
                                        color: controller.selectedCity.value ==
                                                cities[index]
                                            ? Colors.amber
                                            : Colors.transparent,
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            cities[index],
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
            ],
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(List<NMarker> nMarkerList) {
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
      isDismissible: true,
      isScrollControlled: true, // 전체화면 바텀시트 가능
    );
  }
}

final List<String> cities = [
  '서울',
  '경기',
  '인천',
  '강원',
  '강릉',
  '대구',
  '경주',
  '부산',
  '울산',
  '경남',
  '경북',
  '광주',
  '대전',
  '충남',
  '충북',
  '전남',
  '전북',
  '제주',
];
