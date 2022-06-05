import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../config/constant.dart';
import '../../../models/product.dart';
import '../../../screens/payment/payment.dart';
import '../../../widgets/information_sheet.dart';

class CheckoutSheet extends StatefulWidget {
  final double price;

  const CheckoutSheet({Key? key, required this.price}) : super(key: key);

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  final String serverURL =
      "e-commerce37-server.herokuapp.com"; // TODO: Change the Server URL
  late Razorpay _razorpay;

  static List<String> paymentMethods = [
    "Pay On Delivery",
    "Wallets, Credit Card, Debit Card & Net Banking"
  ];

  String paymentMethod = paymentMethods.first;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) async {
      http.Response verification = await http.post(
        Uri.https(serverURL, "payment_verify", {
          "payment_id": response.paymentId,
          "signature": response.signature,
          "order_id": response.orderId
        }),
      );

      if (verification.statusCode == 200) {
        Map verificationResponse = jsonDecode(verification.body);
        if (verificationResponse["sucessful"]) {
          if (!mounted) return;

          await Navigator.popAndPushNamed(
            context,
            "/payment",
            arguments: PaymentArguments(
                success: true,
                msg:
                    "The Payment was Successful, You will soon receive a confirmation mail from us.",
                process: () async {
                  await placeOrder();
                }),
          );
        } else {
          if (!mounted) return;

          await Navigator.popAndPushNamed(
            context,
            "/payment",
            arguments: PaymentArguments(
                success: false,
                msg:
                    "The Payment Failed, If Money was deducted from your account, Please Contact Us",
                process: () async {}),
          );
        }
      } else {
        if (!mounted) return;

        await Navigator.popAndPushNamed(
          context,
          "/payment",
          arguments: PaymentArguments(
              success: false,
              msg:
                  "Server Error, If Money was deducted from your account, Please Contact Us",
              process: () async {}),
        );
      }
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
      Navigator.popAndPushNamed(
        context,
        './screens/bag/models/bag.dart'
        "/payment",
        arguments: PaymentArguments(
          success: false,
          msg: response.message!,
          process: () async {},
        ),
      );
    });
    _razorpay.on(Razorpay.PAYMENT_CANCELLED.toString(), () {
      Navigator.popAndPushNamed(
        context,
        "/payment",
        arguments: PaymentArguments(
            success: false,
            msg: "The Payment was Cancelled",
            process: () async {}),
      );
    });
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (response) {
      Navigator.popAndPushNamed(
        context,
        "/payment",
        arguments: PaymentArguments(
            success: true,
            msg:
                "The Payment was Successfully conducted via ${response.walletName!.toUpperCase()}, You will soon receive a confirmation mail from us.",
            process: () async {
              await placeOrder();
            }),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        padding: screenSize.only(top: 8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: screenSize.all(16),
                      child: const Icon(Icons.close, color: kUIDarkText),
                    ),
                  ),
                  Text(
                    "Check Out",
                    style: TextStyle(
                        color: kUIDarkText,
                        fontSize: screenSize.height(24),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Padding(
                padding: screenSize.all(16),
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
                                fontSize: screenSize.height(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              selectedInfo!["name"].toString().capitalize(),
                              style: TextStyle(
                                fontSize: screenSize.height(18),
                                color: kUIDarkText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: false,
                              enableDrag: false,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (_) => Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: const InformationSheet(popable: false),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.edit,
                            size: screenSize.height(25),
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
                            fontSize: screenSize.height(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${selectedInfo!["phone"]}",
                          style: TextStyle(
                            fontSize: screenSize.height(18),
                            color: kUIDarkText,
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
                            fontSize: screenSize.height(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${selectedInfo!["email"]}",
                          style: TextStyle(
                            color: kUIDarkText,
                            fontSize: screenSize.height(18),
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
                            fontSize: screenSize.height(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${selectedInfo!["address"].toString().capitalize()}, ${selectedInfo!["pincode"]}"
                                .replaceAll("", "\u{200B}"),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: screenSize.height(18),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Methods",
                          style: TextStyle(
                            color: kUIDarkText,
                            fontSize: screenSize.height(22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height(120),
                          child: ListView(
                            children: paymentMethods.map<Widget>(
                              (value) {
                                return RadioListTile(
                                  title: Text(
                                    value,
                                    style: TextStyle(
                                      color: kUIDarkText,
                                      fontSize: screenSize.height(18),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  value: value,
                                  groupValue: paymentMethod,
                                  onChanged: (_) {
                                    if (paymentMethod != value) {
                                      if (mounted) {
                                        setState(() => paymentMethod = value);
                                      }
                                    }
                                  },
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Total:",
                                style: TextStyle(
                                  color: kUIDarkText,
                                  fontSize: screenSize.height(24),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Text(
                              "₹ ",
                              style: TextStyle(
                                color: kUIDarkText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.price - widget.price.toInt() == 0
                                  ? widget.price.toString()
                                  : widget.price.toStringAsFixed(2),
                              style: TextStyle(
                                color: kUIDarkText,
                                fontSize: screenSize.height(24),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 15),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: MaterialButton(
                  onPressed: paymentMethod == paymentMethods.first
                      ? () async {
                          await Navigator.popAndPushNamed(
                            context,
                            "/payment",
                            arguments: PaymentArguments(
                              success: true,
                              msg:
                                  "You will soon receive a confirmation mail from us.",
                              process: () async => await placeOrder(),
                            ),
                          );
                        }
                      : () async {
                          FocusScope.of(context).unfocus();

                          http.Response token = await http.post(
                            Uri.https(serverURL, "payment_init", {
                              "amount": (widget.price * 100).toInt(),
                              "order_id":
                                  "ORDER_${DateTime.now().microsecondsSinceEpoch.toString()}",
                            }),
                          );

                          if (token.statusCode == 200) {
                            Map tokenResponse = jsonDecode(token.body);

                            _razorpay.open({
                              "key": testing ? keyTesting : keyProduction,
                              "order_id": tokenResponse["id"],
                              "amount": (widget.price * 100),
                              "name": "E-Commerce",
                              "description": "Order Payment",
                              "timeout": 120,
                              "prefill": {
                                "contact": selectedInfo!["phone"],
                                "email": selectedInfo!["email"],
                              },
                              "external": {
                                "wallets": [
                                  "paytm",
                                  "phonepe",
                                  "jiomoney",
                                  "mobikwik",
                                  "airtelmoney",
                                  "payzapp",
                                  "freecharge",
                                ]
                              }
                            });
                          } else {
                            if (!mounted) return;

                            await Navigator.popAndPushNamed(
                              context,
                              "/payment",
                              arguments: PaymentArguments(
                                  success: false,
                                  msg: "Server Error, Please Try Again later",
                                  process: () async {}),
                            );
                          }
                        },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: screenSize.symmetric(vertical: 12, horizontal: 36),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    paymentMethod == paymentMethods.first
                        ? "Proceed To Buy"
                        : "Proceed To Pay",
                    style: TextStyle(
                        fontSize: screenSize.height(24),
                        fontWeight: FontWeight.w600,
                        color: kUILightText),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ]),
      ),
    );
  }

  Future<void> placeOrder() async {
    await http.post(
      Uri.https(serverURL, "order", {
        "name": selectedInfo!["name"],
        "phone": selectedInfo!["phone"],
        "address": selectedInfo!["address"],
        "pincode": selectedInfo!["pincode"],
        "email": selectedInfo!["email"],
        "time": Timestamp.now().toString(),
        "price": widget.price.toString(),
        "payment_mode": paymentMethod == paymentMethods.first
            ? "Pay On Delivery"
            : "Prepaid",
        "product_list": bag.products
            .map<String>((bagItem) {
              Product product = bagItem.product;
              String variationText = product.selected!.isNotEmpty
                  ? " (${product.selected!.values.map((value) => value.label).toList().join(", ")})"
                  : "";

              return """
                    <tr>
                        <td>${product.name}$variationText</td>
                        <td class="righty">${bagItem.quantity}</td>
                        <td class="righty">${(product.price.toDouble() * bagItem.quantity).toStringAsFixed(2)}</td>
                    </tr>
                    """;
            })
            .toList()
            .join("\n"),
      }),
    );

    List<String> pastOrders = preferences.getStringList("orders") ?? [];

    pastOrders.add(
      jsonEncode({
        "name": selectedInfo!["name"],
        "phone": selectedInfo!["phone"],
        "address": selectedInfo!["address"],
        "pincode": selectedInfo!["pincode"],
        "email": selectedInfo!["email"],
        "time": Timestamp.now().toString(),
        "price": widget.price.toString(),
        "payment_mode": paymentMethod == paymentMethods.first
            ? "Pay On Delivery"
            : "Prepaid",
        "products": bag.products.map((e) {
          return {"product": e.product.toJson(), "quantity": e.quantity};
        }).toList()
      }),
    );
    await preferences.setStringList("orders", pastOrders);

    await database.collection("orders").add({
      "name": selectedInfo!["name"],
      "phone": selectedInfo!["phone"],
      "address": selectedInfo!["address"],
      "pincode": selectedInfo!["pincode"],
      "email": selectedInfo!["email"],
      "status": false,
      "time": Timestamp.now(),
      "price": widget.price.toString(),
      "payment_mode":
          paymentMethod == paymentMethods.first ? "Pay On Delivery" : "Prepaid",
      "products": bag.products.map((e) {
        return {"product": e.product.toJson(), "quantity": e.quantity};
      }).toList()
    });
  }
}
