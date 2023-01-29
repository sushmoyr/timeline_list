import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timeline_list/timeline_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF3FB),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TimelineList.builder(
          itemCount: 3,
          decoration: TimelineListDecoration(
            barColor: const Color(0xFFDDE4F2),
            barWidth: 4.0,
          ),
          builder: (index) {
            return TimelineListItem(
              icon: ProgressStatus(
                size: Size.fromRadius(24),
                progress: 0.1,
                backgroundColor: Colors.white,
                activeColor: Color(0xFF52B69A),
                inactiveColor: Color(0xFFD3ECE5),
              ),
              body: AspectRatio(
                aspectRatio: 306 / 158,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            'https://leverageedublog.s3.ap-south-1.amazonaws.com/blog/wp-content/uploads/2020/02/07164833/Physics-Project-for-Class-12-800x500.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "প্রথম অধ্যায়",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            "স্থির তড়িৎ",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
      // body: const Center(
      //   child: ProgressStatus(
      //     size: Size.fromRadius(24),
      //     progress: 0.52,
      //     backgroundColor: Colors.white,
      //     activeColor: Color(0xFF52B69A),
      //     inactiveColor: Color(0xFFD3ECE5),
      //   ),
      // ),
    );
  }
}

class ProgressStatus extends StatefulWidget {
  const ProgressStatus({
    Key? key,
    this.size = const Size.square(36),
    this.progress = 0.5,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.duration,
    this.curve,
  }) : super(key: key);

  final Size size;
  final double progress;
  final Color? backgroundColor;
  final Color? inactiveColor;
  final Color? activeColor;
  final Duration? duration;
  final Curve? curve;

  @override
  State<ProgressStatus> createState() => _ProgressStatusState();
}

class _ProgressStatusState extends State<ProgressStatus>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 1500),
    );

    animation = CurvedAnimation(
        parent: controller, curve: widget.curve ?? Curves.linear);

    // controller.forward();
  }

  @override
  void didUpdateWidget(covariant ProgressStatus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress < widget.progress) {
      controller.animateBack(widget.progress);
    } else {
      controller.animateTo(widget.progress);
    }
    // if (controller.isAnimating) {
    //   controller
    // } else {
    //   controller.forward(from: oldWidget.progress);
    // }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        widget.backgroundColor ?? Theme.of(context).colorScheme.surface;
    Color inactiveColor =
        widget.inactiveColor ?? Theme.of(context).colorScheme.outline;
    Color activeColor =
        widget.activeColor ?? Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        double value = animation.value;
        print(value);
        return SizedBox.fromSize(
          size: widget.size,
          child: CustomPaint(
            painter: ProgressStatusPainter(
              progress: value,
              backgroundColor: backgroundColor,
              inactiveColor: inactiveColor,
              activeColor: activeColor,
              strokeWidth: 4.0,
            ),
            child: Center(
              child: Text(
                "${(value * 100).toStringAsFixed(0)}%",
                style: TextStyle(fontSize: 9.0),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProgressStatusPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color inactiveColor;
  final Color activeColor;
  final double strokeWidth;

  const ProgressStatusPainter({
    required this.progress,
    required this.backgroundColor,
    required this.inactiveColor,
    required this.activeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    Paint activeColorPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    Paint inactiveColorPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    Offset center = size.center(Offset.zero);
    double radius = size.width / 2;

    // Draw the background
    // canvas.drawCircle(center, radius, backgroundPaint);

    // Draw the inactive line
    canvas.drawCircle(center, radius - (strokeWidth / 2), inactiveColorPaint);

    // Draw the active line
    double startAngle = pi * (3 / 2);
    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
        startAngle,
        sweepAngle,
        false,
        activeColorPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressStatusPainter oldDelegate) {
    return oldDelegate.activeColor != activeColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
