import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/model/event_model.dart';
import 'package:tripin/utils/colors.dart';

class CalendarController extends GetxController{
   RxList<Event> events = <Event>[].obs;

  void addEvent({required String title}) async{
        final SelectFriendsController _selectFriendsController = SelectFriendsController();
        Event eventData = Event(title: title, checkList: [], color: PlatformColors.secondary);
print('${_selectFriendsController.roomId.value}');
    await FirebaseFirestore.instance
    .collection('chatRooms')
    .doc(_selectFriendsController.roomId.value)
    .collection('calendar')
    .doc()
    .set(eventData.toMap());
    print('일정이 Firestore에 추가되었습니다.');
  }

  

  
}