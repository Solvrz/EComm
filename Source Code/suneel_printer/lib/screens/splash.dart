import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Size size = Size.zero;
  AnimationController _controller;
  Animation<double> holeSize;
  Animation<Color> holeColor;

  void didChangeDependencies() {
    setState(() {
      size = MediaQuery.of(context).size;
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      wishlist.load();
      bag.load();

      addresses = (preferences.getStringList("info") ?? [])
          .map<Map>(
            (e) => jsonDecode(e),
          )
          .toList();

      List<Map> selected = addresses.where((e) => e["selected"]).toList();
      if (selected.length > 0) selectedInfo = selected.first;

      print(addresses);
    });

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    holeSize = Tween<double>(begin: 0, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    holeColor = ColorTween(begin: Color(0xfffcd7de), end: kUIColor).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _controller.addListener(() {
      setState(() {});
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        _controller.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        color: holeSize.value > 1.5 ? kUIColor : Color(0xfff23558),
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
        opacity: pow(holeSize.value / 2, 2),
        child: HomeScreen(),
      ),
      if (holeSize.value < 1.5)
        Container(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: AnimatedCircle(
                circleSize: holeSize.value * size.height,
                holeColor: holeColor.value),
          ),
        ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class AnimatedCircle extends CustomPainter {
  AnimatedCircle({
    @required this.circleSize,
    @required this.holeColor,
  });

  double circleSize;
  Color holeColor;

  @override
  void paint(Canvas canvas, Size size) {
    double radius = circleSize / 2;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect rCircle = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);

    Path circle = Path.combine(
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
