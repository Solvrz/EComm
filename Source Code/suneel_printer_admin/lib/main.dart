import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:suneel_printer_admin/constant.dart';
import 'package:suneel_printer_admin/screens/export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;

  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);

  Firebase.initializeApp().whenComplete(() {
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "admin-suneelprinters@gmail.com", password: "SuneelPrinters37");

    FirebasePerformance.instance
        .setPerformanceCollectionEnabled(false)
        .whenComplete(() {
      FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(false)
          .whenComplete(() {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
            .whenComplete(
          () => runApp(
            SuneelPrinter(),
          ),
        );
      });
    });
  });
}

class SuneelPrinter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kUIAccent,
        highlightColor: Colors.blueGrey,
        fontFamily: "sans-serif-condensed",
      ),
      builder: (BuildContext context, Widget widget) =>
          ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(
          context,
          widget,
        ),
        maxWidth: 1200,
        minWidth: 360,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(360, name: MOBILE),
          ResponsiveBreakpoint.autoScale(500, name: MOBILE),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
        background: Container(color: kUIColor),
      ),
      title: 'SuneelPrinters',
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => SplashScreen(),
        "/home": (BuildContext context) => HomeScreen(),
        "/product": (BuildContext context) => ProductScreen(),
        "/category": (BuildContext context) => CategoryScreen(),
        "/add_product": (BuildContext context) => AddProductScreen(),
        "/past_orders": (BuildContext context) => PastOrderScreen(),
      },
    );
  }
}
