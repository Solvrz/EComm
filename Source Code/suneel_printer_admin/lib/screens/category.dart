import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer_admin/components/custom_app_bar.dart';
import 'package:suneel_printer_admin/constant.dart';
import 'package:suneel_printer_admin/screens/category_product.dart';

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
                      dynamic screen = CategoryProductPage(
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
                      );

                      return Scaffold(
                        backgroundColor: kUIColor,
                        resizeToAvoidBottomInset: false,
                        appBar: CustomAppBar(
                          parent: context,
                          title: title,
                        ),
                        floatingActionButton: screen != null
                            ? Builder(
                                builder: (context) => screen.getFab(context),
                              )
                            : null,
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