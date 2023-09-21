import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/chat_controller.dart';
import 'package:tripin/controllers/global_getx_controller.dart';
import 'package:tripin/model/marker_model.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/service/db_service.dart';
import 'package:tripin/utils/colors.dart';

class MapScreenController extends GetxController {
  // roomId가 많이 쓰여서 멤버 변수로 만들었다.
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
  RxString currentUserNickName = ''.obs;
  Rxn<DateTimeRange> dateRangeFromFirebase = Rxn();
  RxString description = ''.obs;
  RxString placeText = ''.obs;

  final GlobalGetXController _globalGetXController =
      Get.find<GlobalGetXController>();
  final ChatController _chatController = Get.find<ChatController>();

  List<MarkerModel> get currentDayMarkers {
    return markerList
        .where((marker) => marker.dateIndex == selectedDayIndex.value)
        .toList();
  }

  setPlaceText(String place) {
    placeText.value = place;
  }

  @override
  void onInit() async {
    super.onInit();
    await getMyLocation();
    print('roomId22222: ${_globalGetXController.roomId.value}');

    if (_globalGetXController.roomId.value != null &&
        _globalGetXController.roomId.value.isNotEmpty) {
      // Firestore 스냅샷 구독 (chatRooms)
      FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(_globalGetXController.roomId.value)
          .snapshots()
          .listen((snapshot) {
        print('dateRange: $dateRange');
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
          .doc(_globalGetXController.roomId.value)
          .collection('markers')
          .snapshots()
          .listen(updateMarkersFromSnapshot);
    }
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
    await getCurrentUserNickName();
    if (selectedDayIndex.value >= timeStamps.length) {
      print('Error: Invalid index for timeStamps list.');
      return;
    }
    // 참조를 가져와서 markerId를 자동생성 가능하게 함
    final DocumentReference ref = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_globalGetXController.roomId.value)
        .collection('markers')
        .doc();

    // timeStamps의 길이와 index를 체크
    if (selectedDayIndex.value < timeStamps.length) {
      final MarkerModel newMarker = MarkerModel(
        id: ref.id,
        position: position,
        title: placeTextController.text == ''
            ? placeText.value
            : placeTextController.text,
        descriptions: [descriptionTextController.text],
        order: markerList.length + 1,
        timeStamp: timeStamps[selectedDayIndex.value],
        dateIndex: selectedDayIndex.value,
        userNickName: currentUserNickName.value,
      );

      await ref.set(newMarker.toMap());
      if (descriptionTextController.text == '') {
        _chatController.sendMessage(
          _chatController.senderFromChatController,
          "[지도] '핀${markerList.length + 1}: ${placeText}'이(가) 추가되었습니다.",
          _globalGetXController.roomId.value,
          _chatController.senderUidFromChatController,
        );
      } else {
        _chatController.sendMessage(
          _chatController.senderFromChatController,
          """[지도] '핀${markerList.length + 1}: ${placeText}'이(가) 추가되었습니다.

[메모] ${descriptionTextController.text}""",
          _globalGetXController.roomId.value,
          _chatController.senderUidFromChatController,
        );
      }

      placeTextController.clear();
      descriptionTextController.clear();
      Get.back();

      print('timeStamps length: ${timeStamps.length}');
      print('index: $selectedDayIndex.value');
      print('userNickName: $currentUserNickName');
      print('마커 생성 성공');
    } else {
      print('Error: Invalid index for timeStamps list.');
    }
  }

  upDateAndGetDescription(String markerId) async {
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_globalGetXController.roomId.value)
        .collection('markers')
        .doc(markerId)
        .update({
      'descriptions': FieldValue.arrayUnion([descriptionTextController.text])
    });

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_globalGetXController.roomId.value)
        .collection('markers')
        .doc(markerId)
        .get();

    var snapshotData = snapshot.data() as Map<String, dynamic>;
    // 가장 마지막에 추가된 설명을 반환
    description.value = snapshotData['descriptions'].last;
    descriptionTextController.clear();
  }

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

  // 마커 변경
  Future<void> updateIcon(NMarker nMarker, BuildContext context) async {
    NOverlayImage overlayImage = await NOverlayImage.fromWidget(
      widget: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [],
          color: Colors.white,
        ),
      ),
      size: Size(100, 100),
      context: context,
    );

    nMarker.setIcon(overlayImage);
  }

// markerList의 마커id와 NMarkerList의 마커id를 비교해서 각각 알맞게 띄워준다.
  void showInfoWindow(List<NMarker> NMarkerList, BuildContext context) {
    for (NMarker nMarker in NMarkerList) {
      MarkerModel correspondingModel =
          markerList.firstWhere((model) => model.id == nMarker.info.id);

      nMarker.setIcon(
        NOverlayImage.fromAssetImage('assets/icons/map_pin.png'),
      );
      // 아이콘 업데이트
      // updateIcon(nMarker, context);
      nMarker.setAnchor(NPoint(0.48.w, 0.66.h));
      nMarker.setSize(Size(70.w, 70.h));

      final infoText = correspondingModel.order.toString();
      // final infoWindow =
      //     NInfoWindow.onMarker(id: nMarker.info.id, text: infoText);

      // nMarker.openInfoWindow(infoWindow, align: NAlign.center);
    }
  }

  void addArrowheadPath(
      NaverMapController mapController, List<NMarker> NMarkerList) {
    List<NLatLng> coords =
        NMarkerList.map((marker) => marker.position).toList();

    NArrowheadPathOverlay pathOverlay = NArrowheadPathOverlay(
      id: 'pathOverlay',
      coords: coords,
      color: PlatformColors.primary.withOpacity(0.7),
      width: 5.w,
    );

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
        .doc(_globalGetXController.roomId.value)
        .update({
      'dateRange': newDateRange,
    });
    print('dateRange 업데이트: $newDateRange');
    // 마커 초기화
    final markersCollection = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_globalGetXController.roomId.value)
        .collection('markers');
    final markerDocs = await markersCollection.get();
    for (var doc in markerDocs.docs) {
      await doc.reference.delete();
    }
  }

  getDatesFromFirebase() async {
    print(_globalGetXController.roomId.value);
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_globalGetXController.roomId.value)
        .get();

    var data = snapshot.data() as Map<String, dynamic>;
    List<dynamic> dateRange = data['dateRange'];
    // DateTime dateRangeFromFirebase =
    //     DateTime.fromMillisecondsSinceEpoch(data['dateRange']);
    // DateTime convertedEndDate =
    //     DateTime.fromMillisecondsSinceEpoch(data['endDate']);
    List<DateTime> dateRangeFromFB = dateRange
        .map(
          (e) => DateTime.fromMillisecondsSinceEpoch(e),
        )
        .toList();
    if (dateRangeFromFB.isNotEmpty) {
      DateTimeRange dateTimeRange = DateTimeRange(
          start: dateRangeFromFB.first, end: dateRangeFromFB.last);
      dateRangeFromFirebase.value = dateTimeRange;
      print('dateRangeFromFirebase 값이 들어옴:${dateRangeFromFirebase.value}');
    } else {
      return;
    }
  }

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

  getCurrentUserNickName() async {
    var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    UserModel currentUser = await DBService().getUserInfoById(currentUserUid);
    currentUserNickName.value = currentUser.nickName;
  }
}
