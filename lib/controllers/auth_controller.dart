import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:tripin/model/user_model.dart';
import 'package:tripin/service/db_service.dart';
import 'package:tripin/utils/app_screens.dart';
import 'package:tripin/view/screens/friend_screen.dart';

import 'home_controller.dart';

class AuthController extends GetxController {
  final Rxn<User> _user = Rxn<User>();
  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        Get.offAllNamed(FriendScreen.route);

        _user.value = user;
        // print(FirebaseAuth.instance.currentUser);
        // print(_user.value);
        return;
      }
      Get.offAllNamed(AppScreens.login);
    });
  }

 User? get user => _user.value;

  loginWithEmail(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    Get.find<HomeController>().getUserInfo();
  }

  signUp(String email, String password, String nickName) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    UserModel userModel = UserModel(
      uid: FirebaseAuth.instance.currentUser!.uid,
      email: email,
      nickName: nickName,
      imgUrl: ''
    );

    await DBService().saveUserInfo(userModel);

    Get.find<HomeController>().getUserInfo();
  }

  logOut() async {
    await FirebaseAuth.instance.signOut();
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
      imgUrl: user.photoURL ?? ''
    );

    await DBService().saveUserInfo(userModel);

    Get.find<HomeController>().getUserInfo();

    // Once signed in, return the UserCredential
    return userCredential;
  }

  loginWithKakao() async {
    // 카카오 로그인 구현 예제

    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await kakao.isKakaoTalkInstalled()) {
      try {
        await kakao.UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await kakao.UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await kakao.UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }
}
