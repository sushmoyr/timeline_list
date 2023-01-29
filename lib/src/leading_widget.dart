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
    canvas.translate(0, offset.dy);
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
        canvas.drawLine(p1, p2, paint);
        canvas.drawLine(p3, p4, paint);
        return;
      case TimelineListIconAlign.top:
        p1 = Offset(dx, childHeight);
        p2 = Offset(dx, height);
        canvas.drawLine(p1, p2, paint);
        return;
      case TimelineListIconAlign.bottom:
        p1 = Offset(dx, 0);
        p2 = Offset(dx, height - childHeight);
        canvas.drawLine(p1, p2, paint);
        return;
    }
  }
}
