
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tripin/controllers/profile_detail_controller.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/utils/colors.dart';

import '../../utils/text_styles.dart';

class ProfileTripTile extends StatelessWidget {
  const ProfileTripTile({super.key, required this.trip, required this.isOngoing});

  final ChatRoom trip;
  final bool isOngoing;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileDetailController>();
    bool hasStartDate = trip.startDate != null;
    int? untilTrip;
    if (hasStartDate && controller.getDaysUntilTrip(trip.startDate!) < 0)
      untilTrip = controller.getDaysUntilTrip(trip.startDate!);
    return Container(
      padding: EdgeInsets.fromLTRB(14, 12, 12, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: isOngoing ? Border.all(color: Color(0xFFEAF2FD), width: 1) : null,
        color: isOngoing ? Colors.white : PlatformColors.subtitle8,
        boxShadow: isOngoing ? [
          BoxShadow(
            color: Color.fromRGBO(187, 210, 255, 0.20),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ]: null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              untilTrip != null ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: PlatformColors.chatPrimaryLight,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Text('D$untilTrip', style: AppTextStyle.body13B(color: PlatformColors.primaryLight),)
              ): Container(),
              SizedBox(width: 8),
              Text('${trip.roomTitle}', style: AppTextStyle.body17B(),),
            ],
          ),
          Divider(color: isOngoing ? PlatformColors.subtitle8 : PlatformColors.subtitle7, height: 8),
          SizedBox(height: 6),
          Row(
            children: [
              Image.asset('assets/icons/profile_trip_date.png', width: 14, color: isOngoing ? PlatformColors.title : PlatformColors.subtitle),
              SizedBox(width: 8),
              Text(
                '${DateFormat('yyyy.MM.dd').format(trip.startDate!)} ${controller.getDayOfWeek(trip.startDate!)} '
                    '- ${DateFormat('yyyy.MM.dd').format(trip.endDate!)} ${controller.getDayOfWeek(trip.endDate!)}',
                style: AppTextStyle.body14M(color: isOngoing ? PlatformColors.title : PlatformColors.subtitle),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Image.asset('assets/icons/profile_trip_city.png', width: 14, color: isOngoing ? PlatformColors.title : PlatformColors.subtitle),
              SizedBox(width: 8),
              Text('${trip.city}',
                style: AppTextStyle.body14M(color: isOngoing ? PlatformColors.title : PlatformColors.subtitle),),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Image.asset('assets/icons/profile_trip_people.png', width: 14, color: isOngoing ? PlatformColors.title : PlatformColors.subtitle),
              SizedBox(width: 8),
              Text('${trip.participantIdList!.length}명',
                style: AppTextStyle.body14M(color: isOngoing ? PlatformColors.title : PlatformColors.subtitle),),
            ],
          ),
          SizedBox(height: 6),
        ],
      ),
    );
  }
}

