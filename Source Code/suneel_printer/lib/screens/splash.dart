import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/home.dart';

class SplashScreenOld extends StatefulWidget {
  @override
  _SplashScreenOldState createState() => _SplashScreenOldState();
}

class _SplashScreenOldState extends State<SplashScreenOld> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cart.load();
      wishlist.load();
      Timer(Duration(milliseconds: 800),
          () => Navigator.pushReplacementNamed(context, "/home"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          SystemNavigator.pop();
          return;
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: kUIColor,
            resizeToAvoidBottomInset: false,
            body: Container(
              height: MediaQuery.of(context).size.height,
              color: kUIColor,
              child: Hero(
                tag: "logo",
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    child: Center(
                      child: Text(
                        "Suneel Printers",
                        style: TextStyle(
                            fontFamily: "Kalam-Bold",
                            fontSize: 50,
                            color: kUIDarkText),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _AnimationScreenState createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Size size = Size.zero;
  AnimationController _controller;
  Animation<double> holeSize;

  //StaggeredRaindropAnimation _animation;
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
      cart.load();
      wishlist.load();
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    holeSize = Tween<double>(begin: 0.0, end: 2.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
    _controller.addListener(() {
      setState(() {});
    });

    Timer(Duration(seconds: 5), () {
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
          color: holeSize.value > 1.5 ? Colors.white : Colors.red),
      if (holeSize.value < 1.5)
        Center(
          child: Image.asset(
            'assets/images/Logo.png',
            height: 200.0,
            width: 200.0,
          ),
        ),
      Opacity(opacity: pow(holeSize.value / 2, 2), child: HomeScreen()),
      if (holeSize.value < 1.5)
        Container(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
              painter:
                  AnimatedCircle(circleSize: holeSize.value * size.height)),
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
  });

  double circleSize;

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

    canvas.drawPath(circle, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
