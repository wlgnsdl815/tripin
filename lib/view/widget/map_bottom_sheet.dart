import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/map/map_screen_controller.dart';
import 'package:tripin/model/marker_model.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/widget/custom_button.dart';

class MapBottomSheet extends GetView<MapScreenController> {
  const MapBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6, // 초기 크기를 60%로 설정
      maxChildSize: 0.9, // 최대 크기를 90%로 설정
      snap: true,
      snapSizes: [0.6, 0.9],
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          height:
              MediaQuery.of(context).size.height * 0.6, // 바텀시트 최소 크기를 맞춰야한다.
          child: ListView.builder(
            controller: scrollController,
            itemCount: controller.currentDayMarkers.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 13),
                      child: Container(
                        width: 36.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: PlatformColors.subtitle7,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '여행 코스',
                          style: AppTextStyle.body15M(),
                        ),
                        SizedBox(width: 3.w),
                        Container(
                          width: 45.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: PlatformColors.subtitle8,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Center(
                            child: Text(
                              'Day ${controller.selectedDayIndex.value + 1}',
                              style: AppTextStyle.body12M(
                                  color: PlatformColors.subtitle2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              MarkerModel marker = controller.currentDayMarkers[index - 1];
              print(controller.currentDayMarkers);

              print(marker.userNickName);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.9),
                            color:
                                PinColor.colors[marker.order % 10]!.withOpacity(
                              0.1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 9.w,
                              vertical: 2.h,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/pins/Vector.png',
                                  width: 11.w,
                                  height: 11.h,
                                  color: PinColor.colors[marker.order % 10]!,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  '${marker.order}',
                                  style: AppTextStyle.body15M(
                                    color: PinColor.colors[marker.order % 10]!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            '${marker.title}',
                            style: AppTextStyle.header20(),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            '장소삭제',
                            style: AppTextStyle.body14M(
                              color: PlatformColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      marker.subTitle,
                      style: AppTextStyle.body15M(
                        color: PlatformColors.subtitle3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Divider(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '장소 메모',
                          style: AppTextStyle.body15M(),
                        ),
                        SizedBox(height: 11.h),
                        Obx(
                          () {
                            MarkerModel updatedMarker =
                                controller.currentDayMarkers.firstWhere(
                              (m) => m.id == marker.id,
                              orElse: () => marker,
                            );

                            // 메모가 있는 경우와 없는 경우를 분리
                            if (updatedMarker.descriptions
                                .where((desc) => desc.trim().isNotEmpty)
                                .isEmpty) {
                              return Text(
                                '아직 작성된 메모가 없습니다.',
                                style: AppTextStyle.body13M(
                                    color: PlatformColors.subtitle4),
                              );
                            } else {
                              return Container(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 11.h),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: updatedMarker.descriptions.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: PlatformColors.subtitle8,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 10.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              updatedMarker.descriptions[index],
                                              style: AppTextStyle.body14M(),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              updatedMarker.userNickName,
                                              style: AppTextStyle.body13M(
                                                  color:
                                                      PlatformColors.subtitle2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.dialog(
                              Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/pins/Vector.png',
                                            width: 11.w,
                                            height: 11.h,
                                            color: PinColor
                                                .colors[marker.order % 10]!,
                                          ),
                                          SizedBox(width: 2.w),
                                          Text(
                                            '${marker.order}',
                                            style: AppTextStyle.body15M(
                                              color: PinColor
                                                  .colors[marker.order % 10]!,
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          Text(
                                            '메모',
                                            style: AppTextStyle.body15M(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 19),
                                      Text(
                                        marker.title,
                                        style: AppTextStyle.body16M(),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: PlatformColors.subtitle7,
                                      ),
                                      Text(
                                        marker.subTitle,
                                        style: AppTextStyle.body11M(
                                          color: Color(0xff585858),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      TextField(
                                        maxLines: 5,
                                        controller: controller
                                            .descriptionTextController,
                                        decoration: InputDecoration(
                                          fillColor: PlatformColors.subtitle8,
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                              color: PlatformColors.primary,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                              color: PlatformColors.subtitle7,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          hintText: '메모를 추가할 수 있어요!',
                                          hintStyle: TextStyle(
                                              color: PlatformColors.subtitle4),
                                          suffixIconConstraints:
                                              BoxConstraints(maxHeight: 30),
                                        ),
                                      ),
                                      SizedBox(height: 13),
                                      Center(
                                        child: CustomButton(
                                          onTap: () {
                                            controller.upDateAndGetDescription(
                                                marker.id);
                                            Get.back();
                                          },
                                          text: '등록',
                                          textPadding: EdgeInsets.symmetric(
                                            horizontal: 48,
                                          ),
                                          textStyle: AppTextStyle.body12M(
                                            color: Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Text(
                              '메모 추가',
                              style: AppTextStyle.body12M(
                                color: PlatformColors.title,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: BorderSide(color: PlatformColors.subtitle7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
