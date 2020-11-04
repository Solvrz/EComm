import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:suneel_printer/components/past_order.dart';
import 'package:suneel_printer/constant.dart';

class PastOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: true,
        body: Column(children: [
          Container(
            height: 70,
            padding: EdgeInsets.all(16),
            child: Row(
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
                      admin ? "Orders" : "My Orders",
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
          ),
          StreamBuilder(
            stream: database.collection("orders").snapshots(),
            builder: (BuildContext context, AsyncSnapshot future) {
              if (future.hasData) {
                if (future.data.docs.isNotEmpty) {
                  List<Map> orders = [];

                  future.data.docs
                      .forEach((element) => orders.add(element.data() ?? {}));

                  return Container(
                    height: MediaQuery.of(context).size.height - 95,
                    child: ListView.builder(
                      itemCount: future.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (_) => Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: PastOrderSheet(orders[index]),
                                ),
                              );
                            },
                            child: Slidable(
                              key: ValueKey(orders[index]["time"]),
                              actionPane: SlidableDrawerActionPane(),
                              secondaryActions: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    return future.data.docs[index].reference
                                        .update({
                                      "status": !orders[index]["status"]
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 12),
                                    height: MediaQuery.of(context).size.height /
                                        3.2,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: orders[index]["status"]
                                            ? kUIAccent
                                            : Colors.greenAccent),
                                    child: Icon(
                                        orders[index]["status"]
                                            ? Icons.local_shipping
                                            : Icons.home,
                                        color: kUILightText,
                                        size: 32),
                                  ),
                                )
                              ],
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[200]),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      InfoWidget(order: orders[index]),
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
                                    ]
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
              } else {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.grey[700]),
                    ),
                  ),
                );
              }
            },
          ),
        ]),
      ),
    );
  }
}
