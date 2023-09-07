import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MapScreenController extends GetxController {
  RxBool hasPermission = false.obs;
  RxDouble _containerHeight = 50.0.obs;
  RxBool isDropDownTap = false.obs;

  get containerHeight => _containerHeight;

  setContainerHeight(double height) {
    isDropDownTap.value = !isDropDownTap.value;
    if (isDropDownTap.value == true) {
      _containerHeight.value = height;
      return;
    }
    _containerHeight.value = 50.0;
  }

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  // 권한 체크
  checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      requestPermission();
    } else {
      hasPermission.value = true;
    }
  }

  // 권한 요청
  requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      hasPermission.value = false;

      Get.snackbar('권한 거부', '설정에서 권한을 허가해주세요');
      print('권한 거부됨');
    } else {
      hasPermission.value = true;
    }
  }
}
