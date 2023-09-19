
import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tripin/service/db_service.dart';

import '../model/chat_room_model.dart';
import '../model/user_model.dart';

class ProfileDetailController extends GetxController {
  UserModel user = Get.arguments[0];
  RxList<ChatRoom?> joinedChatRoomList = <ChatRoom?>[].obs; // 참여중인 여행 전체 리스트
  RxList<ChatRoom?> ongoingTrips = <ChatRoom?>[].obs;       // 진행중인 여행 리스트
  RxList<ChatRoom?> upcomingTrips = <ChatRoom?>[].obs;      // 예정된 여행 리스트
  RxList<ChatRoom?> completedTrips = <ChatRoom?>[].obs;     // 완료된 여행 리스트
  RxBool isLoading = false.obs;   // 로딩중 상태

  RxInt filterIdx = 0.obs;        // 필터링 선택값
  List<String> filterOptionList = ['예정', '종료'];   // 필터링 옵션 리스트

  // 참여중인 채팅방 리스트 가져오기
  Future<void> readJoinedChatRoom() async {
    isLoading(true);
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
          if (room.endDate!.isBefore(now)) {
            completedTrips.add(room);
          } else if (room.startDate!.isBefore(now) && room.endDate!.isAfter(now)) {
            ongoingTrips.add(room);
          } else {
            upcomingTrips.add(room);
          }
        } else {
          upcomingTrips.add(room);
        }
      }
    }
    isLoading(false);
  }

  // 날짜 형식 변환
  void formatDateTime(int timestamp) {
    DateTime tripStartDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDateTime = DateFormat('yyyy.MM.dd').format(tripStartDate);
  }

  String getDayOfWeek(DateTime date) {
    List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];
    return daysOfWeek[date.weekday - 1];
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
