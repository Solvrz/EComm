import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:suneel_printer/constant.dart';

class Payment {
  static MethodChannel _channel =
      MethodChannel("com.suneel37.suneel_printer/allInOne");

  Future startPayment(String email, String phone, double amount) async {
    try {
      http.Response token = await http.post(
        "https://suneel-printers.herokuapp.com/payment",
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, dynamic>{
          "cust": email,
          "phone": phone,
          "value": amount,
          "staging": staging,
        }),
      );

      if (token.statusCode == 200) {
        Map tokenResponse = jsonDecode(token.body);

        var arguments = <String, dynamic>{
          "mid": "MoShyC80984595390154",
          "amount": amount,
          "orderId": tokenResponse["orderId"],
          "txnToken": tokenResponse["body"]["txnToken"],
          "isStaging": staging
        };

        await _channel.invokeMethod("pay", arguments);

        http.Response status = await http.post(
          "https://suneel-printers.herokuapp.com/status",
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
          body: jsonEncode(<String, dynamic>{
            "orderId": tokenResponse["orderId"],
            "staging": staging,
          }),
        );

        if (status.statusCode == 200) {
          Map statusResponse = jsonDecode(status.body);

          return statusResponse["body"]["resultInfo"]["resultCode"];
        }
      }
    } catch (err) {
      return false;
    }
  }
}
