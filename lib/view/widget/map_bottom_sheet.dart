import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/map/map_screen_controller.dart';
import 'package:tripin/model/marker_model.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';

class MapBottomSheet extends GetView<MapScreenController> {
  const MapBottomSheet({super.key});

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
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
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
                      Divider(),
                      // 일정탭의 버튼
                      // SizedBox(
                      //   height: 50.0, // 원하는 높이로 조절
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: controller.dateRange.isEmpty
                      //         ? 1
                      //         : controller.dateRange.length,
                      //     itemBuilder: (context, index) {
                      //       if (controller.dateRange.isEmpty) {
                      //         return Text('날짜를 선택해주세요');
                      //       }
                      //       return ElevatedButton(
                      //         onPressed: () {
                      //           controller.onDayButtonTap(
                      //               index: index);
                      //           print(controller.selectedDayIndex);
                      //           Get.back();
                      //         },
                      //         child: Text('Day ${index + 1}'),
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                );
              }
              MarkerModel marker = controller.currentDayMarkers[index - 1];
              print(controller.currentDayMarkers);

              print(marker.userNickName);
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Text(
                            marker.order.toString(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                '${marker.title}',
                                style: AppTextStyle.header20(),
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
                        ),
                      ],
                    ),
                    Text(
                      controller.placeText.value,
                      style: AppTextStyle.body15M(
                        color: PlatformColors.subtitle3,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('장소 메모'),
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
                              return Text('작성된 메모가 없습니다.');
                            } else {
                              return Container(
                                color: Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...updatedMarker.descriptions
                                          .where(
                                              (desc) => desc.trim().isNotEmpty)
                                          .map((desc) => Text(desc))
                                          .toList(),
                                      Text(updatedMarker.userNickName),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: '메모',
                              content: TextField(
                                controller:
                                    controller.descriptionTextController,
                                decoration: InputDecoration(
                                  hintText: '메모를 입력하세요',
                                ),
                              ),
                              cancel: TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('취소'),
                              ),
                              confirm: TextButton(
                                onPressed: () {
                                  controller.upDateAndGetDescription(marker.id);
                                  Get.back();
                                },
                                child: Text('저장'),
                              ),
                            );
                          },
                          child: Text('메모 추가'),
                        ),
                      ],
                    ),
                  ]);
            },
          ),
        );
      },
    );
  }
}
