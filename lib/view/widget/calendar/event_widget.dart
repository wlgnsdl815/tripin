import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';

/// Custom event widget with rounded borders
class EventWidget extends StatelessWidget {
  const EventWidget({
    required this.drawer,
    super.key,
  });

  final EventProperties drawer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(60)),
        color: drawer.backgroundColor,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          drawer.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
