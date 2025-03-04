import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: MaskedRotatingBackground(),
        ),
      ),
    );
  }
}

class MaskedRotatingBackground extends StatefulWidget {
  const MaskedRotatingBackground({super.key});

  @override
  _MaskedRotatingBackgroundState createState() =>
      _MaskedRotatingBackgroundState();
}

class _MaskedRotatingBackgroundState extends State<MaskedRotatingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerWidth = size.width * 0.8;
    final containerHeight = size.height * 0.3;

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: RectangularClipper(),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * pi,
                child: CustomPaint(
                  size: Size(size.width, size.height),
                  painter: TriangleBackgroundPainter(),
                ),
              );
            },
          ),
        ),
        Container(
          width: containerWidth,
          height: containerHeight,
          color: Colors.transparent, // Container maskesi
        ),
      ],
    );
  }
}

class TriangleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = sqrt(size.width * size.width + size.height * size.height);

    for (int i = 0; i < 20; i++) {
      paint.color = i % 2 == 0 ? Colors.black : Colors.grey;
      canvas.drawPath(
        Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(
            center.dx + radius * cos(2 * pi * i / 20),
            center.dy + radius * sin(2 * pi * i / 20),
          )
          ..lineTo(
            center.dx + radius * cos(2 * pi * (i + 1) / 20),
            center.dy + radius * sin(2 * pi * (i + 1) / 20),
          )
          ..close(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RectangularClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Ortadaki container boyutunda bir dikdörtgen maskesi
    final double width = size.width * 0.8;
    final double height = size.height * 0.3;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    return Path()
      ..addRect(Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: width,
        height: height,
      ));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
