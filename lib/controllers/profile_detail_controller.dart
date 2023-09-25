import 'dart:developer';

import 'package:get/get.dart';

import '../model/chat_room_model.dart';
import '../model/user_model.dart';
import 'chat/chat_list_controller.dart';

class ProfileDetailController extends GetxController {
  UserModel user = Get.arguments[0];
  RxList<ChatRoom?> joinedChatRoomList = <ChatRoom?>[].obs; // 참여중인 여행 전체 리스트
  RxList<ChatRoom?> ongoingTrips = <ChatRoom?>[].obs; // 진행중인 여행 리스트
  RxList<ChatRoom?> upcomingTrips = <ChatRoom?>[].obs; // 예정된 여행 리스트
  RxList<ChatRoom?> completedTrips = <ChatRoom?>[].obs; // 완료된 여행 리스트
  RxBool isLoading = false.obs; // 로딩중 상태
  RxBool isEditing = false.obs; // 수정중 상태

  RxInt filterIdx = 0.obs; // 필터링 선택값
  List<String> filterOptionList = ['예정', '종료']; // 필터링 옵션 리스트

  // 참여중인 채팅방 리스트 가져오기
  Future<void> readJoinedChatRoom() async {
    isLoading(true);
    List<ChatRoom?> chatRoomList = await Get.find<ChatListController>().readJoinedChatRoom(user.joinedRoomIdList);
    joinedChatRoomList(chatRoomList);

    // 여행 리스트 분류
    DateTime now = DateTime.now();
    for (var room in chatRoomList) {
      if (room != null && room.startDate != null && room.endDate != null) {
        if (room.endDate!.isBefore(now)) {
          completedTrips.add(room);
        } else if (room.startDate!.isBefore(now) &&
            room.endDate!.isAfter(now)) {
          ongoingTrips.add(room);
        } else {
          upcomingTrips.add(room);
        }
      } else {
        upcomingTrips.add(room);
      }
    }
    sortTripListByStartDate(upcomingTrips);
    isLoading(false);
  }

  // 요일 가져오기
  String getDayOfWeek(DateTime date) {
    List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];
    return daysOfWeek[date.weekday - 1];
  }

  // 디데이 구하기
  int getDaysUntilTrip(DateTime startDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);  // 시, 분, 초 제외한 오늘 날짜
    int untilTrip = today.difference(startDate).inDays;
    return untilTrip;
  }

  // 시작 날짜를 기준으로 오름차순 정렬
  void sortTripListByStartDate(List tripList) {
    if (tripList.isNotEmpty) {
      tripList.sort((a, b) {
        if (a!.startDate == null && b!.startDate == null) {
          return 0;
        } else if (a.startDate == null) {
          return 1; // a가 null이면 b를 뒤로 배치
        } else if (b!.startDate == null) {
          return -1; // b가 null이면 a를 뒤로 배치
        } else {
          return a.startDate!.compareTo(b.startDate!);
        }
      });
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
