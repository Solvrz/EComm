import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:suneel_printer_admin/config/constant.dart';
import 'package:suneel_printer_admin/config/themes.dart';
import 'package:suneel_printer_admin/screens/add_product/export.dart';
import 'package:suneel_printer_admin/screens/category/export.dart';
import 'package:suneel_printer_admin/screens/home/export.dart';
import 'package:suneel_printer_admin/screens/order/export.dart';
import 'package:suneel_printer_admin/screens/splash/export.dart';
import 'package:suneel_printer_admin/services/screen_size.dart';

Future<void> backgroundMsg(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseAuth.instance.signInWithEmailAndPassword(
      email: "admin-suneelprinters@gmail.com", password: "SuneelPrinters37");

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  messaging.subscribeToTopic("orders");
  FirebaseMessaging.onBackgroundMessage(backgroundMsg);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(SuneelPrinter());
}

class SuneelPrinter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (BuildContext context, Widget widget) {
        screenSize = ScreenSize(context: context);
        return widget;
      },
      title: 'Suneel Printers (Admin)',
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => SplashScreen(),
        "/home": (BuildContext context) => HomeScreen(),
        "/orders": (BuildContext context) => OrderScreen(),
        "/category": (BuildContext context) => CategoryScreen(),
        "/add_product": (BuildContext context) => AddProductScreen(),
      },
    );
  }
}
