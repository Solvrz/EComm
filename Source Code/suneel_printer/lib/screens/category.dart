import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/category_product.dart';
import 'package:suneel_printer/screens/order.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String title;

  dynamic screen;

  @override
  Widget build(BuildContext context) {
    CategoryArguments args = ModalRoute.of(context).settings.arguments;

    title = args.data["name"].split("\n").join(" ");

    return SafeArea(
      child: FutureBuilder<QuerySnapshot>(
          future: database
              .collection("categories")
              .where("uId", isEqualTo: args.uId)
              .get(),
          builder: (context, future) {
            if (future.hasData) {
              return FutureBuilder<QuerySnapshot>(
                  future: future.data.docs.first.reference
                      .collection("tabs")
                      .orderBy("uId")
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      dynamic screen = !onOrder.contains(title)
                          ? CategoryProductPage(
                              title,
                              snapshot.data.docs
                                  .map<Map>(
                                    (DocumentSnapshot e) => e.data(),
                                  )
                                  .toList(),
                              snapshot.data.docs
                                  .map<DocumentReference>(
                                      (DocumentSnapshot e) => e.reference)
                                  .toList(),
                            )
                          : OrderProductPage(
                              title: title,
                              tabsData: snapshot.data.docs
                                  .map<Map>(
                                    (DocumentSnapshot e) => e.data(),
                                  )
                                  .toList(),
                            );

                      return Scaffold(
                        backgroundColor: kUIColor,
                        resizeToAvoidBottomInset: false,
                        floatingActionButton: admin && screen != null
                            ? Builder(
                                builder: (context) => screen.getFab(context),
                              )
                            : null,
                        body: Column(children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(Icons.arrow_back_ios,
                                        color: kUIDarkText, size: 26),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: kUIDarkText,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: admin
                                      ? () {}
                                      : () async {
                                          await Navigator.pushNamed(
                                              context, "/bag");
                                          setState(() {});
                                        },
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: admin
                                        ? SizedBox(height: 34, width: 34)
                                        : Stack(
                                            children: [
                                              Image.asset(
                                                  "assets/images/ShoppingBag.png",
                                                  width: 30,
                                                  height: 30),
                                              Positioned(
                                                left: 11,
                                                top: 10,
                                                child: Text(
                                                  bag.products.length
                                                      .toString(),
                                                ),
                                              )
                                            ],
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(child: screen)
                        ]),
                      );
                    } else {
                      return Center(
                        child: indicator,
                      );
                    }
                  });
            } else {
              return Center(child: indicator);
            }
          }),
    );
  }
}

class CategoryArguments {
  final Map<String, dynamic> data;
  final int uId;

  CategoryArguments(this.data, this.uId);
}
