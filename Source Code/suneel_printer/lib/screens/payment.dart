import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
            padding: EdgeInsets.symmetric(vertical: 32),
            width: MediaQuery.of(context).size.width,
            height: 700,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: FlareActor(
                      args.success
                          ? "assets/animation/Success.flr"
                          : "assets/animation/Failure.flr",
                      animation: "forward",
                      fit: BoxFit.contain,
                      callback: (_) {
                        Timer(Duration(milliseconds: 500),
                            () => Navigator.popAndPushNamed(context, "/home"));
                      },
                    ),
                  ),
                  Text(
                    args.msg,
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

  PaymentArguments({@required this.success, this.msg});
}
