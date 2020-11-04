import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/bag.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/screens/past_order_detail.dart';

class PastOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<List<BagItem>> orders = (preferences.getStringList("orders") ?? [])
        .map<List<BagItem>>((e) =>
            jsonDecode(e).map<BagItem>((e) => BagItem.fromString(e)).toList())
        .toList();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: kUIDarkText,
                        size: 26,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Your Past Orders",
                        style: TextStyle(
                            fontSize: 24,
                            color: kUIDarkText,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: null,
                    child: Icon(Icons.clear, color: Colors.transparent),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      orders.length,
                      (index) {
                        List<BagItem> currOrder = orders[index];
                        Product product = currOrder.first.product;

                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.pushNamed(context, "/order", arguments: PastOrderDetailArguments(currOrder));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.grey[200]),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 18),
                                    child: Row(
                                      children: [
                                        product.images.length > 0
                                            ? Image(image: product.images[0])
                                            : Text("No Image Provided"),
                                        SizedBox(width: 24),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                product.name,
                                                style: TextStyle(
                                                    color: kUIDarkText,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        "sans-serif-condensed",
                                                    letterSpacing: -0.4),
                                              ),
                                              Text(
                                                "${currOrder.length} items",
                                                style: TextStyle(
                                                    color: kUIDarkText
                                                        .withOpacity(0.7),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w800,
                                                    fontFamily:
                                                        "sans-serif-condensed"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
