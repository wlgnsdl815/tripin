// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kpostal/kpostal.dart';
import 'package:tripin/const/cities.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/controllers/global_getx_controller.dart';
import 'package:tripin/controllers/map/map_screen_controller.dart';
import 'package:tripin/model/map/kakao_geocoding_model.dart';
import 'package:tripin/service/kakao_geocoding_service.dart';
import 'package:tripin/utils/api_keys_env.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/widget/custom_button.dart';
import 'package:tripin/view/widget/custom_date_picker.dart';
import 'package:tripin/view/widget/map_bottom_sheet.dart';

class MapScreen extends GetView<MapScreenController> {
  static const route = '/map';

  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NMarker> _nMarkerList = controller.nMarkerList;
    final List<String> citiesName = cities.keys.toList();
    final List<NLatLng> citiesNLatLng = cities.values.toList();
    late NaverMapController naverMapController;
    final NLatLng? positionFromMessage =
        Get.arguments != null ? Get.arguments['position'] : null;

    final int? dateIndexFromArgs =
        Get.arguments != null ? Get.arguments['dateIndex'] : null;
    print('인덱스: $dateIndexFromArgs');

    final SelectFriendsController _selectFriendsController =
        Get.find<SelectFriendsController>();
    final GlobalGetXController _globalGetXController =
        Get.find<GlobalGetXController>();
    print(
        '_globalGetXController in Map Screen roomId: ${_globalGetXController.roomId}');

