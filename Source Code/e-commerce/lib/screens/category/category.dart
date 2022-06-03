import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './product.dart';
import './request.dart';
import '../../config/constant.dart';
import '../../widgets/custom_app_bar.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late String title;
  dynamic screen;

  @override
  Widget build(BuildContext context) {
    CategoryArguments args =
        ModalRoute.of(context)!.settings.arguments as CategoryArguments;

    title = args.data["name"].split("\n").join(" ");

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          parent: context,
          title: title,
          trailing: [
            GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, "/bag");
                if (mounted) setState(() {});
              },
              child: Container(
                child: Padding(
                  padding: screenSize.all(18),
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/images/ShoppingBag.png",
                        width: 30,
                        height: 30,
                      ),
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
        body: FutureBuilder<QuerySnapshot>(
            future: database
                .collection("categories")
                .where("uId", isEqualTo: args.uId)
                .get(),
            builder: (context, future) {
              if (future.hasData) {
                return FutureBuilder<QuerySnapshot>(
                    future: future.data!.docs.first.reference
                        .collection("tabs")
                        .orderBy("uId")
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        dynamic screen = !["Printing", "Binding"]
                                .contains(title)
                            ? ProductScreen(
                                this,
                                title,
                                snapshot.data!.docs
                                    .map<Map>(
                                        (DocumentSnapshot e) => e.data() as Map)
                                    .toList(),
                                snapshot.data!.docs
                                    .map<DocumentReference>(
                                        (DocumentSnapshot e) => e.reference)
                                    .toList(),
                              )
                            : RequestScreen(
                                title: title,
                                tabsData: snapshot.data!.docs
                                    .map<Map>(
                                        (DocumentSnapshot e) => e.data() as Map)
                                    .toList(),
                              );

                        return Column(children: [Expanded(child: screen)]);
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

class CategoryArguments {
  final Map<String, dynamic> data;
  final int uId;

  CategoryArguments(this.data, this.uId);
}
