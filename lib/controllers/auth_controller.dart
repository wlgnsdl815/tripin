import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:tripin/service/kakao_service.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/service/db_service.dart';
import 'package:tripin/utils/app_screens.dart';

class AuthController extends GetxController {
  final Rxn<User> _user = Rxn<User>(); // FirebasAuth에 등록된 유저 정보
  Rxn<UserModel> userInfo = Rxn(); // Firebase Store에 등록된 로그인한 유저 정보

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _user.value = user;
        getUserInfo(user.uid); // 로그인이 확인되면 유저 정보 로드
        Get.offAllNamed(AppScreens.home);
      } else {
        Get.offAllNamed(AppScreens.login);
      }
    });
  }

  User? get user => _user.value;

  Future<void> getUserInfo(String uid) async {
    userInfo(null);
    try {
      UserModel? res = await DBService().getUserInfoById(uid);
      if (res != null) {
        log('$res', name: 'getUserInfo :: res');
        userInfo(res);
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
    );

    await DBService().saveUserInfo(userModel);

    await getUserInfo(userModel.uid);
  }

  logOut() async {
    _user.value = null;
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await kakao.UserApi.instance.logout();
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
      following: [],
    );

    await DBService().saveUserInfo(userModel);
    await getUserInfo(FirebaseAuth.instance.currentUser!.uid);

    // 로그인하면, UserCredential을 리턴한다
    return userCredential;
  }

  loginWithKakao() async {
    if (await kakao.isKakaoTalkInstalled()) {
      bool success = await tryLoginWithKakaoTalk();
      if (!success) {
        await tryLoginWithKakaoAccount();
      }
    } else {
      await tryLoginWithKakaoAccount();
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

    // Firestore에 사용자 정보 저장
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'email': kakaoUser.kakaoAccount?.email,
      'nickName': kakaoUser.kakaoAccount?.profile?.nickname,
      'imgUrl': kakaoUser.kakaoAccount?.profile?.profileImageUrl ?? '',
      'isSelected': false,
      'message': '',
      'following': [],
    });
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
