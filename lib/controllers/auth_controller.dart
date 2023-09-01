import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tripin/utils/app_screens.dart';

class AuthController extends GetxController {
  Rxn<User> _user = Rxn<User>();
  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        Get.toNamed(AppScreens.home);
        print(FirebaseAuth.instance.currentUser);
        return;
      }
      Get.toNamed(AppScreens.login);
    });
  }

  loginWithEmail(String email, String password) {}
  signUp(String email, String password) {
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  logOut() {
    FirebaseAuth.instance.signOut();
  }
}
