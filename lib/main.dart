// ignore_for_file: prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/home_controller.dart';
import 'package:tripin/controllers/login_controller.dart';
import 'package:tripin/firebase_options.dart';
import 'package:tripin/utils/api_keys_env.dart';
import 'package:tripin/utils/app_routes.dart';
import 'package:tripin/utils/app_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  KakaoSdk.init(
    nativeAppKey: '${Env.kakaoNativeKey}',
    javaScriptAppKey: '${Env.kakaoJSKey}',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.lazyPut(() => LoginController(), fenix: true);
        Get.lazyPut(() => HomeController(), fenix: true);
      }),
      getPages: AppRoutes.routes,
      initialRoute: AppScreens.login,
    );
  }
}
