
import 'package:flutter/material.dart';
import 'package:tripin/model/chat_room_model.dart';
import 'package:tripin/utils/colors.dart';

class ProfileTripTile extends StatelessWidget {
  const ProfileTripTile({super.key, this.trip});

  final ChatRoom? trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: PlatformColors.subtitle8
      ),
      child: Text('${trip != null ? trip!.roomTitle : 'null'}'),
    );
  }
}

