import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '/config/constant.dart';
import '/models/product.dart';
import '/ui/pages/payment/payment.dart';
import '/ui/widgets/information_sheet.dart';

class CheckoutSheet extends StatefulWidget {
  final double price;

  const CheckoutSheet({super.key, required this.price});

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  late Razorpay _razorpay;

  static List<String> paymentMethods = [
    "Pay On Delivery",
    "Wallets, Credit Card, Debit Card & Net Banking",
  ];

  String paymentMethod = paymentMethods.first;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) async {
      final http.Response verification = await http.post(
        Uri.https(
          SERVER,
          "payment_verify",
          {
            "payment_id": response.paymentId,
            "signature": response.signature,
            "order_id": response.orderId,
          },
        ),
      );

      if (verification.statusCode == 200) {
        final Map<dynamic, dynamic> verificationResponse =
            jsonDecode(verification.body);
        if (verificationResponse["sucessful"]) {
          if (!context.mounted) return;

          await Navigator.popAndPushNamed(
            context,
            "/payment",
            arguments: PaymentArguments(
              success: true,
              msg:
                  "The Payment was Successful, You will soon receive a confirmation mail from us.",
              process: () async {
                await placeOrder();
              },
            ),
          );
        } else {
          if (!context.mounted) return;

          await Navigator.popAndPushNamed(
            context,
            "/payment",
            arguments: PaymentArguments(
              success: false,
              msg:
                  "The Payment Failed, If Money was deducted from your account, Please Contact Us",
              process: () async {},
            ),
          );
        }
      } else {
        if (!context.mounted) return;

        await Navigator.popAndPushNamed(
          context,
          "/payment",
          arguments: PaymentArguments(
            success: false,
            msg:
                "Server Error, If Money was deducted from your account, Please Contact Us",
            process: () async {},
          ),
        );
      }
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
      Navigator.popAndPushNamed(
        context,
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
          process: () async {},
        ),
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
          },
        ),
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
          color: Theme.of(context).colorScheme.background,
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
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                Text(
                  "Check Out",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: screenSize.height(24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: screenSize.height(20),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            selectedInfo!["name"].toString().capitalize(),
                            style: TextStyle(
                              fontSize: screenSize.height(18),
                              color: Theme.of(context).colorScheme.onPrimary,
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
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Phone: ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: screenSize.height(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${selectedInfo!["phone"]}",
                        style: TextStyle(
                          fontSize: screenSize.height(18),
                          color: Theme.of(context).colorScheme.onPrimary,
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
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: screenSize.height(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${selectedInfo!["email"]}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
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
                          color: Theme.of(context).colorScheme.onPrimary,
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
                            color: Theme.of(context).colorScheme.onPrimary,
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
                          color: Theme.of(context).colorScheme.onPrimary,
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: screenSize.height(18),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                value: value,
                                groupValue: paymentMethod,
                                onChanged: (_) {
                                  if (paymentMethod != value) {
                                    if (context.mounted) {
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
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: screenSize.height(24),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "$CURRENCY ",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.price - widget.price.toInt() == 0
                                ? widget.price.toString()
                                : widget.price.toStringAsFixed(2),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
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
                            process: () async => placeOrder(),
                          ),
                        );
                      }
                    : () async {
                        FocusScope.of(context).unfocus();

                        final http.Response token = await http.post(
                          Uri.https(
                            SERVER,
                            "payment_init",
                            {
                              "amount": (widget.price * 100).toInt().toString(),
                              "order_id":
                                  "ORDER_${DateTime.now().microsecondsSinceEpoch}",
                            },
                          ),
                        );

                        if (token.statusCode == 200) {
                          final Map<dynamic, dynamic> tokenResponse =
                              jsonDecode(token.body);

                          _razorpay.open({
                            // TODO: Change This
                            "name": "EComm",
                            "key": kDebugMode ? KEY_TESTING : KEY_PRODUCTION,
                            "order_id": tokenResponse["id"],
                            "amount": widget.price * 100,
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
                              ],
                            },
                          });
                        } else {
                          if (!context.mounted) return;

                          await Navigator.popAndPushNamed(
                            context,
                            "/payment",
                            arguments: PaymentArguments(
                              success: false,
                              msg: "Server Error, Please Try Again later",
                              process: () async {},
                            ),
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
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Future<void> placeOrder() async {
    await http.post(
      Uri.https(
        SERVER,
        "order",
        {
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
                final Product product = bagItem.product;
                final String variationText = product.selected!.isNotEmpty
                    ? " (${product.selected!.values.map((value) => value.label).toList().join(", ")})"
                    : "";

                return """
                    <tr>dend json from flutter app to python server
                        <td>${product.name}$variationText</td>
                        <td class="righty">${bagItem.quantity}</td>
                        <td class="righty">${(product.price.toDouble() * bagItem.quantity).toStringAsFixed(2)}</td>
                    </tr>
                    """;
              })
              .toList()
              .join("\n"),
        },
      ),
    );

    final List<String> pastOrders = preferences.getStringList("orders") ?? [];

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
        }).toList(),
      }),
    );
    await preferences.setStringList("orders", pastOrders);

    await firestore.collection("orders").add({
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
      }).toList(),
    });
  }
}
