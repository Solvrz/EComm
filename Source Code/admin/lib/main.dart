import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './firebase_options.dart';
import '/config/constant.dart';
import '/config/theme.dart';
import '/services/screen_size.dart';
import '/ui/pages/export.dart';

Future<void> backgroundMsg(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // TODO: Create the same User ID and Pass on Firebase Auth
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: "admin-ecomm@gmail.com",
    password: "EComm37",
  );

  await crashlytics.setCrashlyticsCollectionEnabled(false);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await messaging.setAutoInitEnabled(true);
  await messaging.subscribeToTopic("orders");
  FirebaseMessaging.onBackgroundMessage(backgroundMsg);

  runApp(const ECommerceAdmin());
}

class ECommerceAdmin extends StatelessWidget {
  const ECommerceAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ECommAdminTheme.of(context),
      builder: (context, widget) {
        screenSize = ScreenSize(context: context);
        return widget!;
      },
      title: "EComm (Admin)",
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashPage(),
        "/home": (context) => const HomePage(),
        "/orders": (context) => const OrderPage(),
        "/category": (context) => const CategoryPage(),
        "/add_product": (context) => const AddProductPage(),
      },
    );
  }
}
