import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/chat_list_controller.dart';
import 'package:tripin/model/marker_model.dart';

class MapScreenController extends GetxController {
  // roomId가 많이 쓰여서 멤버 변수로 만들었다.
  final String roomId;
  MapScreenController() : roomId = Get.find<ChatListController>().roomId.value;
  RxBool hasPermission = false.obs;
  Rx<NLatLng> myPosition = NLatLng(37.5665, 126.9780).obs;
  RxBool isLocationLoaded = false.obs;
  TextEditingController placeTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  RxList<MarkerModel> markerList = <MarkerModel>[].obs;
  RxList<NMarker> nMarkerList = <NMarker>[].obs;
  RxBool isMarkerTapped = false.obs;
  RxList<DateTime> dateRange = <DateTime>[].obs;
  RxList<int> timeStamps = <int>[].obs;
  RxString selectedCity = '도시 선택'.obs;
  Rxn<NLatLng> selectedCityLatLng = Rxn();
  ExpansionTileController expansionTileController = ExpansionTileController();
  RxInt selectedDayIndex = 0.obs;
  Rxn<DateTime> startDate = Rxn(); // 시작 날짜
  Rxn<DateTime> endDate = Rxn(); // 종료 날짜

  @override
  void onInit() async {
    super.onInit();
    await getMyLocation();
    print('roomId: $roomId');
    // Firestore 스냅샷 구독 (chatRooms)
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() != null && snapshot.data()!['dateRange'] != null) {
        List<int> timestamps = List<int>.from(snapshot.data()!['dateRange']);
        dateRange.value = timestamps
            .map((e) => DateTime.fromMillisecondsSinceEpoch(e))
            .toList();
        timeStamps.value = List<int>.from(snapshot.data()!['dateRange']);
      }
    });

    // Firestore 스냅샷 구독 (markers)
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .collection('markers')
        .snapshots()
        .listen(updateMarkersFromSnapshot);
  }

  void updateMarkersFromSnapshot(QuerySnapshot snapshot) {
    List<MarkerModel> markers = snapshot.docs
        .map((doc) => MarkerModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    // 마커를 order순으로 정렬
    markerList.value = markers..sort((a, b) => a.order.compareTo(b.order));

    // selectedDayIndex에 해당하는 마커만 필터링
    nMarkerList.value = markerList.value
        .where((marker) => marker.dateIndex == selectedDayIndex.value)
        .map(
          (markerModel) => NMarker(
            id: markerModel.id,
            position: markerModel.position,
          ),
        )
        .toList();
    print("Markers from Firestore: ${markerList.value.length}");
  }

  Future<Position> getMyLocation() async {
    // 위치 서비스가 활성화되어 있는지 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // 위치 서비스가 비활성화 상태면 에러 반환
      return Future.error('위치 서비스가 활성화되어 있지 않습니다.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 권한이 거부되면 에러 반환
        return Future.error('위치 권한이 거부되었습니다.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 권한이 영구적으로 거부되면 에러 반환
      return Future.error('위치 권한이 영구적으로 거부되었습니다.');
    }

    Position position = await Geolocator.getCurrentPosition();
    myPosition.value = NLatLng(position.latitude, position.longitude);
    // 현재 위치를 반환

    isLocationLoaded.value = true; // 추가
    return position;
  }

  // 마커를 파이어베이스에 추가
  addMarkers({
    required NLatLng position,
  }) async {
    if (selectedDayIndex.value >= timeStamps.length) {
      print('Error: Invalid index for timeStamps list.');
      return;
    }
    // 참조를 가져와서 markerId를 자동생성 가능하게 함
    final DocumentReference ref = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .collection('markers')
        .doc();

    // timeStamps의 길이와 index를 체크
    if (selectedDayIndex.value < timeStamps.length) {
      final MarkerModel newMarker = MarkerModel(
        id: ref.id,
        position: position,
        title: placeTextController.text,
        description: descriptionTextController.text,
        order: markerList.length + 1,
        timeStamp: timeStamps[selectedDayIndex.value],
        dateIndex: selectedDayIndex.value,
      );

      await ref.set(newMarker.toMap());

      placeTextController.clear();
      descriptionTextController.clear();
      Get.back();

      print('timeStamps length: ${timeStamps.length}');
      print('index: $selectedDayIndex.value');
      print('마커 생성 성공');
    } else {
      print('Error: Invalid index for timeStamps list.');
    }
  }

  // 파이어베이스에서 마커를 가져와서 markerList에 담아주고 NMarker 객체로 변환해서 리스트에 다시 담아준다.
  // getMarkers() async {
  //   print('roomId: $roomId');
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('chatRooms')
  //       .doc(roomId)
  //       .collection('markers')
  //       .orderBy('order') //order 순서로 정렬
  //       .get();

  //   List<MarkerModel> markers = querySnapshot.docs
  //       .map((doc) => MarkerModel.fromMap(doc.data() as Map<String, dynamic>))
  //       .toList();

  //   markerList.value = markers;
  //   print(markerList.last.title);

  //   // NMarker 객체로 변환 후 nMarkerList에 담아준다.
  //   nMarkerList.value = markerList.value
  //       .map((markerModel) =>
  //           NMarker(id: markerModel.id, position: markerModel.position))
  //       .toList();

  //   print('Firestore에서 가져온 마커 리스트: ${nMarkerList.value}');
  // }

  Future<void> deleteMarker({
    required String markerId,
    required int order,
    required String roomId,
  }) async {
    // 1. 특정 마커 삭제
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .collection('markers')
        .doc(markerId)
        .delete();

    // 2. order 값 갱신
    final snapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .collection('markers')
        .where('order', isGreaterThan: order)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'order': doc.data()['order'] - 1});
    }
  }

  // markeList의 마커id와 NMarkerList의 마커id를 비교해서 각각 알맞게 띄워준다.
  void showInfoWindow(List<NMarker> NMarkerList) {
    for (NMarker nMarker in NMarkerList) {
      MarkerModel correspondingModel =
          markerList.firstWhere((model) => model.id == nMarker.info.id);

      final infoText = correspondingModel.title;
      final infoWindow =
          NInfoWindow.onMarker(id: nMarker.info.id, text: infoText);

      nMarker.openInfoWindow(infoWindow);
    }
  }

  void addArrowheadPath(
      NaverMapController mapController, List<NMarker> NMarkerList) {
    List<NLatLng> coords =
        NMarkerList.map((marker) => marker.position).toList();

    NArrowheadPathOverlay pathOverlay = NArrowheadPathOverlay(
        id: 'pathOverlay',
        coords: coords,
        color: Colors.yellow,
        outlineWidth: 1.0,
        outlineColor: Colors.yellow);

    mapController.addOverlay(pathOverlay);
  }

  List<DateTime> getDatesBetweenAndUpdate(DateTime start, DateTime end) {
    dateRange.clear();

    for (int i = 0; i <= end.difference(start).inDays; i++) {
      dateRange.add(start.add(Duration(days: i)));
    }

    print('날짜 리스트: $dateRange');

    // 사용하기 쉬운 타임스탬프로 변환
    List<int> _timestamps =
        dateRange.map((date) => date.millisecondsSinceEpoch).toList();

    timeStamps.value = _timestamps;
    print(timeStamps.value);

    // Firestore에 업데이트
    updateDateRangeInFirestore(_timestamps);

    return dateRange;
  }

  updateDateRangeInFirestore(List<int> newDateRange) async {
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .update({
      'dateRange': newDateRange,
    });
    print('dateRange 업데이트: $newDateRange');
  }

  // addPlanToFireStore() async {
  //   PlanModel newPlan = PlanModel(
  //     dateTimestamps: timeStamps.value,
  //     city: selectedCity.value,
  //     markers: markerList,
  //   );
  //   await FirebaseFirestore.instance
  //       .collection('chatRooms')
  //       .doc(roomId)
  //       .collection('plan')
  //       .doc(roomId)
  //       .set(
  //         newPlan.toMap(),
  //       );
  // }

  onDayButtonTap({required int index}) {
    print("onDayButtonTap called with index: $index");
    selectedDayIndex.value = index;

    // 선택된 날짜가 변경되면 마커 목록을 업데이트합니다.
    nMarkerList.value = markerList.value
        .where((marker) => marker.dateIndex == selectedDayIndex.value)
        .map((markerModel) =>
            NMarker(id: markerModel.id, position: markerModel.position))
        .toList();
    print("Updated nMarkerList: ${nMarkerList.value.length}");
  }
}
