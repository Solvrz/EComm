import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suneel_printer/config/constant.dart';
import 'package:suneel_printer/config/themes.dart';
import 'package:suneel_printer/screens/export.dart';
import 'package:suneel_printer/services/screen_size.dart';

// TODO: Try Except on Place Order & HTTP requests
// TODO: Refactor Code
// TODO: Native Splash
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;

  secureStorage
      .write(key: "key_testing", value: "rzp_test_3XFNUiX9RPskxm")
      .whenComplete(() {
    secureStorage
        // TODO: Put Merchant Key
        .write(key: "key_production", value: "")
        .whenComplete(() {
      secureStorage.read(key: "key_testing").then((value) {
        keyTesting = value;

        secureStorage.read(key: "key_production").then((value) {
          keyProduction = value;

          Firebase.initializeApp().whenComplete(() {
            FirebaseCrashlytics.instance
                .setCrashlyticsCollectionEnabled(false)
                .whenComplete(() {
              FlutterError.onError =
                  FirebaseCrashlytics.instance.recordFlutterError;

              SharedPreferences.getInstance()
                  .then((value) => preferences = value)
                  .whenComplete(() {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]).whenComplete(
                  () => runApp(
                    SuneelPrinter(),
                  ),
                );
              });
            });
          });
        });
      });
    });
  });
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
