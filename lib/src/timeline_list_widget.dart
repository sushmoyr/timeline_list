import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timeline_list/src/timeline_list_decoration.dart';

import 'timeline_list_item.dart';

part 'leading_widget.dart';

class TimelineList extends StatelessWidget {
  const TimelineList({
    Key? key,
    required this.items,
    this.onItemTap,
    this.decoration,
  }) : super(key: key);

  factory TimelineList.builder({
    required int itemCount,
    required TimelineListItem Function(int index) builder,
    VoidCallback? onItemTap,
    TimelineListDecoration? decoration,
  }) {
    List<TimelineListItem> items = List.generate(
      itemCount,
      (index) => builder(index),
    );
    return TimelineList(
      items: items,
      onItemTap: onItemTap,
      decoration: decoration,
    );
  }

  final List<TimelineListItem> items;
  final VoidCallback? onItemTap;
  final TimelineListDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration =
        decoration ?? TimelineListDecoration.of(context);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, idx) {
        final item = items[idx];
        return IntrinsicHeight(
          child: Row(
            children: [
              LeadingWidget(
                icon: Padding(
                  padding: effectiveDecoration.iconMargin ??
                      const EdgeInsets.symmetric(vertical: 8),
                  child: item.icon,
                ),
                decoration: effectiveDecoration,
              ),
              Expanded(
                child: Padding(
                  padding: effectiveDecoration.contentPadding ??
                      const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: item.onTap,
                    child: item.body,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
