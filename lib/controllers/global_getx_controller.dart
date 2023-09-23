import 'package:get/get.dart';

class GlobalGetXController extends GetxService {
  RxString roomId = ''.obs;
  RxString roomTitle = ''.obs;
  RxString roomImageUrl = ''.obs;
  RxString selectedCity = '미정'.obs;

  setRoomId(String id) {
    roomId.value = id;
    print('Global Room Id: ${roomId.value}');
  }

  setRoomTitle(String title) {
    roomTitle.value = title;
  }

  setRoomImageUrl(String url) {
    roomImageUrl.value = url;
  }

  setSelectedCity(String city) {
    selectedCity.value = city;
  }
}
