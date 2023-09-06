import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/home_controller.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/model/user_model.dart';

class SelectFriendsController extends GetxController {
  RxList<UserModel> userData = <UserModel>[].obs;
  RxList<String> participants =
      <String>[FirebaseAuth.instance.currentUser!.uid].obs;
  RxString roomId = ''.obs;
  final HomeController homeController = Get.find<HomeController>();

  getUsers() async {
    final tempUsersData = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('user').get();

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
    print('현재 유저: ${homeController.userInfo.value!.uid}');
    print('참가자: $participants');
    final firestoreInstance = FirebaseFirestore.instance;

    ChatRoom newRoom = ChatRoom(
      roomId: '', // 초기에는 빈 문자열 또는 null을 할당
      lastMessage: '',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      participants: participants.toList(), // ObxList를 List로 변환하여 저장
    );

    // 새로운 채팅방 추가
    DocumentReference docRef =
        await firestoreInstance.collection("chatRooms").add(newRoom.toMap());

    // 룸 아이디를 doc 아이디로 업데이트
    await docRef.update({
      'roomId': docRef.id,
    });

    return roomId.value = docRef.id;
  }

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }
}
