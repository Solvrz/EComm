import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/components/custom_app_bar.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/category_product.dart';
import 'package:suneel_printer/screens/request_product.dart';

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
                              this,
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
                          : RequestProductPage(
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
                        appBar: CustomAppBar(
                          parent: context,
                          title: title,
                          trailing: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                await Navigator.pushNamed(context, "/bag");
                                if (mounted) setState(() {});
                              },
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.all(18),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                          "assets/images/ShoppingBag.png",
                                          width: 30,
                                          height: 30),
                                      Positioned(
                                        left: 11,
                                        top: 10,
                                        child: Text(
                                          bag.products.length.toString(),
                                          style: TextStyle(color: kUIDarkText),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        body: Column(children: [Expanded(child: screen)]),
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
