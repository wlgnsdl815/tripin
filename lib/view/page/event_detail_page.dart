import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tripin/controllers/calendar_controller.dart';
import 'package:tripin/controllers/chat/chat_list_controller.dart';
import 'package:tripin/controllers/map/map_screen_controller.dart';
import 'package:tripin/utils/colors.dart';
import 'package:tripin/utils/text_styles.dart';

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
        actions: [TextButton(onPressed: () {
          
        }, child: Text('편집'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 18,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18), color: Colors.amber),
            ),
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
                  // Obx(() => Text(city)),
                  Text(
                    ' • ${DateFormat('y.MM.dd').format(startDate)} - ${DateFormat('MM.dd').format(endDate)}',
                    style: AppTextStyle.body11M(
                      color: PlatformColors.subtitle2,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  Text(
                    '이벤트 색상',
                    style: AppTextStyle.body13B(),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              indent: 10,
              endIndent: 10,
            ),
            Text(
              '체크리스트',
              style: AppTextStyle.body13B(),
            )
          ],
        ),
      ),
    );
  }
}
