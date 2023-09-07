import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MapScreenController extends GetxController {
  RxBool hasPermission = false.obs;
  RxDouble _containerHeight = 50.0.obs;
  RxBool isDropDownTap = false.obs;
  Rx<NLatLng> myPosition = NLatLng(37.5665, 126.9780).obs;

  get containerHeight => _containerHeight;

  @override
  void onInit() {
    super.onInit();
    getMyLocation();
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
    return await Geolocator.getCurrentPosition();
  }
}
