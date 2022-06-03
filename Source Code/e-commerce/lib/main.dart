import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './config/constant.dart';
import './config/themes.dart';
import './screens/bag/export.dart';
import './screens/category/export.dart';
import './screens/home/export.dart';
import './screens/order/export.dart';
import './screens/payment/export.dart';
import './screens/product/export.dart';
import './screens/wishlist/export.dart';
import './services/screen_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await secureStorage.write(
    key: "key_testing",
    value: "rzp_test_3XFNUiX9RPskxm",
  );
  await secureStorage.write(
    key: "key_production",
    value: "",
  ); // TODO: Put Merchant Key

  keyTesting = (await secureStorage.read(key: "key_testing"))!;
  keyProduction = (await secureStorage.read(key: "key_production"))!;

  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  preferences = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(ECommerce());
}

class ECommerce extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (BuildContext context, Widget? widget) {
        screenSize = ScreenSize(context: context);
        return widget!;
      },
      title: "E-Commerce",
      initialRoute: "/",
      routes: {
        "/bag": (BuildContext context) => BagScreen(),
        "/home": (BuildContext context) => HomeScreen(),
        "/orders": (BuildContext context) => OrderScreen(),
        "/product": (BuildContext context) => ProductScreen(),
        "/payment": (BuildContext context) => PaymentScreen(),
        "/wishlist": (BuildContext context) => WishlistScreen(),
        "/category": (BuildContext context) => CategoryScreen(),
      },
    );
  }
}
