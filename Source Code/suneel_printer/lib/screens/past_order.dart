import 'dart:convert';

import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/components/custom_app_bar.dart';
import 'package:suneel_printer/components/past_order.dart';
import 'package:suneel_printer/constant.dart';

class PastOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(parent: context, title: "My Orders", elevation: 0),
        body: Column(children: [
          Builder(builder: (BuildContext context) {
            List orders = preferences.getStringList("orders") ?? [];

            if (orders.isNotEmpty) {
              return Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height - 95,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: List.generate(
                          orders.length,
                              (index) =>
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (_) =>
                                        Padding(
                                          padding: MediaQuery
                                              .of(context)
                                              .viewInsets,
                                          child: PastOrderSheet(
                                            jsonDecode(orders[index]),
                                          ),
                                        ),
                                  );
                                },
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              20),
                                          color: Colors.grey[200]),
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
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
                                                    fontSize: getHeight(
                                                        context, 18),
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 1.25,
                    child: EmptyListWidget(
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
