// ignore_for_file: prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/calendar_controller.dart';
import 'package:tripin/controllers/chat/chat_controller.dart';
import 'package:tripin/controllers/chat/chat_list_controller.dart';
import 'package:tripin/controllers/chat/chat_setting_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/controllers/edit_profile_controller.dart';
import 'package:tripin/controllers/friend_controller.dart';
import 'package:tripin/controllers/global_getx_controller.dart';
import 'package:tripin/controllers/login_controller.dart';
import 'package:tripin/controllers/map/map_screen_controller.dart';
import 'package:tripin/controllers/profile_detail_controller.dart';
import 'package:tripin/firebase_options.dart';
import 'package:tripin/utils/api_keys_env.dart';
import 'package:tripin/utils/app_routes.dart';
import 'package:tripin/utils/app_screens.dart';
import 'controllers/home_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  KakaoSdk.init(
    nativeAppKey: Env.kakaoNativeKey,
    javaScriptAppKey: Env.kakaoJSKey,
  );

  await NaverMapSdk.instance.initialize(
      clientId: Env.naverMapClientId,
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      });
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        theme: ThemeData(fontFamily: "Pretendard"),
        initialBinding: BindingsBuilder(() {
          Get.put(AuthController());
          Get.put(GlobalGetXController(), permanent: true);
          Get.lazyPut(() => LoginController(), fenix: true);
          Get.lazyPut(() => EditProfileController(), fenix: true);
          Get.lazyPut(() => FriendController(), fenix: true);
          Get.lazyPut(() => SelectFriendsController(), fenix: true);
          Get.lazyPut(() => ChatController(), fenix: true);
          Get.lazyPut(() => ChatListController(), fenix: true);
          Get.lazyPut(() => MapScreenController(), fenix: true);
          Get.lazyPut(() => CalendarController(), fenix: true);
          Get.lazyPut(() => HomeController(), fenix: true);
          Get.lazyPut(() => ProfileDetailController(), fenix: true);
          Get.lazyPut(() => ChatSettingController(), fenix: true);
        }),
        getPages: AppRoutes.routes,
        initialRoute: AppScreens.splash,
      ),
    );
  }
}
