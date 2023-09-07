import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';

import 'package:tripin/controllers/edit_profile_controller.dart';
import 'package:tripin/model/user_model.dart';

// enum SearchState {
//   Idle, // 검색하지 않은 상태
//   Searching, // 검색 중인 상태
//   SearchResult, // 검색 결과가 있는 상태
//   NoResult, // 검색 결과가 없는 상태
// }

class FriendController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Rxn<UserModel> friendUser = Rxn<UserModel>(null);
  Rx<User> get user => Get.find<AuthController>().user!.obs;
  final AuthController authController = Get.find<AuthController>();
  TextEditingController searchController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  final EditProfileController editProfileController =
      Get.find<EditProfileController>();// Rx<SearchState> searchState = Rx<SearchState>(SearchState.Idle);

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
  }

  void clearSearchResults() {
    friendUser.value = null;
    // searchState.value = SearchState.Idle;
    searchController.clear();
    update();
  }

//   Future<void> searchFriendByEmail() async {
//     // 검색 중 상태로 설정
//     searchState.value = SearchState.Searching;

//     final nickNameToSearch = searchController.text;

//     // Firebase에서 사용자 검색
//     final friendUser = await searchUserByEmail(nickNameToSearch);

//     if (friendUser != null) {
//       // 사용자를 찾은 경우
//       showUserDialog(friendUser.email);
//       searchState.value = SearchState.SearchResult;
//       print('결과 찾음');
//     } else {
//       // 사용자를 찾지 못한 경우
//       searchState.value = SearchState.NoResult;
//       print('결과 못 찾음');
//     }
//   }

  searchFriendByEmail() async {
    final nickNameToSearch = searchController.text;

    // Firebase에서 사용자 검색
    final friendUser = await searchUserByEmail(nickNameToSearch);

    if (friendUser != null) {
      // 사용자를 찾은 경우
      showUserDialog(friendUser.email);
      showUserList(friendUser.email);
    } else {
      // 사용자를 찾지 못한 경우 아무것도 하지 않습니다.
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
              onPressed: () {
              },
              child: Text(userEmail),
            );
          },
        );
      },
    );
  }
  void showUserList(String userEmail) async{
        final nickNameToSearch = searchController.text;

    final friendUser = await searchUserByEmail(nickNameToSearch);
    ListView.builder(
      itemBuilder: (context, builder){
        return 
        Row(
          children: [
            AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(37),
                            color: Colors.grey),
                      ),
                    ),
                  ),
            Text(friendUser!.email)
          ],
        );
      } );
      
    }
  
}