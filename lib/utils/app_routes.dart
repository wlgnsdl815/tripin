import 'package:get/get.dart';
import 'package:tripin/utils/app_screens.dart';
import 'package:tripin/view/screens/home_screen.dart';
import 'package:tripin/view/screens/login_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: AppScreens.home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: AppScreens.login,
      page: () => LoginScreen(),
    ),
  ];
}
