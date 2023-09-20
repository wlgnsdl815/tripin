import 'package:tripin/view/page/event_detail_page.dart';
import 'package:tripin/view/page/find_friend_page.dart';
import 'package:tripin/view/screens/calendar_screen.dart';
import 'package:tripin/view/screens/chat/chat_screen.dart';
import 'package:tripin/view/screens/chat/chat_setting_screen.dart';
import 'package:tripin/view/screens/chat/map_screen.dart';
import 'package:tripin/view/screens/chat/select_friends_screen.dart';
import 'package:tripin/view/screens/friend_screen.dart';
import 'package:tripin/view/screens/home_screen.dart';
import 'package:tripin/view/screens/login_screen.dart';

class AppScreens {
  static const home = HomeScreen.route;
  static const login = LoginScreen.route;
  static const friend = FriendScreen.route;
  static const findFriend = FindFriendPage.route;
  static const calender = CalendarScreen.route;
  static const eventDetail = EventDetailPage.route;

  static const chat = ChatScreen.route;
  static const map = MapScreen.route;
  static const chatSetting = ChatSettingScreen.route;
  static const selectFriends = SelectFriendsScreen.route;
}
