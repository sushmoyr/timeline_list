import 'package:flutter/material.dart';

enum TimelineListIconAlign { center, top, bottom }

class TimelineListDecoration {
  final Color? barColor;
  final double barWidth;
  final EdgeInsets? contentPadding;
  final EdgeInsets? iconMargin;
  final TimelineListIconAlign? iconAlign;

//<editor-fold desc="Data Methods">
  const TimelineListDecoration({
    this.barColor,
    this.barWidth = 4.0,
    this.contentPadding,
    this.iconMargin,
    this.iconAlign,
  });

  factory TimelineListDecoration.of(BuildContext context) {
    final theme = Theme.of(context);
    final barColor =
        theme.useMaterial3 ? theme.colorScheme.outline : theme.shadowColor;
    const contentPadding = EdgeInsets.symmetric(vertical: 8);
    const iconMargin = EdgeInsets.symmetric(vertical: 8);
    const iconAlign = TimelineListIconAlign.center;

    return TimelineListDecoration(
      barColor: barColor,
      contentPadding: contentPadding,
      iconMargin: iconMargin,
      iconAlign: iconAlign,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimelineListDecoration &&
          runtimeType == other.runtimeType &&
          barColor == other.barColor &&
          barWidth == other.barWidth &&
          contentPadding == other.contentPadding &&
          iconMargin == other.iconMargin &&
          iconAlign == other.iconAlign);

  @override
  int get hashCode =>
      barColor.hashCode ^
      barWidth.hashCode ^
      contentPadding.hashCode ^
      iconMargin.hashCode ^
      iconAlign.hashCode;

  @override
  String toString() {
    return 'TimelineListDecoration{ barColor: $barColor, barWidth: $barWidth, contentPadding: $contentPadding, iconMargin: $iconMargin, iconAlign: $iconAlign,}';
  }

  TimelineListDecoration copyWith({
    Color? barColor,
    double? barWidth,
    EdgeInsets? contentPadding,
    EdgeInsets? iconMargin,
    TimelineListIconAlign? iconAlign,
  }) {
    return TimelineListDecoration(
      barColor: barColor ?? this.barColor,
      barWidth: barWidth ?? this.barWidth,
      contentPadding: contentPadding ?? this.contentPadding,
      iconMargin: iconMargin ?? this.iconMargin,
      iconAlign: iconAlign ?? this.iconAlign,
    );
  }

//</editor-fold>
}
