import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './firebase_options.dart';
import '/config/constant.dart';
import '/config/theme.dart';
import '/services/screen_size.dart';
import '/ui/pages/export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  preferences = await SharedPreferences.getInstance();

  runApp(const EComm());
}

class EComm extends StatelessWidget {
  const EComm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ECommTheme.of(context),
      builder: (context, widget) {
        screenSize = ScreenSize(context: context);
        theme = ECommTheme.of(context);

        return widget!;
      },
      title: "EComm",
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashPage(),
        "/bag": (context) => const BagPage(),
        "/home": (context) => const HomePage(),
        "/orders": (context) => const OrderPage(),
        "/product": (context) => const ProductPage(),
        "/payment": (context) => const PaymentPage(),
        "/wishlist": (context) => const WishlistPage(),
        "/category": (context) => const CategoryPage(),
      },
    );
  }
}
