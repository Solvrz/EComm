import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/category_product.dart';
import 'package:suneel_printer/screens/order.dart';

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
          future: args.docRef.docs.first.reference
              .collection("tabs")
              .orderBy("uId")
              .get(),
          builder: (context, snapshot) {
            var screen;

            if (snapshot.hasData)
              screen = title != "Printing" && title != "Binding"
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
                                fontFamily: "sans-serif-condensed",
                                fontSize: 24,
                                color: kUIDarkText,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: admin
                            ? () {}
                            : () => Navigator.pushNamed(context, "/bag"),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: admin
                              ? SizedBox(height: 34, width: 34)
                              : Image.asset("assets/images/ShoppingBag.png",
                                  width: 30, height: 30),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: snapshot.hasData
                      ? screen
                      : Center(
                          child: Text("Loading..."),
                        ),
                )
              ]),
            );
          }),
    );
  }
}

class CategoryArguments {
  final Map<String, dynamic> data;
  final QuerySnapshot docRef;

  CategoryArguments(this.data, this.docRef);
}
