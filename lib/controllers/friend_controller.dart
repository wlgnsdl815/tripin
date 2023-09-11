// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tripin/controllers/auth_controller.dart';
// import 'package:tripin/model/user_model.dart';
// import 'package:tripin/view/screens/friend_screen.dart';

// class FriendController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Rxn<UserModel> friendUser = Rxn<UserModel>(null);
//   TextEditingController searchController = TextEditingController();
//   RxList<UserModel> friends = RxList<UserModel>([]);

//   Future<UserModel?> searchUserByEmail(String email) async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore
//           .collection('user')
//           .where('email', isEqualTo: email)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         final userData =
//             querySnapshot.docs.first.data() as Map<String, dynamic>;
//         final user = UserModel.fromMap(userData);
//         friendUser.value = user;
//       } else {
//         print('일치하는 사용자를 찾을 수 없습니다. 이메일: $email');
//         friendUser.value = null;
//       }
//       update();
//     } catch (error) {
//       print('검색 오류 발생: $error');
//       friendUser.value = null;
//       update();
//     }
//   }

//   void clearSearchResults() {
//     friendUser.value = null;
//     searchController.clear();
//     update();
//   }

//   searchFriendByEmail() async {
//     final nickNameToSearch = searchController.text;

//     final friendUser = await searchUserByEmail(nickNameToSearch);

//     if (friendUser != null) {
//       showUserDialog(friendUser.email);
//       showUserList(friendUser.email);
//     } else {
//       // 사용자를 찾지 못한 경우 아무것도 하지 않습니다.
//     }
//   }

//   void showUserDialog(String userEmail) {
//     showDialog(
//       context: Get.context!,
//       builder: (BuildContext context) {
//         return ListView.builder(
//           itemCount: 1,
//           itemBuilder: (context, builder) {
//             return ElevatedButton(
//               onPressed: () {},
//               child: Text(userEmail),
//             );
//           },
//         );
//       },
//     );
//   }

//   showUserList(String userEmail) async {
//     final nickNameToSearch = searchController.text;

//     final friendUser = await searchUserByEmail(nickNameToSearch);

//     if (friendUser != null) {
//       // 이메일을 누르면 FriendScreen으로 이동
//       Get.toNamed(FriendScreen.route, arguments: {'friend': friendUser});
//     } else {
//       // 사용자를 찾지 못한 경우 아무것도 하지 않습니다.
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/edit_profile_controller.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/service/db_service.dart';
import 'package:tripin/view/screens/friend_screen.dart';

// enum SearchState {
//   Idle, // 검색하지 않은 상태
//   Searching, // 검색 중인 상태
//   SearchResult, // 검색 결과가 있는 상태
//   NoResult, // 검색 결과가 없는 상태
// }

class FriendController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Rxn<UserModel> friendUser = Rxn<UserModel>(null);
  RxList<UserModel>followingList = <UserModel>[].obs;
  Rx<User> get user => Get.find<AuthController>().user!.obs;
  final AuthController authController = Get.find<AuthController>();
  TextEditingController searchController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  RxList<UserModel> friends = RxList<UserModel>([]);
  final EditProfileController editProfileController = Get.find<
      EditProfileController>(); 
      // Rx<SearchState> searchState = Rx<SearchState>(SearchState.Idle);

  Future<UserModel?> searchUserByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        final user = UserModel.fromMap(userData);
        friendUser.value = user; // friendUser 값을 변경
      } else {
        print('일치하는 사용자를 찾을 수 없습니다. 이메일: $email');
        friendUser.value = null;
      }
      update();
    } catch (error) {
      print('검색 오류 발생: $error');
      friendUser.value = null;
      update();
    }
    return null;
  }

  void clearSearchResults() {
    friendUser.value = null;
    // searchState.value = SearchState.Idle;
    searchController.clear();
    update();
  }

  void searchFriendByEmail() async {
    final nickNameToSearch = searchController.text;
    final friendUser = await searchUserByEmail(nickNameToSearch);
    if (friendUser != null) {
      showUserDialog(friendUser.email);
      showUserList(friendUser.email);
    } else {
    }
  }

  void showUserDialog(String userEmail) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, builder) {
            return ElevatedButton(
              onPressed: () {},
              child: Text(userEmail),
            );
          },
        );
      },
    );
  }

 void addFriend(UserModel friend) {
  FirebaseFirestore.instance
  .collection('user')
  .doc(FirebaseAuth.instance.currentUser!.uid)
  .update({'following':FieldValue.arrayUnion([friend.uid])});
   final isAlreadyAdded = friends.any((existingFriend) =>
      existingFriend.email == friend.email);
      if (!isAlreadyAdded) {
    friends.add(friend);
    // 친구를 추가한 후에 친구 목록을 저장하려면 여기에 저장 로직 추가
    // saveFriends();
    update();
  } else {
  final snackBar = SnackBar(
      content: Text('이미 추가된 친구입니다.'),
    );

    // ScaffoldMessenger로 SnackBar를 표시
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }  
    // if (!friends.contains(friend)) {
    //   friends.add(friend);
    //   update();
    // }
  }

//    void saveFriends() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> friendList = friends.map((friend) => friend.toJson()).toList();
//     await prefs.setStringList('friends', friendList);
//   }

 void   getFollowing() async {
  await authController.getUserInfo(FirebaseAuth.instance.currentUser!.uid);
    var uidList = authController.userInfo.value!.following;
    List<UserModel> following = [];
    for (var uid in uidList) {
      var userInfo = await DBService().getUserInfoById(uid);
      following.add(userInfo);
    }
    followingList(following);
    print('$followingList');
    
  }


  Future<String?> getFriendImage(String email) async {
    try {
      // Firestore에서 사용자 문서를 가져옵니다.
      final userDoc = await _firestore.collection('user').doc(email).get();

      if (userDoc.exists) {
        // 사용자 문서에서 이미지 URL 필드를 가져옵니다.
        final imageUrl = userDoc.get('imageUrl');

        if (imageUrl != null && imageUrl.isNotEmpty) {
          // 이미지 URL이 있는 경우 반환합니다.
          return imageUrl;
        }
      }
      return null; // 이미지 URL을 찾지 못한 경우 null 반환
    } catch (e) {
      print('이미지 URL 가져오기 오류: $e');
      return null;
    }
  }
  

  void showUserList(String userEmail) async {
    final nickNameToSearch = searchController.text;

    final friendUser = await searchUserByEmail(nickNameToSearch);

    if (friendUser != null) {
      addFriend(friendUser);
      Get.toNamed(FriendScreen.route, arguments: {'friend': friendUser});
    } else {
    }
  }
   @override
  void onInit() {
    super.onInit();
    // 앱 시작 시 저장된 친구 목록을 읽어옴
    getFollowing();
  }
  }
