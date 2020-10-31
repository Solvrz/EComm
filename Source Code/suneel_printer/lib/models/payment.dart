import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Payment {
  static const MethodChannel _channel =
      MethodChannel("com.suneel37.suneel_printer/allInOne");
  static const platform = const MethodChannel('CHANNEL');

  void startPayment() async {
    http.Response response = await http.post(
      "https://suneel-printers.herokuapp.com/payment",
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "cust": "yugthapar37@gmail.com",
        "id": "ORDER_0105",
        // TODO : Generate Random Order
        "value": "5.00",
        "staging": "true",
      }),
    );

    if (response.statusCode == 200) {
      String txn = jsonDecode(response.body)["body"]["txnToken"];

      var arguments = <String, dynamic>{
        "mid": "MoShyC80984595390154",
        "orderId": "ORDER_0",
        "amount": "5.00",
        "txnToken": txn,
        "callbackUrl": "https://securegw-stage.paytm.in/order/process",
        "isStaging": true
      };

      try {
        var result = await _channel.invokeMethod("pay", arguments);
        print(result.toString());
      } catch (err) {
        print(err.message);
      }
    }
  }
}
