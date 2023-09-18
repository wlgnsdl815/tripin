
import 'dart:developer';

import 'package:get/get.dart';
import 'package:tripin/service/db_service.dart';

import '../model/chat_room_model.dart';
import '../model/user_model.dart';

class ProfileDetailController extends GetxController {
  UserModel user = Get.arguments[0];
  RxList<ChatRoom?> joinedChatRoomList = <ChatRoom?>[].obs;
  RxList<ChatRoom?> ongoingTrips = <ChatRoom?>[].obs;
  RxList<ChatRoom?> upcomingTrips = <ChatRoom?>[].obs;
  RxList<ChatRoom?> completedTrips = <ChatRoom?>[].obs;

  // 참여중인 채팅방 리스트 가져오기
  Future<void> readJoinedChatRoom() async {
    if (user.joinedTrip != null) {
      List<ChatRoom?> chatRoomList = await Future.wait(
        user.joinedTrip!.map((roomId) async {
          return await DBService().getRoomInfoById(roomId);
        })
      );
      joinedChatRoomList(chatRoomList);

      // 여행 리스트 분류
      DateTime now = DateTime.now();
      for (var room in chatRoomList) {
        if (room != null && room.startDate != null && room.endDate != null) {
          DateTime startDate = DateTime.fromMillisecondsSinceEpoch(room.startDate!);
          DateTime endDate = DateTime.fromMillisecondsSinceEpoch(room.endDate!);
          if (endDate.isBefore(now)) {
            completedTrips.add(room);
          } else if (startDate.isBefore(now) && endDate.isAfter(now)) {
            ongoingTrips.add(room);
          } else {
            upcomingTrips.add(room);
          }
        }
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await readJoinedChatRoom();
    log('$joinedChatRoomList', name: 'joinedChatRoomList');
    log('$ongoingTrips', name: '진행중');
    log('$upcomingTrips', name: '예정');
    log('$completedTrips', name: '완료');
  }
}
