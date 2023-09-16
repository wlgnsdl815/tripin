import 'package:get/get.dart';

class GlobalGetXController extends GetxService {
  RxString roomId = ''.obs;

  void setRoomId(String id) {
    roomId.value = id;
    print('Global Room Id: ${roomId.value}');
  }
}
