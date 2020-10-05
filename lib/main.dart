import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/cart.dart';
import 'package:suneel_printer/screens/category.dart';
import 'package:suneel_printer/screens/home.dart';
import 'package:suneel_printer/screens/product.dart';
import 'package:suneel_printer/screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);

  Firebase.initializeApp().whenComplete(() {
    FirebasePerformance.instance
        .setPerformanceCollectionEnabled(false)
        .whenComplete(() {
      FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(false)
          .whenComplete(() {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
            .then(
          (_) => runApp(
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
      theme:
          ThemeData(primaryColor: kUIAccent, highlightColor: Colors.blueGrey),
      builder: (BuildContext context, Widget child) {
        return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();
              return;
            },
            child: child);
      },
      title: 'SuneelPrinters',
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => SplashScreen(),
        "/home": (BuildContext context) => HomeScreen(),
        "/category": (BuildContext context) => CategoryScreen(),
        "/product": (BuildContext context) => ProductScreen(),
        "/cart": (BuildContext context) => CartScreen()
      },
    );
  }
}
