import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:tripin/controllers/home_controller.dart';
import 'package:tripin/service/kakao_service.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/service/db_service.dart';
import 'package:tripin/utils/app_screens.dart';

import '../model/chat_room_model.dart';
import 'chat/chat_list_controller.dart';

class AuthController extends GetxController {
  final Rxn<User> _user = Rxn<User>(); // FirebasAuth에 등록된 유저 정보
  Rxn<UserModel> userInfo = Rxn(); // Firebase Store에 등록된 로그인한 유저 정보

  @override
  void onInit() async {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        _user.value = user;
        await getUserInfo(user.uid); // 로그인이 확인되면 유저 정보 로드
      }
    });
  }

  User? get user => _user.value;

  Future<void> getUserInfo(String uid) async {
    userInfo(null);
    try {
      UserModel? res = await DBService().getUserInfoById(uid);
      if (res != null) {
        List<ChatRoom?> chatRoomList = await Get.find<ChatListController>()
            .readJoinedChatRoom(res.joinedRoomIdList);
        res.joinedTrip = chatRoomList;

        log('$res', name: 'getUserInfo :: res');
        log('$chatRoomList', name: 'getUserInfo :: chatRoomList');
        if (chatRoomList.isNotEmpty) {
          print(chatRoomList[0]!.dateRange);
        }
        await userInfo(res);
        print('userInfo.value: ${userInfo.value}');
      }
    } catch (error) {
      print("유저 정보 로딩 중 에러: $error");
    }
  }

  loginWithEmail(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await getUserInfo(FirebaseAuth.instance.currentUser!.uid);
    Get.offAllNamed(AppScreens.home);
  }

  signUp(String email, String password, String nickName) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? newUser = userCredential.user;

    UserModel userModel = UserModel(
      uid: newUser!.uid, // 이 부분을 수정
      email: email,
      nickName: nickName,
      imgUrl: '',
      isSelected: false,
      message: '',
      following: [],
      joinedRoomIdList: [],
    );

    await DBService().saveUserInfo(userModel);

    await getUserInfo(userModel.uid);
    Get.offAllNamed(AppScreens.home);
  }

  logOut() async {
    final HomeController _homeController = Get.find<HomeController>();
    _user.value = null;
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    // await kakao.UserApi.instance.logout();

    Get.offAllNamed(AppScreens.login);
    _homeController.curPage.value = 0;
    userInfo(null);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final user = userCredential.user;

    UserModel userModel = UserModel(
      uid: user!.uid,
      email: user.email!,
      nickName: user.displayName!,
      imgUrl: user.photoURL ?? '',
      isSelected: false,
      message: '',
      following: userInfo.value?.following ?? [],
      joinedRoomIdList: userInfo.value?.joinedRoomIdList ?? [],
    );

    await DBService().saveUserInfo(userModel);
    await getUserInfo(FirebaseAuth.instance.currentUser!.uid);
    Get.offAllNamed(AppScreens.home);

    // 로그인하면, UserCredential을 리턴한다
    return userCredential;
  }

  loginWithKakao() async {
    bool success = false;
    if (await kakao.isKakaoTalkInstalled()) {
      success = await tryLoginWithKakaoTalk();
    }

    if (!success) {
      success = await tryLoginWithKakaoAccount();
    }

    if (success) {
      Get.offAllNamed(AppScreens.home);
    }
  }

  Future<bool> tryLoginWithKakaoTalk() async {
    try {
      await kakao.UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공');
      await processLogin();
      return true;
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
      if (error is PlatformException && error.code == 'CANCELED') {
        return false;
      }
      return false;
    }
  }

  Future<bool> tryLoginWithKakaoAccount() async {
    try {
      await kakao.UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공');
      await processLogin();
      return true;
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
      return false;
    }
  }

  processLogin() async {
    // 카카오 로그인 후 사용자 정보를 받아옴
    kakao.User kakaoUser = await kakao.UserApi.instance.me();

    print(kakaoUser.id);
    print(kakaoUser.kakaoAccount!.email);

    // 사용자 정보를 기반으로 서버에서 커스텀 토큰을 받아옴
    KakaoService kakaoService = KakaoService();
    String customToken = await kakaoService.createCustomToken({
      'kakaoId': '${kakaoUser.id}',
      'kakaoEmail': '${kakaoUser.kakaoAccount?.email}',
      'kakaoPhotoURL': '${kakaoUser.kakaoAccount?.profile?.profileImageUrl}',
      'kakaoNickName': '${kakaoUser.kakaoAccount?.profile?.nickname}'
      // ... 다른 필요한 정보
    });
    print("서버로 부터 받은 토큰: $customToken");

    // customToken을 사용하여 Firebase Authentication에 사용자 등록
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCustomToken(customToken);
      await userCredential.user!.reload(); // 사용자 정보 갱신
      print("파이어베이스 로그인 후: ${FirebaseAuth.instance.currentUser}");
    } catch (error) {
      print("커스텀 토큰으로 파베에 등록에러: $error");
    }

    print('파베에 사용자 정보 저장시작');
    // 1. Firestore에서 해당 사용자의 정보를 가져옴
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    DocumentSnapshot userSnapshot = await userDocRef.get();

    // 2. 사용자 정보가 Firestore에 없는 경우만 저장
    if (!userSnapshot.exists) {
      await userDocRef.set({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'email': kakaoUser.kakaoAccount?.email,
        'nickName': kakaoUser.kakaoAccount?.profile?.nickname,
        'imgUrl': kakaoUser.kakaoAccount?.profile?.profileImageUrl ?? '',
        'isSelected': false,
        'message': '',
        'following': userInfo.value?.following ?? [],
        'joinedTrip': userInfo.value?.joinedTrip ?? [],
      });
      print('파베에 사용자 정보 저장완료');
    } else {
      print('이미 사용자 정보가 파베에 존재합니다.');
    }

    await getUserInfo(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<String?> getUserProfilePhotoUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload(); // 사용자 정보 업데이트
      await user.getIdToken(); // 사용자 토큰 업데이트
      return user.photoURL;
    }
  }
}
