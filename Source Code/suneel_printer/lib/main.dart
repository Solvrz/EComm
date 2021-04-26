import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suneel_printer/config/constant.dart';
import 'package:suneel_printer/config/themes.dart';
import 'package:suneel_printer/screens/bag/export.dart';
import 'package:suneel_printer/screens/category/export.dart';
import 'package:suneel_printer/screens/home/export.dart';
import 'package:suneel_printer/screens/order/export.dart';
import 'package:suneel_printer/screens/payment/export.dart';
import 'package:suneel_printer/screens/product/export.dart';
import 'package:suneel_printer/screens/splash/export.dart';
import 'package:suneel_printer/screens/wishlist/export.dart';
import 'package:suneel_printer/services/screen_size.dart';

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

  keyTesting = await secureStorage.read(key: "key_testing");
  keyProduction = await secureStorage.read(key: "key_production");

  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  preferences = await SharedPreferences.getInstance();
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
      title: 'Suneel Printers',
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => SplashScreen(),
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
