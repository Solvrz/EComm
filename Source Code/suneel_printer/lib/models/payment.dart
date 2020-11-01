import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:suneel_printer/constant.dart';

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
        "phone": phone,
        "value": amount.toString(),
        "staging": staging.toString(),
      }),
    );

    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);

      var arguments = <String, dynamic>{
        "amount": amount.toString(),
        "mid": "MoShyC80984595390154",
        "orderId": result["orderId"],
        "txnToken": result["body"]["txnToken"],
        "isStaging": staging
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
