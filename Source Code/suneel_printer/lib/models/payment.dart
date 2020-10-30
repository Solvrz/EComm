import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Payment {
  // ignore: non_constant_identifier_names
  var CHANNEL = "com.suneel37.suneel_printer/allInOne";
  static const platform = const MethodChannel('CHANNEL');

  static void startPayment() async {
    await http.post(
      "https://suneel-printers.herokuapp.com/order_request",
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "cust": "yugthapar37@gmail.com",
        "id": "ORDER_0001",
        "value": "1.00",
        "staging": "true",
      }),
    );

    // var arguments = <String, dynamic>{
    //   "mid": "MoShyC80984595390154",
    //   "orderId": "MoShyC80984595390154kkk",
    //   "amount": "5.00",
    //   "txnToken": "txnToken",
    //   "callbackUrl": "https://securegw-stage.paytm.in/order/process",
    //   "isStaging": true
    // };

    // try {
    //   var result = await platform.invokeMethod("pay", arguments);
    //   print(result.toString());
    // } catch (err) {
    //   print(err.message);
    // }
  }
}
