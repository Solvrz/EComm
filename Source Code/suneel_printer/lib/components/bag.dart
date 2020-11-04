import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suneel_printer/components/home.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/bag.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/screens/payment.dart';

class CheckoutSheet extends StatefulWidget {
  final double price;

  CheckoutSheet({@required this.price});

  @override
  _CheckoutSheetState createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  static List<String> paymentMethods = [
    "Pay On Delivery",
    "PayTM, Credit Card, Debit Card & Net Banking"
  ];

  String pod = paymentMethods.first;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: kUIColor,
        ),
        padding: EdgeInsets.only(top: 8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(Icons.close, color: kUIDarkText),
                    ),
                  ),
                  Text(
                    "Check Out",
                    style: TextStyle(
                        fontFamily: "sans-serif-condensed",
                        color: kUIDarkText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Name: ",
                              style: TextStyle(
                                color: kUIDarkText,
                                fontSize: 20,
                                fontFamily: "sans-serif-condensed",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${selectedInfo['name'].toString().capitalize()}",
                              style: TextStyle(
                                fontSize: 18,
                                color: kUIDarkText,
                                fontFamily: "sans-serif-condensed",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: false,
                              enableDrag: false,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (_) => Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: InformationSheet(popable: false),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.edit,
                            size: 25,
                            color: kUIDarkText.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Phone: ",
                          style: TextStyle(
                            color: kUIDarkText,
                            fontSize: 20,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${selectedInfo['phone']}",
                          style: TextStyle(
                            fontSize: 18,
                            color: kUIDarkText,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Email: ",
                          style: TextStyle(
                            color: kUIDarkText,
                            fontSize: 20,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${selectedInfo['email']}",
                          style: TextStyle(
                            color: kUIDarkText,
                            fontSize: 18,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Address: ",
                          style: TextStyle(
                            color: kUIDarkText,
                            fontSize: 20,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${selectedInfo['address'].toString().capitalize()}, ${selectedInfo['pincode']}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: 18,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(height: 20, thickness: 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Methods",
                          style: TextStyle(
                            color: kUIDarkText,
                            fontSize: 22,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 120,
                          child: ListView(
                              children: paymentMethods.map<Widget>(
                            (value) {
                              return RadioListTile(
                                title: Text(
                                  value,
                                  style: TextStyle(
                                    color: kUIDarkText,
                                    fontSize: 18,
                                    fontFamily: "sans-serif-condensed",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                value: value,
                                groupValue: pod,
                                onChanged: (_) {
                                  if (pod != value) setState(() => pod = value);
                                },
                              );
                            },
                          ).toList()),
                        ),
                        Divider(height: 20, thickness: 2),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Total:",
                                style: TextStyle(
                                  color: kUIDarkText,
                                  fontSize: 24,
                                  fontFamily: "sans-serif-condensed",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "₹ ",
                              style: TextStyle(
                                color: kUIDarkText,
                                fontFamily: "sans-serif-condensed",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.price - widget.price.toInt() == 0
                                  ? widget.price.toInt().toString()
                                  : widget.price.toStringAsFixed(2),
                              style: TextStyle(
                                color: kUIDarkText,
                                fontSize: 24,
                                fontFamily: "sans-serif-condensed",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 15, thickness: 2),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: MaterialButton(
                  onPressed: pod == paymentMethods.first
                      ? () async {
                          Navigator.popAndPushNamed(
                            context,
                            "/payment",
                            arguments: PaymentArguments(
                                success: true,
                                msg:
                                    "You will soon receive a confirmation mail from us.",
                                process: () async {
                                  await placeOrder();
                                }),
                          );
                        }
                      : () async {
                          FocusScope.of(context).unfocus();

                          dynamic status = await payment.startPayment(
                              selectedInfo["email"],
                              selectedInfo["phone"],
                              widget.price);

                          if (status != false) {
                            String msg;
                            bool success;

                            switch (status) {
                              case "01":
                                {
                                  success = true;
                                  msg =
                                      "You will soon receive a confirmation mail from us.";
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
                                  msg = "Insufficent Balance";
                                }
                                break;
                              case "295":
                                {
                                  success = false;
                                  msg = "UPI ID was inccorect";
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
                                      "Your Transaction Status is not Confirmed. Please Contact Us or Try a Diffrent Payment Method";
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
                                      "Your Transaction Status is not Confirmed. Please Contact Us or Try a Diffrent Payment Method";
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

                            Navigator.popAndPushNamed(
                              context,
                              "/payment",
                              arguments: PaymentArguments(
                                  success: success,
                                  msg: msg,
                                  process: () async {
                                    if (success) await placeOrder();
                                  }),
                            );
                          } else {
                            Navigator.popAndPushNamed(
                              context,
                              "/payment",
                              arguments: PaymentArguments(
                                  success: false,
                                  msg: "The Transaction was cancelled",
                                  process: () async {}),
                            );
                          }
                        },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 36),
                  color: kUIAccent,
                  child: Text(
                    pod == paymentMethods.first
                        ? "Proceed To Buy"
                        : "Proceed To Pay",
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: "sans-serif-condensed",
                        fontWeight: FontWeight.w600,
                        color: kUILightText),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ]),
      ),
    );
  }

  Future placeOrder() async {
    await http.post(
      "https://suneel-printers.herokuapp.com/order_request",
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "name": selectedInfo["name"],
        "phone": selectedInfo["phone"],
        "address": selectedInfo["address"],
        "email": selectedInfo["email"],
        "payment_mode":
            pod == paymentMethods.first ? "Pay On Delivery" : "Prepaid",
        "price": widget.price.toString(),
        "product_list": bag.products
            .map<String>((BagItem bagItem) {
              Product product = bagItem.product;

              return '''
                    <tr>
                        <td>${product.name}</td>
                        <td class="righty">${bagItem.quantity}</td>
                        <td class="righty">${(product.price.toDouble() * bagItem.quantity).toStringAsFixed(2)}</td>
                    </tr>
                    ''';
            })
            .toList()
            .join("\n"),
      }),
    );

    List<String> pastOrders = preferences.getStringList("orders") ?? [];

    pastOrders.add(
      jsonEncode({
        "name": selectedInfo["name"],
        "phone": selectedInfo["phone"],
        "address": selectedInfo["address"],
        "pincode": selectedInfo["pincode"],
        "email": selectedInfo["email"],
        "time": Timestamp.now().toString(),
        "price": widget.price.toString(),
        "payment_mode":
            pod == paymentMethods.first ? "Pay On Delivery" : "Prepaid",
        "products": bag.products.map((e) {
          return {"product": e.product.toJson(), "quantity": e.quantity};
        }).toList()
      }),
    );

    preferences.setStringList("orders", pastOrders);

    database.collection("orders").add({
      "name": selectedInfo["name"],
      "phone": selectedInfo["phone"],
      "address": selectedInfo["address"],
      "pincode": selectedInfo["pincode"],
      "email": selectedInfo["email"],
      "payment_mode":
          pod == paymentMethods.first ? "Pay On Delivery" : "Prepaid",
      "time": Timestamp.now(),
      "price": widget.price.toString(),
      "status": false,
      "products": bag.products.map((e) {
        return {"product": e.product.toJson(), "quantity": e.quantity};
      }).toList()
    });
  }
}
