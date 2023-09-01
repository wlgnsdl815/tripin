import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tripin/utils/app_screens.dart';

class AuthController extends GetxController {
  final Rxn<User> _user = Rxn<User>();
  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        Get.offAllNamed(AppScreens.home);

        _user.value = user;
        // print(FirebaseAuth.instance.currentUser);
        // print(_user.value);
        return;
      }
      Get.offAllNamed(AppScreens.login);
    });
  }

  loginWithEmail(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // FirebaseAuth에서 받은 유저를 Firebase Storage에 올리는 건 나중에 수정
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'email': email,
    });
  }

  signUp(String email, String password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
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

    // 구글 아이디를 FireStore에 올리는 것도 나중에 수정
    await FirebaseFirestore.instance.collection('user').doc(user!.uid).set({
      'email': user.email,
      'uid': user.uid,
      'nickName': user.displayName,
    });

    // Once signed in, return the UserCredential
    return userCredential;
  }
}
