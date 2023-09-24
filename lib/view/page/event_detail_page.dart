import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    controller.readCity();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: PlatformColors.subtitle,
        elevation: 0,
        title: Text(
          '이벤트 세부사항',
          style: AppTextStyle.header18(),
        ),
        actions: [TextButton(onPressed: () {}, child: Text('편집'))],
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
                  Icon(Icons.location_on_outlined, color: PlatformColors.subtitle2,),
                  Obx(() => Text('${controller.selectedCity}',)),
                  Text(Get.find<CalendarController>().dateRange.toString()),
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
