import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  FlareActor flareAnimation;
  bool isCompleted = false;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    PaymentArguments args = ModalRoute.of(context).settings.arguments;

    if (!isProcessing) {
      isProcessing = true;
      args.process().then((_) => setState(() {
            isCompleted = true;
            flareAnimation = FlareActor(
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
            );
          }));
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kUIColor,
          body: Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              if (!isCompleted) SizedBox(height: 150),
              Container(
                height: isCompleted ? 500 : 200,
                width: isCompleted ? 500 : 200,
                child: isCompleted
                    ? flareAnimation
                    : CircularProgressIndicator(
                      strokeWidth: 14,
                    ),
              ),
              if (!isCompleted) SizedBox(height: 150),
              Text(
                args.success ? "Order Placed Successfully" : "Payment Failed",
                textAlign: TextAlign.center,
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
  final Function process;
  final String msg;

  PaymentArguments({
    @required this.success,
    @required this.process,
    this.msg = "You will soon receive a confirmation mail from us.",
  });
}
