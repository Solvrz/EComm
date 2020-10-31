import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Payment {
  static const MethodChannel _channel =
      MethodChannel("com.suneel37.suneel_printer/allInOne");

  Future<bool> startPayment(String address, String phone, double amount) async {
    http.Response response = await http.post(
      "https://suneel-printers.herokuapp.com/payment",
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "cust": address,
        "value": amount.toString(),
        "staging": "true",
        "phone": phone,
      }),
    );

    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);

      var arguments = <String, dynamic>{
        "mid": "MoShyC80984595390154",
        "orderId": result["orderId"],
        "amount": amount.toString(),
        "txnToken": result["body"]["txnToken"],
        "callbackUrl": "https://securegw-stage.paytm.in/order/process",
        "isStaging": true
      };

      try {
        var result = await _channel.invokeMethod("pay", arguments);
        print("RESULT: ${result.toString()}");
      } catch (err) {
        print("ERROR: ${err.message}");
        return false;
      }
    }

    return true;
  }
}
