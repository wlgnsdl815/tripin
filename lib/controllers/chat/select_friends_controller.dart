import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/global_getx_controller.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/model/enum_color.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/service/db_service.dart';

class SelectFriendsController extends GetxController {
  RxList<UserModel> userData = <UserModel>[].obs;
  RxString rangeHighlightColor = ''.obs;
  RxList<UserModel> participants = <UserModel>[].obs;
  RxString roomId = ''.obs;
  final AuthController _authController = Get.find<AuthController>();
  final GlobalGetXController _globalGetXController =
      Get.find<GlobalGetXController>();

  getUsers() async {
    final tempUsersData = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    tempUsersData.clear();
    tempUsersData.addAll(querySnapshot.docs);

    var usersData = tempUsersData
        .map(
          (e) => UserModel.fromMap(e.data()!),
        )
        .toList();
    userData.assignAll(usersData);

    print('파베에 등록된 유저 리스트: ${usersData}');
  }

  Future<String> createChatRoom() async {
    print('채팅방 생성');
    print('현재 유저: ${_authController.userInfo.value!.uid}');
    print('참가자: $participants');
    final firestoreInstance = FirebaseFirestore.instance;

    // List<UserModel> participantModels = participants.map((participantId) {
    //   return userData.firstWhere((user) => user.uid == participantId);
    // }).toList();

    List<String> participantsUidList =
        participants.map((element) => element.uid).toList();

    // 현재 사용자의 UID를 participantsUidList에 추가
    String currentUserUid = _authController.userInfo.value!.uid;
    if (!participantsUidList.contains(currentUserUid)) {
      participantsUidList.add(currentUserUid);
    }

    ChatRoom newRoom = ChatRoom(
      roomId: '',
      lastMessage: '',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      participantIdList: participantsUidList,
      city: '',
      dateRange: [],
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
    return roomId.value = docRef.id;
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

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }
}
