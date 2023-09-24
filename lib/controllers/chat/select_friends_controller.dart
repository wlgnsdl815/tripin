import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/calendar_controller.dart';
import 'package:tripin/controllers/global_getx_controller.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/model/enum_color.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/service/db_service.dart';

class SelectFriendsController extends GetxController {
  RxList<UserModel> userData = <UserModel>[].obs; // 필터링 된 현재 유저의 친구목록
  Rx<DateTime> startDay = DateTime.now().obs;
  RxString rangeHighlightColor = ''.obs;
  RxList<UserModel> participants = <UserModel>[].obs;
  RxString roomId = ''.obs;
  final AuthController _authController = Get.find<AuthController>();
  final GlobalGetXController _globalGetXController =
      Get.find<GlobalGetXController>();
  RxString roomTitle = ''.obs;
  Rxn<ChatRoom?> currentChatRoom = Rxn();
  Rxn<UserModel> userInfo = Get.find<AuthController>().userInfo; // 로그인한 유저 정보
  final TextEditingController searchFriendController = TextEditingController();
  RxDouble containerHeight = 0.0.obs;

  getUsers() async {
    List curUserFollowing = userInfo.value!.following;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    var usersData = querySnapshot.docs
        .map(
          (e) => UserModel.fromMap(e.data() as Map<String, dynamic>),
        )
        .toList()
        .where((user) => curUserFollowing.contains(user.uid))
        .toList(); // 친구 목록 필터링

    userData.assignAll(usersData);
    print('usersData: $usersData');
    print('참가자: $participants');
  }

  Future<String> createChatRoom() async {
    print('채팅방 생성');
    print('현재 유저: ${_authController.userInfo.value!.uid}');
    final firestoreInstance = FirebaseFirestore.instance;
    participants.add(userInfo.value!);
    print('참가자: $participants');

    // 현재 사용자의 UID를 먼저 추가
    String currentUserUid = _authController.userInfo.value!.uid;
    List<String> participantsUidList = [currentUserUid];

    // participants에서 추가적인 UID를 가져와 목록에 추가
    participantsUidList.addAll(participants.map((element) => element.uid));

    // 중복 제거
    participantsUidList = participantsUidList.toSet().toList();

    // 제목 생성
    List<String> defaultRoomTitle =
        participants.map((e) => e.nickName).toList();

    roomTitle.value = defaultRoomTitle.join(', ');

    _globalGetXController.setRoomTitle(roomTitle.value);
    print(_globalGetXController.roomTitle.value);

    ChatRoom newRoom = ChatRoom(
      roomId: '',
      lastMessage: '',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      participantIdList: participantsUidList,
      city: '미정',
      dateRange: [],
      roomTitle: roomTitle.value,
      imgUrl: '',
    );

    // 새로운 채팅방 추가
    DocumentReference docRef =
        await firestoreInstance.collection("chatRooms").add(newRoom.toMap());

    // 룸 아이디를 doc 아이디로 업데이트
    await docRef.update({
      'roomId': docRef.id,
    });

    newRoom.roomId = docRef.id;

    await DBService().saveJoinedRoomId(newRoom.roomId, participantsUidList);

    String randomColor = CalendarColors.getRandomColor();
    rangeHighlightColor.value = randomColor;

    firestoreInstance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('calendar')
        .doc(newRoom.roomId)
        .set({
      'roomId': newRoom.roomId,
      'title': '',
      'color': randomColor,
      'checkList': [],
    });

    firestoreInstance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'joinedTrip': FieldValue.arrayUnion([newRoom.roomId])
    });

    _globalGetXController.setRoomId(roomId.value);
    print(
        'getxController in Select Friends Controller: ${_globalGetXController.roomId}');

    currentChatRoom.value = newRoom;
    return newRoom.roomId;
  }

  upDateCity(String roomId, String selectedCity) async {
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .update({
      'city': selectedCity,
    });
    print('도시 업데이트: $selectedCity');
  }

  Future<void> updateStartAndEndDate(
      String roomId, DateTime startDate, DateTime endDate) async {
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .update({
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
    });

    print('시작 날짜와 종료 날짜 업데이트: $startDate, $endDate');
  }

  void searchFriend() {
    // searchFriendController에서 검색어 가져오기
    String query = searchFriendController.text.toLowerCase();

    if (query.isEmpty) {
      // 검색어가 없으면 원래의 사용자 목록을 보여줌
      getUsers();
      return;
    }

    var filteredUsers = userData
        .where((user) =>
            user.nickName.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query))
        .toList();
    userData.assignAll(filteredUsers);
  }

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }
}
