import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import '../../config/constant.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late FlareActor flareAnimation;

  bool isCompleted = false;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    PaymentArguments args =
        ModalRoute.of(context)!.settings.arguments as PaymentArguments;

    if (!isProcessing) {
      isProcessing = true;
      args.process().then(
        (_) {
          if (mounted) {
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
                    const Duration(milliseconds: 800),
                    () => Navigator.pushNamed(
                      context,
                      "/home",
                    ),
                  );

                  if (args.success) bag.clear();
                },
              );
            });
          }
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
              if (!isCompleted) const SizedBox(height: 150),
              SizedBox(
                height: isCompleted
                    ? screenSize.height(500)
                    : screenSize.height(200),
                width: isCompleted ? 500 : 200,
                child: isCompleted
                    ? flareAnimation
                    : const CircularProgressIndicator(strokeWidth: 14),
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
                const SizedBox(height: 8),
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
    required this.success,
    required this.process,
    required this.msg,
  });
}
