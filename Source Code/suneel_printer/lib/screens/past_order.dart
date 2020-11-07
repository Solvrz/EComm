import 'dart:convert';

import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        appBar: CustomAppBar(
            parent: context,
            title:  "My Orders",
            elevation: 0),
        body: Column(children: [
          Builder(builder: (BuildContext context) {
                  List orders = preferences.getStringList("orders") ?? [];

                  if (orders.isNotEmpty) {
                    return Container(
                      height: MediaQuery.of(context).size.height - 95,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              children: List.generate(
                                orders.length,
                                (index) => GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () async {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (_) => Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: PastOrderSheet(
                                          jsonDecode(orders[index]),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: kUIDarkText,
                                                    fontSize: 18,
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
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.25,
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

  Widget _buildItem(BuildContext context, String id, Map order) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (_) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: PastOrderSheet(order),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Slidable(
          key: ValueKey(order["time"]),
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => database
                  .collection("orders")
                  .doc(id)
                  .update({"status": !order["status"]}),
              child: Container(
                margin: EdgeInsets.only(left: 12),
                height: MediaQuery.of(context).size.height / 2.95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: !order["status"] ? kUIAccent : Colors.greenAccent),
                child: Icon(
                    !order["status"] ? Icons.local_shipping : Icons.home,
                    color: kUILightText,
                    size: 32),
              ),
            )
          ],
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            height: MediaQuery.of(context).size.height / 2.95,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200]),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(children: [
                    InfoWidget(order: order),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Tap for More Details",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
