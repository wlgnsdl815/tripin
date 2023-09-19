import 'package:get/get.dart';

class GlobalGetXController extends GetxService {
  RxString roomId = ''.obs;
  RxString roomTitle = ''.obs;

  setRoomId(String id) {
    roomId.value = id;
    print('Global Room Id: ${roomId.value}');
  }

  setRoomTitle(String title) {
    roomTitle.value = title;
  }
}
