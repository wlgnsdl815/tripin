import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sfac_design_flutter/widgets/alertDialog/alert_dialog.dart';
import 'package:sfac_design_flutter/widgets/datepicker/calendar.dart';
import 'package:sfac_design_flutter/widgets/datepicker/date_picker.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';
import 'package:tripin/controllers/global_getx_controller.dart';
import 'package:tripin/controllers/map/map_screen_controller.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final MapScreenController _mapScreenController =
        Get.find<MapScreenController>();
    final SelectFriendsController _selectFriendsController =
        Get.find<SelectFriendsController>();
    final GlobalGetXController _globalGetXController =
        Get.find<GlobalGetXController>();
    print('_globalGetXController.roomId: ${_globalGetXController.roomId}');
    return Obx(
      () => SFDatePicker(
        key: ValueKey(_mapScreenController.dateRangeFromFirebase.value),
        initialDateRange: _mapScreenController.dateRangeFromFirebase.value,
        type: SFCalendarType.range,
        todayMark: true,
        getSelectedDate: (start, end, selectedDateList, selectedOne) {
          // print(controller.dateRange.isNotEmpty);
          // print(controller.dateRange.first);
          if (start != null && end != null) {
            if (_mapScreenController.dateRange.isNotEmpty) {
              alertDialog(
                context,
                title: '일정를 변경 하시겠습니까?',
                content: '일정를 변경하면 핀과 메모가 사라져요!',
                onAccept: () {
                  _mapScreenController.getDatesBetweenAndUpdate(start, end);
                  _selectFriendsController.updateStartAndEndDate(
                      _globalGetXController.roomId.value, start, end);
                },
                onCancle: () {},
                top: 0.3,
              );
            } else {
              _mapScreenController.getDatesBetweenAndUpdate(start, end);
              _selectFriendsController.updateStartAndEndDate(
                  _globalGetXController.roomId.value, start, end);
            }
          } else {
            print("시작 날짜 또는 종료 날짜 null");
          }
        },
      ),
    );
  }
}
