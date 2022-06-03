import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:suneel_printer_admin/config/constant.dart';
import 'package:suneel_printer_admin/widgets/custom_app_bar.dart';

import './widgets/order.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool undeliveredTitle = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, "/home");
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(parent: context, title: "Orders", elevation: 0),
          body: Column(children: [
            StreamBuilder(
              stream: database
                  .collection("orders")
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot future) {
                if (future.hasData) {
                  if (future.data.docs.isNotEmpty) {
                    List<Map> unDelivered = [];
                    List<String> unDeliveredIds = [];

                    List<Map> delivered = [];
                    List<String> deliveredIds = [];

                    future.data.docs.forEach((element) {
                      if (element.data() != null) {
                        if (element.data()["status"]) {
                          delivered.add(
                            element.data(),
                          );
                          deliveredIds.add(element.id);
                        } else {
                          unDelivered.add(
                            element.data(),
                          );
                          unDeliveredIds.add(element.id);
                        }
                      }
                    });

                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (unDelivered.isNotEmpty) ...[
                              Text(
                                "Undelivered Orders",
                                style: TextStyle(
                                  fontSize: screenSize.height(24),
                                  color: kUIDarkText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                children: List.generate(
                                  unDelivered.length,
                                  (index) => _buildItem(
                                    context,
                                    unDeliveredIds[index],
                                    unDelivered[index],
                                  ),
                                ),
                              ),
                            ],
                            if (delivered.isNotEmpty) ...[
                              Text(
                                "Delivered Orders",
                                style: TextStyle(
                                  fontSize: screenSize.height(24),
                                  color: kUIDarkText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                children: List.generate(
                                  delivered.length,
                                  (index) => _buildItem(
                                    context,
                                    deliveredIds[index],
                                    delivered[index],
                                  ),
                                ),
                              ),
                            ]
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
                } else {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String id, Map order) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: OrderSheet(order),
          ),
        );
      },
      child: Container(
        child: Padding(
          padding: screenSize.symmetric(horizontal: 12),
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
                  margin: screenSize.only(left: 12),
                  height: MediaQuery.of(context).size.height / 2.95,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: !order["status"]
                          ? Theme.of(context).primaryColor
                          : Colors.greenAccent),
                  child: Icon(
                      !order["status"] ? Icons.local_shipping : Icons.home,
                      color: kUILightText,
                      size: 32),
                ),
              )
            ],
            child: Container(
              margin: screenSize.symmetric(vertical: 8),
              height: MediaQuery.of(context).size.height / 2.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200]),
              child: Column(
                children: [
                  Padding(
                    padding: screenSize.all(16),
                    child: Column(children: [
                      InfoWidget(order: order),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Tap for More Details",
                              style: TextStyle(
                                color: kUIDarkText,
                                fontSize: screenSize.height(18),
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
      ),
    );
  }
}