    controller.getDatesFromFirebase();
    if (!controller.hasPermission.value) {
      controller.hasPermission;
      print('Position: ${controller.myPosition.value}');
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Obx(
          () => Text(
            '${_globalGetXController.roomTitle}',
          ),
        ),
        backgroundColor: PlatformColors.primary,
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
                onSymbolTapped: (symbolInfo) async {
                  _handleTap(symbolInfo.position, symbolInfo.caption);
                },
                onMapTapped: (point, latLng) async {
                  _handleTap(latLng);
                },
                options: NaverMapViewOptions(
                  initialCameraPosition:
                      // 우선순위 1: 채팅으로부터 전달받은 포지션이 있으면 해당 위치로 이동
                      positionFromMessage != null
                          ? NCameraPosition(
                              target: positionFromMessage,
                              zoom: 15,
                            )
                          // 우선순위 2: 마커 리스트에 마커가 있으면 마지막 마커의 위치로 이동
                          : (_nMarkerList.isNotEmpty
                              ? NCameraPosition(
                                  target: _nMarkerList.last.position,
                                  zoom: 15,
                                )
                              // 우선순위 3: 그 외의 경우 사용자의 현재 위치로 이동
                              : NCameraPosition(
                                  target: controller.myPosition.value,
                                  zoom: 15,
                                )),
                ),
                onMapReady: (NMapController) async {
                  naverMapController = NMapController;
                  this.controller.nMapController.value = NMapController;
                  if (dateIndexFromArgs != null) {
                    controller.onDayButtonTap(
                        index: dateIndexFromArgs,
                        position: positionFromMessage);
                  }
                  print(naverMapController);
                  controller.showMarkers();
                  for (var marker in _nMarkerList) {
                    marker.setOnTapListener((NMarker tappedMarker) {
                      print('탭한 마커 id: ${tappedMarker.info.id}');
                      _showBottomSheet(_nMarkerList, 'right');
                    });
                  }
                },
              );
            },
          ),
          Column(
            children: [
              // 도시 선택하는 Table
              Container(
                color: Colors.white,
                child: ExpansionTile(
                  controller: controller.expansionTileController,
                  backgroundColor: Colors.white,
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/icons/location2.png',
                        width: 14.w,
                        height: 16.h,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => Text(
                          _globalGetXController.selectedCity.value,
                          style: AppTextStyle.body17M(),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Table(
                          border:
                              TableBorder.all(color: PlatformColors.subtitle7),
                          children: List.generate(
                            6,
                            (row) {
                              return TableRow(
                                children: List.generate(3, (column) {
                                  int index = row * 3 + column;
                                  return Obx(
                                    () => GestureDetector(
                                      onTap: () async {
                                        _globalGetXController.selectedCity
                                            .value = citiesName[index];
                                        await _selectFriendsController
                                            .upDateCity(
                                          _globalGetXController.roomId.value,
                                          citiesName[index],
                                        ); // 도시 업데이트
                                        print(
                                            '터치: ${_globalGetXController.selectedCity.value}');
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
                                        color: _globalGetXController
                                                    .selectedCity.value ==
                                                citiesName[index]
                                            ? PlatformColors.primary
                                            : Colors.transparent,
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4.0,
                                            ),
                                            child: Text(
                                              citiesName[index],
                                              style: AppTextStyle.body13M(
                                                  color: controller.selectedCity
                                                              .value ==
                                                          citiesName[index]
                                                      ? Colors.white
                                                      : PlatformColors.title),
                                            ),
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
              // 날짜 선택 데이트 피커
              CustomDatePicker(),
              // 날짜 변경 버튼
              SizedBox(height: 11),
              Obx(() {
                if (controller.dateRange.isEmpty) {
                  return SizedBox.shrink();
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      controller.dateRange.length,
                      (index) {
                        bool isSelected =
                            index == controller.selectedDayIndex.value;
                        return Padding(
                          padding: EdgeInsets.only(
                            right:
                                (index < controller.dateRange.length) ? 15 : 0,
                            left: index == 0 ? 15 : 0,
                          ),
                          child: CustomButton(
                            onTap: () {
                              controller.onDayButtonTap(index: index);
                              controller.selectedDayIndex.value = index;
                            },
                            text: 'Day ${index + 1}',
                            textStyle: AppTextStyle.body16M(
                              color: isSelected
                                  ? PlatformColors.primary
                                  : PlatformColors.subtitle2,
                            ),
                            textPadding: EdgeInsets.symmetric(
                              horizontal: 17.w,
                              vertical: 7.h,
                            ),
                            backgroundColor: isSelected
                                ? PlatformColors.chatPrimaryLight
                                : Colors.white,
                            borderColor: isSelected
                                ? PlatformColors.primary
                                : PlatformColors.subtitle6,
                            borderRadius: BorderRadius.circular(32.r),
                            boxBorderWidth: 1.5,
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            // 오른쪽 버튼
            child: FloatingActionButton(
              backgroundColor: PlatformColors.primary,
              heroTag: 'rightButton',
              onPressed: () async {
                _showBottomSheet(_nMarkerList, 'right');
                await controller.onDayButtonTap(
                    index: controller.selectedDayIndex.value); // 선택된 날짜의 마커만 표시
              },
              child: Image.asset(
                'assets/icons/list.png',
                width: 21.w,
                height: 13.h,
              ),
            ),
          ),
          Align(
            alignment:
                Alignment.bottomRight + Alignment(0.w, -0.2.h), // 이 부분을 수정
            child: FloatingActionButton(
              heroTag: 'searchButton',
              backgroundColor: Colors.white,
              onPressed: () async {
                Kpostal? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KpostalView(
                      kakaoKey: Env.kakaoJSKey,
                    ),
                  ),
                );
                if (result != null) {
                  controller.cameraScrollTo(
                    naverMapController: naverMapController,
                    target:
                        NLatLng(result.kakaoLatitude!, result.kakaoLongitude!),
                  );
                } else {
                  print('장소 검색을 안하고 뒤로가기 함');
                }
              },
              child: Image.asset(
                'assets/icons/search.png',
                width: 21.w,
                height: 21.h,
              ),
            ),
          ),
          Align(
            alignment:
                Alignment.bottomLeft + Alignment(0.2.w, -0.2.h), // 이 부분을 수정
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              heroTag: 'current_location_Button',
              onPressed: () {
                controller.cameraScrollTo(
                  naverMapController: naverMapController,
                  target: controller.myPosition.value,
                );
              },
              child: Image.asset(
                'assets/icons/current_location.png',
                width: 25.w,
                height: 25.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(List<NMarker> nMarkerList, String buttonPosition) {
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
          MapBottomSheet(),
        ],
      ),
      isDismissible: true,
      isScrollControlled: true, // 전체화면 바텀시트 가능
    );
  }

  void _handleTap(NLatLng latLng, [String? caption]) async {
    String captionText = caption ?? '';

    try {
      KakaoGeocodingModel tapLocationFromKaKao = await KaKaoGeocodingService()
          .getGeoDataFromKakao(lat: latLng.latitude, lng: latLng.longitude);
      controller.placeTextController.text = captionText;
      print(tapLocationFromKaKao);
      if (controller.dateRange.isEmpty) {
        print(controller.dateRange);
        Get.snackbar('알림', '날짜를 먼저 선택해주세요');
        return;
      }

      // 캡션 텍스트(심볼 클릭시)가 있으면 캡션 텍스트를 넣어주고
      if (captionText != '') {
        controller.setPlaceText(captionText);
      } else {
        // 없으면 주소를 기본 값으로 넣어준다.
        controller.setPlaceText(tapLocationFromKaKao.addressName!);
      }
      controller.kakaoAddress.value = tapLocationFromKaKao.addressName!;

      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 핀 이미지 넣기
                    // Image.asset(),
                    Text(
                      '메모',
                      style: AppTextStyle.body15M(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 19),
                TextField(
                  controller: controller.placeTextController,
                  cursorColor: Colors.black,
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: PlatformColors.primary,
                      ),
                    ),
                    isDense: true,
                  ),
                ),
                Text(tapLocationFromKaKao.addressName!),
                SizedBox(height: 8),
                TextField(
                  maxLines: 5,
                  controller: controller.descriptionTextController,
                  decoration: InputDecoration(
                    fillColor: PlatformColors.subtitle8,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: PlatformColors.primary,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: PlatformColors.subtitle7,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: '메모를 추가할 수 있어요!',
                    hintStyle: TextStyle(color: PlatformColors.subtitle4),
                    suffixIconConstraints: BoxConstraints(maxHeight: 30),
                  ),
                ),
                SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      onTap: () {
                        controller.descriptionTextController.clear();
                        Get.back();
                      },
                      text: '취소',
                      textPadding: EdgeInsets.symmetric(
                        horizontal: 48,
                      ),
                      textStyle: AppTextStyle.body12M(
                        color: PlatformColors.subtitle7,
                      ),
                      borderRadius: BorderRadius.circular(44),
                      borderColor: PlatformColors.subtitle7,
                      backgroundColor: Colors.white,
                    ),
                    CustomButton(
                      onTap: () {
                        controller.addMarkers(position: latLng);
                      },
                      text: '등록',
                      textPadding: EdgeInsets.symmetric(
                        horizontal: 48,
                      ),
                      textStyle: AppTextStyle.body12M(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(44),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print(e);
      Get.snackbar('알림', '주소를 가져오는데 실패했습니다. 다른 위치를 선택해주세요');
    }
  }
}
