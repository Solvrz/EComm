import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/config/constant.dart';

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
      args.process().then(
        (_) {
          if (mounted)
            setState(() {
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
                    () => Navigator.pushNamed(
                      context,
                      "/home",
                    ),
                  );

                  if (args.success) bag.clear();
                },
              );
            });
        },
      );
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: screenSize.all(16),
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              if (!isCompleted) SizedBox(height: 150),
              Container(
                height: isCompleted
                    ? screenSize.height(500)
                    : screenSize.height(200),
                width: isCompleted ? 500 : 200,
                child: isCompleted
                    ? flareAnimation
                    : CircularProgressIndicator(strokeWidth: 14),
              ),
              if (!isCompleted)
                SizedBox(
                  height: screenSize.height(150),
                ),
              Text(
                !isCompleted
                    ? "Please Wait...\nProcessing your Order"
                    : args.success
                        ? "Order Placed Successfully"
                        : "Payment Failed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kUIDarkText,
                  fontSize: screenSize.height(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isCompleted) ...[
                SizedBox(height: 8),
                Text(
                  args.msg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kUIDarkText,
                    fontSize: screenSize.height(20),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ]
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
    @required this.msg,
  });
}
