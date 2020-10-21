import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  await http.post(
    "https://suneel-printers-mail-server.herokuapp.com/order_request",
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{
      "customer": "yugthapar37@gmail.com",
      "name": "Yug",
      "phone": "+919999999999",
      "address": "Mandi",
      "price": "100",
      "product_list": "hi",
    }),
  );
}
