import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tripin/controllers/calendar_controller.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';
import 'package:tripin/view/widget/custom_checklist.dart';

class EventDetailPage extends GetView<CalendarController> {
  const EventDetailPage({super.key});
  static const route = '/eventDetail';

  @override
  Widget build(BuildContext context) {
    var city = Get.arguments['city'];
    List<DateTime> dateRange = Get.arguments['dateRange'];
    DateTime startDate = dateRange.first;
    DateTime endDate = dateRange.last;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: PlatformColors.subtitle,
        elevation: 0,
        title: Text(
          '이벤트 세부사항',
          style: AppTextStyle.header18(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.showAddChecklistDialog(context);
            },
            child: Text('편집'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   height: MediaQuery.of(context).size.height / 18,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(18),
            //     color: Colors.amber,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/location2.png',
                    height: 13.h,
                    width: 10.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    city,
                    style: AppTextStyle.body11M(
                      color: PlatformColors.subtitle2,
                    ),
                  ),
                  Text(
                    ' • ${DateFormat('y.MM.dd').format(startDate)} - ${DateFormat('MM.dd').format(endDate)}',
                    style: AppTextStyle.body11M(
                      color: PlatformColors.subtitle2,
                    ),
                  ),
                ],
              ),
            ),
            // Divider(
            //   thickness: 1,
            //   color: Colors.grey,
            //   indent: 10,
            //   endIndent: 10,
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 8, right: 8),
            //   child: Row(
            //     children: [
            //       Text(
            //         '이벤트 색상',
            //         style: AppTextStyle.body13B(),
            //       ),
            //     ],
            //   ),
            // ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 25, top: 23),
              child: Text(
                '체크리스트',
                style: AppTextStyle.body13B(),
              ),
            ),
           Obx(() {
              final checkLists = controller.checkLists;
              final checklistKeys = checkLists.keys.toList();

              return Column(
                children: checklistKeys.map((item) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: CustomCheckList(
                          itemName: item,
                          isChecked: checkLists[item],
                          onChanged: (bool? newValue) {
                            // 체크 박스 상태 변경
                            if (newValue != null) {
                              // 여기에서 체크리스트 항목 상태를 업데이트하고,
                              // 상태에 따라 스타일을 변경할 수 있습니다.
                              controller.checkLists[item] = newValue;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                }).toList(),              );
            })
          ],
        ),
      ),
    );
  }
}
