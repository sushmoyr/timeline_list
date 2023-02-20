part of 'timeline_list_widget.dart';

class LeadingWidget extends SingleChildRenderObjectWidget {
  const LeadingWidget(
      {Key? key, required Widget icon, required this.decoration})
      : super(key: key, child: icon);

  final TimelineListDecoration decoration;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderLeadingWidget(decoration);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderLeadingWidget renderObject) {
    renderObject.decoration = decoration;
  }
}

class RenderLeadingWidget extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  TimelineListDecoration _decoration;
  TimelineListDecoration get decoration => _decoration;
  set decoration(TimelineListDecoration value) {
    if (value != decoration) {
      _decoration = value;
      markNeedsPaint();
    }
  }

  RenderLeadingWidget(this._decoration, {RenderBox? child});

  @override
  void performLayout() {
    if (child != null) {
      // print("Child found");
      child!.layout(constraints, parentUsesSize: true);
      size =
          constraints.constrain(Size(child!.size.width, constraints.maxHeight));
    } else {
      size = constraints.smallest;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    Paint paint = Paint()
      ..color = decoration.barColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = decoration.barWidth
      ..strokeCap = StrokeCap.round;
    double width = size.width;
    double height = size.height;
    // print("Canvas size: $size");
    if (child != null) {
      // print('has child');
      context.paintChild(child!, _getIconPosition());
      _drawBarForChild(canvas, paint);
    } else {
      canvas.drawLine(Offset(width / 2, 0), Offset(width / 2, height), paint);
    }
    canvas.restore();
  }

  Offset _getIconPosition() {
    TimelineListIconAlign align =
        decoration.iconAlign ?? TimelineListIconAlign.center;
    double dx = 0;
    double height = size.height;
    double childHeight = child!.size.height;
    switch (align) {
      case TimelineListIconAlign.center:
        return Offset(dx, (height - childHeight) / 2);
      case TimelineListIconAlign.top:
        return Offset(dx, 0);
      case TimelineListIconAlign.bottom:
        return Offset(dx, height - childHeight);
    }
  }

  void _drawBarForChild(Canvas canvas, Paint paint) {
    Offset p1, p2, p3, p4;
    double dx = size.width / 2;
    double height = size.height;
    double childHeight = child!.size.height;
    double stroke = decoration.barWidth / 2;
    final align = decoration.iconAlign ?? TimelineListIconAlign.center;
    switch (align) {
      case TimelineListIconAlign.center:
        p1 = Offset(dx, 0);
        p2 = Offset(dx, ((height - childHeight) / 2) - stroke);
        p3 = Offset(dx, ((height + childHeight) / 2) + stroke);
        p4 = Offset(dx, height);
        Path path1 = Path()
          ..moveTo(p1.dx, p1.dy)
          ..lineTo(p2.dx, p2.dy);
        Path path2 = Path()
          ..moveTo(p3.dx, p3.dy)
          ..lineTo(p4.dx, p4.dy);
        drawPath(path1, canvas, paint);
        drawPath(path2, canvas, paint);
        return;
      case TimelineListIconAlign.top:
        Path path = Path()
          ..moveTo(dx, childHeight)
          ..lineTo(dx, height);
        drawPath(path, canvas, paint);
        // p1 = Offset(dx, childHeight);
        // p2 = Offset(dx, height);
        // canvas.drawLine(p1, p2, paint);
        return;
      case TimelineListIconAlign.bottom:
        Path path = Path()
          ..moveTo(dx, 0)
          ..lineTo(dx, height - childHeight);
        drawPath(path, canvas, paint);
        // p1 = Offset(dx, 0);
        // p2 = Offset(dx, height - childHeight);
        // canvas.drawLine(p1, p2, paint);
        return;
    }
  }

  void drawPath(Path path, Canvas canvas, Paint paint) {
    // print(decoration.barStyle);
    switch (decoration.barStyle) {
      case BarStyle.solid:
        canvas.drawPath(path, paint);
        break;
      case BarStyle.dotted:
        List<double> dashArray = [decoration.barWidth, decoration.barWidth * 2];
        PathMetrics pathMetrics = path.computeMetrics();
        double distance = 0;
        for (PathMetric pathMetric in pathMetrics) {
          while (distance < pathMetric.length) {
            Path dashPath = pathMetric.extractPath(
              distance,
              distance + dashArray.first,
            );
            canvas.drawPath(
              dashPath,
              paint,
            );
            distance +=
                dashArray.fold(0, (previous, current) => previous + current);
          }
          distance -= pathMetric.length;
        }
        // print(pathMetrics.first);
        // for (PathMetric pathMetric in pathMetrics) {
        //   double distance = 0;
        //   while (distance < pathMetric.length) {
        //     print("Current distance: $distance");
        //     Path path = pathMetric.extractPath(distance, dashArray.first);
        //     canvas.save();
        //     canvas.drawPath(path, paint);
        //     canvas.restore();
        //     distance += dashArray.fold(0, (a, b) => a + b);
        //     print('New distance: $distance');
        //   }
        //   // print(pathMetric.length);
        // }
        break;
    }
  }
}
