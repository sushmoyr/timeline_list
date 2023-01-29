import 'package:flutter/material.dart';

class TimelineListItem {
  final Widget icon;
  final Widget body;
  final VoidCallback? onTap;

  const TimelineListItem({
    required this.icon,
    required this.body,
    this.onTap,
  });
}
