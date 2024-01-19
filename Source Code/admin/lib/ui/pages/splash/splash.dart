import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '/config/constant.dart';
import '/ui/pages/home/export.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  Size size = Size.zero;

  late AnimationController _controller;
  late Animation<double> holeSize;
  late Animation<Color?> holeColor;

  @override
  void didChangeDependencies() {
    setState(() => size = MediaQuery.of(context).size);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() => setState(() {}));

    holeSize = Tween<double>(begin: 0, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    holeColor =
        ColorTween(begin: const Color(0xfffcd7de), end: Colors.white).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    Timer(const Duration(seconds: 3), () => _controller.forward());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: holeSize.value > 1.5
              ? theme.colorScheme.background
              : const Color(0xfff23558),
        ),
        if (holeSize.value < 1.5)
          Center(
            child: Image.asset(
              'assets/images/Logo.png',
              height: 200,
              width: 200,
            ),
          ),
        Opacity(
          opacity: pow(holeSize.value / 2, 2).toDouble(),
          child: const HomePage(),
        ),
        if (holeSize.value < 1.5)
          SizedBox.expand(
            child: CustomPaint(
              painter: AnimatedCircle(
                circleSize: holeSize.value * size.height,
                holeColor: holeColor.value!,
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class AnimatedCircle extends CustomPainter {
  AnimatedCircle({
    required this.circleSize,
    required this.holeColor,
  });

  double circleSize;
  Color holeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = circleSize / 2;
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Rect rCircle = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );

    final Path circle = Path.combine(
      PathOperation.intersect,
      Path()..addRect(rect),
      Path()
        ..addOval(rCircle)
        ..close(),
    );

    canvas.drawPath(circle, Paint()..color = holeColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
