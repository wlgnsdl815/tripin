import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sfac_design_flutter/sfac_design_flutter.dart';
import 'package:tripin/controllers/auth_controller.dart';
import 'package:tripin/controllers/profile_detail_controller.dart';
import 'package:tripin/model/user_model.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/widget/profile_trip_tile.dart';

import '../../model/chat_room_model.dart';
import '../../utils/colors.dart';

class ProfileDetailScreen extends GetView<ProfileDetailController> {
  const ProfileDetailScreen({Key? key, required this.userModel})
      : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.filterIdx(0);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(
            Get.find<AuthController>().userInfo.value!.uid == userModel.uid
              ? '내 프로필'
              : '친구 프로필',
            style: AppTextStyle.body16B(color: Colors.white)),
          centerTitle: true,
          actions: userModel.uid == Get.find<AuthController>().userInfo.value!.uid
            ? [
              TextButton(
                onPressed: () {},
                child: Text('편집',
                  style: AppTextStyle.body14R(color: Colors.white)
                )
              ),
            ]
            : null,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile_detail_bg.png'),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 86, left: 24, right: 24),
                    child: Column(
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: userModel.imgUrl == ''
                            ? Image.asset('assets/icons/chat_default.png', width: 84)
                            : Image.network('${userModel.imgUrl}', width: 84),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '${userModel.nickName}',
                          style: AppTextStyle.header20(color: Colors.white),
                        ),
                        SizedBox(height: 14),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                          decoration: BoxDecoration(
                            color: PlatformColors.primaryLight.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              userModel.message == ''
                                  ? '상태메세지 없음'
                                  : '${userModel.message}',
                              style: AppTextStyle.body14M(
                                  color: Colors.white.withOpacity(
                                      userModel.message == '' ? 0.5 : 1)),
                            ),
                          ),
                        ),
                        SizedBox(height: 18),
                      ],
                    ),
                  )),
              // 내 여행 기록 리스트
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => controller.ongoingTrips.length > 0
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: PlatformColors.secondary,
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: Text('NOW',
                                    style: AppTextStyle.body12B(color: Colors.white)
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '현재 진행중인 여행이 있어요',
                                  style: AppTextStyle.body14B(),
                                ),
                              ],
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(controller.ongoingTrips.length, (index) {
                                  ChatRoom trip = controller.ongoingTrips[index]!;
                                  return Padding(
                                    padding: EdgeInsets.only(top: 10, bottom: 25),
                                    child: ProfileTripTile(trip: trip, isOngoing: true),
                                  );
                                }),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                    ),
                    Text(
                      '내 여행 기록',
                      style: AppTextStyle.body16B(),
                    ),
                    SizedBox(height: 12),
                    Obx(
                      () => Row(
                        children: List.generate(
                          controller.filterOptionList.length,
                          (index) => GestureDetector(
                            onTap: () {
                              controller.filterIdx(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: controller.filterIdx == index
                                    ? PlatformColors.subtitle2
                                    : Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  border: controller.filterIdx == index
                                    ? null
                                    : Border.all(color: PlatformColors.subtitle6)),
                                child: Text(
                                  '${controller.filterOptionList[index]} ${controller.filterOptionList[index] == '예정' ? controller.upcomingTrips.length : controller.completedTrips.length}',
                                  style: AppTextStyle.body14B(
                                      color: controller.filterIdx == index
                                          ? Colors.white
                                          : PlatformColors.subtitle),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Obx(
                      () => controller.isLoading.value ? Center(child: SFLoadingSpinner())
                      : ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.filterIdx == 0
                          ? controller.upcomingTrips.length
                          : controller.completedTrips.length,
                        itemBuilder: (context, index) {
                          return ProfileTripTile(
                            trip: controller.filterIdx == 0
                              ? controller.upcomingTrips[index]!
                              : controller.completedTrips[index]!,
                            isOngoing: false
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(height: 15),
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
