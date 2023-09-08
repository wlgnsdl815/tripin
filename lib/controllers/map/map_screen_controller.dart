import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/chat_list_controller.dart';
import 'package:tripin/model/marker_model.dart';

class MapScreenController extends GetxController {
  RxBool hasPermission = false.obs;
  RxDouble _containerHeight = 50.0.obs;
  RxBool isDropDownTap = false.obs;
  Rx<NLatLng> myPosition = NLatLng(37.5665, 126.9780).obs;
  RxBool isLocationLoaded = false.obs;
  TextEditingController placeTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  RxList<MarkerModel> markerList = <MarkerModel>[].obs;
  RxList<NMarker> nMarkerList = <NMarker>[].obs;

  final ChatListController _chatListController = Get.find<ChatListController>();

  get containerHeight => _containerHeight;

  @override
  void onInit() async {
    super.onInit();
    await getMyLocation();
    // Firestore 스냅샷 구독
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_chatListController.roomId.value)
        .collection('markers')
        .snapshots()
        .listen((snapshot) {
      updateMarkersFromSnapshot(snapshot); // 여기서 데이터 처리
    });
  }

  void updateMarkersFromSnapshot(QuerySnapshot snapshot) {
    List<MarkerModel> markers = snapshot.docs
        .map((doc) => MarkerModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    markerList.value = markers;
    nMarkerList.value = markerList.value
        .map((markerModel) =>
            NMarker(id: markerModel.id, position: markerModel.position))
        .toList();
  }

  setContainerHeight(double height) {
    isDropDownTap.value = !isDropDownTap.value;
    if (isDropDownTap.value == true) {
      _containerHeight.value = height;
      return;
    }
    _containerHeight.value = 50.0;
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
  addMarkers({required NLatLng position, required String roomId}) async {
    // 참조를 가져와서 markerId를 자동생성 가능하게 함
    final DocumentReference ref = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .collection('markers')
        .doc();

    final MarkerModel newMarker = MarkerModel(
      id: ref.id,
      position: position,
      title: placeTextController.text,
      description: descriptionTextController.text,
    );

    await ref.set(newMarker.toMap());

    placeTextController.clear();
    descriptionTextController.clear();
    Get.back();
    print('마커 생성 성공');
  }

  // 파이어베이스에서 마커를 가져와서 markerList에 담아주고 NMarker 객체로 변환해서 리스트에 다시 담아준다.
  getMarkers({required String roomId}) async {
    print('roomId: ${_chatListController.roomId.value}');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .collection('markers')
        .get();

    List<MarkerModel> markers = querySnapshot.docs
        .map((doc) => MarkerModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    markerList.value = markers;

    // NMarker 객체로 변환 후 nMarkerList에 담아준다.
    nMarkerList.value = markerList.value
        .map((markerModel) =>
            NMarker(id: markerModel.id, position: markerModel.position))
        .toList();

    print('Firestore에서 가져온 마커 리스트: ${nMarkerList.value}');
  }
}
