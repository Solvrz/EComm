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
                      admin ? "Undelivered Orders" : "My Orders",
                      style: TextStyle(
                        fontSize: 24,
                        color: kUIDarkText,
                        fontWeight: FontWeight.bold,
                        fontFamily: "sans-serif-condensed",
                      ),
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
                  List<Map> unDelivered = [];
                  List<String> unDeliveredIds = [];

                  List<Map> delivered = [];
                  List<String> deliveredIds = [];

                  future.data.docs.forEach((element) {
                    if (element.data() != null) {
                      if (element.data()["status"]) {
                        delivered.add(element.data());
                        deliveredIds.add(element.id);
                      } else {
                        unDelivered.add(element.data());
                        unDeliveredIds.add(element.id);
                      }
                    }
                  });

                  return Container(
                    height: MediaQuery.of(context).size.height - 95,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          unDelivered.isNotEmpty
                              ? Column(
                                  children: List.generate(
                                    unDelivered.length,
                                    (index) => _buildItem(
                                      context,
                                      unDeliveredIds[index],
                                      unDelivered[index],
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    "All Orders Delivered",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: kUIDarkText,
                                      fontFamily: "sans-serif-condensed",
                                    ),
                                  ),
                                ),
                          if (delivered.isNotEmpty) ...[
                            Text(
                              "Delivered Orders",
                              style: TextStyle(
                                fontSize: 24,
                                color: kUIDarkText,
                                fontWeight: FontWeight.bold,
                                fontFamily: "sans-serif-condensed",
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

  Widget _buildItem(BuildContext context, String id, Map order) {
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
              child: PastOrderSheet(order),
            ),
          );
        },
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
                height: MediaQuery.of(context).size.height / 3.2,
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
            height: MediaQuery.of(context).size.height / 3.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200]),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name: ",
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: 20,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${order['name'].toString().capitalize()}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                color: kUIDarkText,
                                fontFamily: "sans-serif-condensed",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Date: ",
                                style: TextStyle(
                                  color: kUIDarkText,
                                  fontSize: 20,
                                  fontFamily: "sans-serif-condensed",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${order['time'].toDate().toString().split(" ")[0].split("-").reversed.join("-")}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: kUIDarkText,
                                  fontSize: 18,
                                  fontFamily: "sans-serif-condensed",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Phone: ",
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: 20,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${order['phone']}",
                            style: TextStyle(
                              fontSize: 18,
                              color: kUIDarkText,
                              fontFamily: "sans-serif-condensed",
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
                              fontSize: 20,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${order['email']}",
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: 18,
                              fontFamily: "sans-serif-condensed",
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
                              fontSize: 20,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${order['address'].toString().capitalize()}, ${order['pincode']}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: kUIDarkText,
                                fontSize: 18,
                                fontFamily: "sans-serif-condensed",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 15, thickness: 2),
                      Row(
                        children: [
                          Text(
                            "Payment Mode: ",
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: 20,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${order['payment_mode']}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: 18,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Total Price: ",
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: 20,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹ ${order['price']}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: 18,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 15, thickness: 2),
                      SizedBox(height: 8),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Tap for More Details",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: kUIDarkText,
                                fontSize: 18,
                                fontFamily: "sans-serif-condensed",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down)
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
