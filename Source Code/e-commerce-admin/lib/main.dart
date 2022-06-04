import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './config/constant.dart';
import './config/themes.dart';
import './screens/export.dart';
import './services/screen_size.dart';

// TODO: Documentation, Remove SP metions, Logo, Splash, Icons
Future<void> backgroundMsg(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: "admin-suneelprinters@gmail.com",
    password: "SuneelPrinters37",
  );

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await messaging.subscribeToTopic("orders");
  FirebaseMessaging.onBackgroundMessage(backgroundMsg);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(ECommerce());
}

class ECommerce extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, widget) {
        screenSize = ScreenSize(context: context);
        return widget!;
      },
      title: 'Suneel Printers (Admin)',
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "/home": (context) => HomeScreen(),
        "/orders": (context) => OrderScreen(),
        "/category": (context) => CategoryScreen(),
        "/add_product": (context) => AddProductScreen(),
      },
    );
  }
}
