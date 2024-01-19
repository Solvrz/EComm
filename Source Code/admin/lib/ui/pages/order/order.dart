// ignore_for_file: avoid_types_on_closure_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import './widgets/order.dart';
import '/config/constant.dart';
import '/ui/widgets/custom_app_bar.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool undeliveredTitle = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) async {
        await Navigator.pushNamed(context, "/home");
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(context: context, title: "Orders", elevation: 0),
          body: Column(
            children: [
              StreamBuilder(
                stream: FIRESTORE
                    .collection("orders")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> future) {
                  if (future.hasData) {
                    if (future.data!.docs.isNotEmpty) {
                      final List<Map<dynamic, dynamic>> unDelivered = [];
                      final List<String> unDeliveredIds = [];

                      final List<Map<dynamic, dynamic>> delivered = [];
                      final List<String> deliveredIds = [];

                      future.data!.docs
                          .forEach((QueryDocumentSnapshot element) {
                        if (element.data() != null) {
                          if ((element.data()! as Map)["status"]) {
                            delivered.add(
                              element.data()! as Map,
                            );
                            deliveredIds.add(element.id);
                          } else {
                            unDelivered.add(
                              element.data()! as Map,
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
                                    color: theme.colorScheme.onPrimary,
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
                                    color: theme.colorScheme.onPrimary,
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
                              ],
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
                  } else {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    String id,
    Map<dynamic, dynamic> order,
  ) {
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
      child: Padding(
        padding: screenSize.symmetric(horizontal: 12),
        child: Slidable(
          key: ValueKey(order["time"]),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.25,
            children: [
              Flexible(
                flex: 6,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FIRESTORE
                      .collection("orders")
                      .doc(id)
                      .update({"status": !order["status"]}),
                  child: Container(
                    margin: screenSize.only(left: 12),
                    height: MediaQuery.of(context).size.height / 2.95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: !order["status"]
                          ? theme.primaryColor
                          : Colors.greenAccent,
                    ),
                    child: Icon(
                      !order["status"] ? Icons.local_shipping : Icons.home,
                      color: theme.colorScheme.onSecondary,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
          child: Container(
            margin: screenSize.symmetric(vertical: 8),
            height: MediaQuery.of(context).size.height / 2.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            child: Column(
              children: [
                Padding(
                  padding: screenSize.all(16),
                  child: Column(
                    children: [
                      InfoWidget(order: order),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Tap for More Details",
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: screenSize.height(18),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
