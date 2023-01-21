import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ClockPage(),
    );
  }
}

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late Timer timer;

  @override
  void initState() {
    timer =
        Timer.periodic(const Duration(seconds: 1), (timer) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Clock"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 300,
          height: 300,
          child: Transform.rotate(
            angle: -pi / 2,
            child: CustomPaint(
              painter: ClockPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var time = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillCircle = Paint()..color = Colors.blue;
    var borderCircle = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    var centerDot = Paint()..color = Colors.white;

    var secBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..shader = const RadialGradient(colors: [Colors.white, Colors.pink])
          .createShader(Rect.fromCircle(center: center, radius: radius));

    var minBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..shader = const RadialGradient(colors: [Colors.white, Colors.orange])
          .createShader(Rect.fromCircle(center: center, radius: radius));

    var hourBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..shader = const RadialGradient(colors: [Colors.white, Colors.green])
          .createShader(Rect.fromCircle(center: center, radius: radius));

    var dashBrush = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    var secX = centerX + 80 * cos(time.second * 6 * pi / 180);
    var secY = centerX + 80 * sin(time.second * 6 * pi / 180);
    var minX = centerX + 70 * cos(time.minute * 6 * pi / 180);
    var minY = centerX + 70 * sin(time.minute * 6 * pi / 180);
    var hourX =
        centerX + 60 * cos((time.hour * 30 + time.minute * 0.5) * pi / 180);
    var hourY =
        centerX + 60 * sin((time.hour * 30 + time.minute * 0.5) * pi / 180);

    canvas.drawCircle(center, radius - 40, fillCircle);
    canvas.drawCircle(center, radius - 40, borderCircle);
    canvas.drawLine(center, Offset(secX, secY), secBrush);
    canvas.drawLine(center, Offset(minX, minY), minBrush);
    canvas.drawLine(center, Offset(hourX, hourY), hourBrush);
    canvas.drawCircle(center, 12, centerDot);

    var outerRadius = radius;
    var innerRadius = radius - 14;
    for (double i = 0; i < 360; i += 12) {
      var x1 = centerX + outerRadius * cos(i * pi / 180);
      var y1 = centerX + outerRadius * sin(i * pi / 180);
      var x2 = centerX + innerRadius * cos(i * pi / 180);
      var y2 = centerX + innerRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
