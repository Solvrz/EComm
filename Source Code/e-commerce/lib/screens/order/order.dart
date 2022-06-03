import 'dart:convert';

import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';

import './widgets/info_widget.dart';
import '../../config/constant.dart';
import '../../widgets/custom_app_bar.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(parent: context, title: "My Orders", elevation: 0),
        body: Column(children: [
          Builder(builder: (BuildContext context) {
            List orders = preferences.getStringList("orders") ?? [];

            orders.sort((a, b) {
              dynamic orderA = jsonDecode(
                a.toString(),
              );
              DateTime timestampA = orderA["time"].toString().toDate();

              dynamic orderB = jsonDecode(
                b.toString(),
              );
              DateTime timestampB = orderB["time"].toString().toDate();

              return timestampB.compareTo(timestampA);
            });

            if (orders.isNotEmpty) {
              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: List.generate(
                          orders.length,
                          (index) => GestureDetector(
                            onTap: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (_) => Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: OrderSheet(
                                    jsonDecode(orders[index]),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              child: Padding(
                                padding: screenSize.symmetric(horizontal: 12),
                                child: Container(
                                  margin: screenSize.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Theme.of(context).highlightColor),
                                  child: Padding(
                                    padding: screenSize.all(16),
                                    child: Column(children: [
                                      InfoWidget(
                                        order: jsonDecode(orders[index]),
                                      ),
                                      Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "Tap for More Details",
                                              style: TextStyle(
                                                color: kUIDarkText,
                                                fontSize: screenSize.height(18),
                                                fontFamily:
                                                    "sans-serif-condensed",
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Icon(Icons.keyboard_arrow_down)
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Expanded(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.25,
                    child: EmptyWidget(
                      packageImage: PackageImage.Image_4,
                      title: "No Orders",
                      subTitle: "No Orders have been placed.",
                    ),
                  ),
                ),
              );
            }
          })
        ]),
      ),
    );
  }
}
