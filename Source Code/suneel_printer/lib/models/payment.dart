import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:suneel_printer/constant.dart';

class Payment {
  static MethodChannel _channel =
      MethodChannel("com.solvrz.suneel_printer/allInOne");

  Future startPayment(
      BuildContext context, String email, String phone, double amount) async {
    try {
      http.Response token = await http.post(
        "https://suneel-printers.herokuapp.com/payment",
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, dynamic>{
          "cust": email,
          "phone": phone,
          "value": amount.toString(),
          "staging": staging.toString(),
        }),
      );

      if (token.statusCode == 200) {
        Map tokenResponse = jsonDecode(token.body);

        var arguments = <String, dynamic>{
          "mid": "MoShyC80984595390154",
          "amount": amount.toString(),
          "orderId": tokenResponse["orderId"],
          "txnToken": tokenResponse["body"]["txnToken"],
          "isStaging": staging
        };

        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) => Container(
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(20), color: Colors.white),
        //     child: Column(children: [
        //       indicator,
        //       Text(
        //         "Payment is being processed",
        //         style:
        //             TextStyle(fontSize: 16, fontFamily: "sans-serif-condensed"),
        //       )
        //     ]),
        //   ),
        // );

        await _channel.invokeMethod("pay", arguments);

        http.Response status = await http.post(
          "https://suneel-printers.herokuapp.com/status",
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
          body: jsonEncode(<String, dynamic>{
            "orderId": tokenResponse["orderId"],
            "staging": staging.toString(),
          }),
        );

        if (status.statusCode == 200) {
          Map statusResponse = jsonDecode(status.body);

          String msg;
          bool success;

          switch (statusResponse["body"]["resultInfo"]["resultCode"]) {
            case "01":
              {
                success = true;
                msg = "You will soon receive a confirmation mail from us.";
              }
              break;
            case "227":
              {
                success = false;
                msg =
                    "Payment was declined by your Bank. Please contact your bank for any queries.";
              }
              break;
            case "235":
              {
                success = false;
                msg = "Insufficient Balance";
              }
              break;
            case "295":
              {
                success = false;
                msg = "UPI ID was incorrect";
              }
              break;

            case "334":
              {
                success = false;
                msg = "Server Error";
              }
              break;
            case "335":
              {
                success = false;
                msg = "Server Error. Try Again Later";
              }
              break;

            case "400":
              {
                success = false;
                msg =
                    "Your Transaction Status is not Confirmed. Please Contact Us or Try a different Payment Method";
              }
              break;
            case "401":
              {
                success = false;
                msg =
                    "Payment was declined by your Bank. Please contact your bank for any queries.";
              }
              break;
            case "402":
              {
                success = false;
                msg =
                    "Your Transaction Status is not Confirmed. Please Contact Us or Try a different Payment Method";
              }
              break;
            case "501":
              {
                success = false;
                msg = "Server Down. Try Again Later";
              }
              break;
            case "810":
              {
                success = false;
                msg = "Transaction Failed";
              }
              break;

            default:
              {
                success = false;
                msg = "An Unknown Error Occurred";
              }
              break;
          }

          return {"success": success, "msg": msg};
        }
      }
    } catch (err) {
      return {"success": false, "msg": "The Transaction was cancelled"};
    }
  }
}
