import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PaymentArguments args = ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kUIColor,
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Container(
                height: 500,
                width: 500,
                child: FlareActor(
                  args.success
                      ? "assets/animation/Success.flr"
                      : "assets/animation/Failure.flr",
                  animation: "forward",
                  fit: BoxFit.contain,
                  callback: (_) {
                    Timer(
                      Duration(milliseconds: 800),
                      () => Navigator.popAndPushNamed(
                        context,
                        "/home",
                      ),
                    );
                  },
                ),
              ),
              Text(
                args.success ? "Order Placed Successfully" : "Payment Failed",
                style: TextStyle(
                  color: kUIDarkText,
                  fontSize: 36,
                  fontFamily: "sans-serif-condensed",
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                args.msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kUIDarkText,
                  fontSize: 20,
                  fontFamily: "sans-serif-condensed",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class PaymentArguments {
  final bool success;
  final String msg;

  PaymentArguments(
      {@required this.success,
      this.msg = "You will soon recieve a confirmation mail from us."});
}
