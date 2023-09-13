import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripin/controllers/chat/schedule_controller.dart';
import 'package:tripin/controllers/chat/select_friends_controller.dart';

class ScheduleScreen extends GetView<ScheduleController> {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SelectFriendsController _selectedFriendsController =
        Get.find<SelectFriendsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '일정 선택',
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              '완료',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '선택된 친구: ${_selectedFriendsController.participants.length - 1}',
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _selectedFriendsController.participants.length - 1,
            itemBuilder: ((context, index) {
              return ListTile(
                leading: CircleAvatar(),
                title: Text(
                    '친구 ${_selectedFriendsController.participants[index]}'),
              );
            }),
          ),
        ],
      ),
    );
  }
}
