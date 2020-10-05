import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suneel_printer/constant.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cart.load();
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
                        style:
                            TextStyle(fontFamily: "Kalam-Bold", fontSize: 50, color: kUIDarkText),
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
