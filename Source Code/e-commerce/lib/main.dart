import 'package:e_commerce/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './config/constant.dart';
import './config/themes.dart';
import './screens/export.dart';
import './services/screen_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Add Razorpay Keys Here
  await secureStorage.write(
    key: "key_testing",
    value: "",
  );
  await secureStorage.write(
    key: "key_production",
    value: "",
  );

  keyTesting = (await secureStorage.read(key: "key_testing"))!;
  keyProduction = (await secureStorage.read(key: "key_production"))!;

  await Firebase.initializeApp(
    name: "E-Commerce",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  preferences = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    const ECommerce(),
  );
}

class ECommerce extends StatelessWidget {
  const ECommerce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, widget) {
        screenSize = ScreenSize(context: context);
        return widget!;
      },
      title: "E-Commerce",
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/bag": (context) => const BagScreen(),
        "/home": (context) => const HomeScreen(),
        "/orders": (context) => const OrderScreen(),
        "/product": (context) => const ProductScreen(),
        "/payment": (context) => const PaymentScreen(),
        "/wishlist": (context) => const WishlistScreen(),
        "/category": (context) => const CategoryScreen(),
      },
    );
  }
}
