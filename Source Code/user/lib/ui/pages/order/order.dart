import 'dart:convert';

import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';

import './widgets/info_widget.dart';
import '/config/constant.dart';
import '/tools/extensions.dart';
import '/ui/widgets/custom_app_bar.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:
            CustomAppBar(context: context, title: "My Orders", elevation: 0),
        body: Column(
          children: [
            Builder(
              builder: (context) {
                final List<dynamic> orders =
                    preferences.getStringList("orders") ?? [];

                orders.sort((a, b) {
                  final dynamic orderA = jsonDecode(
                    a.toString(),
                  );
                  final DateTime timestampA =
                      orderA["time"].toString().toDate();

                  final dynamic orderB = jsonDecode(
                    b.toString(),
                  );
                  final DateTime timestampB =
                      orderB["time"].toString().toDate();

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
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: OrderSheet(
                                        order: jsonDecode(orders[index]),
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: screenSize.symmetric(horizontal: 12),
                                  child: Container(
                                    margin: screenSize.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: theme.highlightColor,
                                    ),
                                    child: Padding(
                                      padding: screenSize.all(16),
                                      child: Column(
                                        children: [
                                          InfoWidget(
                                            order: jsonDecode(orders[index]),
                                          ),
                                          Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Tap for More Details",
                                                  style: TextStyle(
                                                    color: theme
                                                        .colorScheme.onPrimary,
                                                    fontSize:
                                                        screenSize.height(18),
                                                    fontFamily:
                                                        "sans-serif-condensed",
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.keyboard_arrow_down,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                      child: SizedBox(
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
