// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../controllers/auth_controller.dart';
// import 'calendar_screen.dart';
// import 'chat/chat_list_screen.dart';
// import 'chat/select_friends_screen.dart';
// import 'edit_profile_screen.dart';
// import 'friend_screen.dart';

// class MyPageScreen extends StatelessWidget {
//   const MyPageScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     AuthController authController = Get.find<AuthController>();
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               authController.logOut();
//             },
//             child: Text('로그아웃'),
//           ),
//           Obx(
//                 () => Container(
//               width: Get.width * 0.5,
//               height: Get.width * 0.5,
//               child: Image.network(
//                   authController.userInfo.value?.imgUrl.isEmpty ?? true
//                       ? 'http://picsum.photos/100/100'
//                       : authController.userInfo.value!.imgUrl),
//             ),
//           ),
//           Obx(() => Text(authController.userInfo.value != null
//               ? authController.userInfo.value!.nickName
//               : '이름: null')),
//           Obx(() => Text(authController.userInfo.value != null
//               ? authController.userInfo.value!.message
//               : '메세지: null')),
//           ElevatedButton(
//             onPressed: () {
//               Get.to(() => EditProfileScreen());
//             },
//             child: Text('프로필 수정'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Get.to(() => SelectFriendsScreen());
//             },
//             child: Text('채팅방 만들기'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Get.to(() => ChatListScreen());
//             },
//             child: Text('채팅방 목록'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Get.to(() => FriendScreen());
//             },
//             child: Text('친구 목록'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Get.to(() => CalendarScreen());
//             },
//             child: Text('캘린더'),
//           ),

//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/screens/find_pw_screen.dart';
import 'package:tripin/view/widget/app_my_list.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});
static const route = '/myPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          '마이페이지',
          style: AppTextStyle.header15(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 18,
            decoration: BoxDecoration(color: PlatformColors.primary),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '앱 설정',
                style: AppTextStyle.body12B(color: PlatformColors.subtitle8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: MyList(
              onPressed: () => Get.to(() => FindPwScreen()),
              text: '비밀번호 변경', ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 18,
            decoration: BoxDecoration(color: PlatformColors.primary),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '정보',
                style: AppTextStyle.body12B(color: PlatformColors.subtitle8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: MyList(
              onPressed: (){},
              text: '이용약관'),
          ),
            Divider(
              indent: 20,
              endIndent: 20,
              color: PlatformColors.subtitle3 ,
            ),
                      MyList(
            onPressed: (){},
            text: '버전'),
            Divider(
              indent: 20,
              endIndent: 20,
              color: PlatformColors.subtitle3 ,
            ),
                      MyList(
            onPressed: (){ Get.find<AuthController>().logOut();},
            text: '로그아웃'),
            Divider(
              indent: 20,
              endIndent: 20,
              color: PlatformColors.subtitle3 ,
            )


        ],
      ),
    );
  }
}
