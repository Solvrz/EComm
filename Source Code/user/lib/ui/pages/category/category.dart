import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './product.dart';
import './request.dart';
import '/config/constant.dart';
import '/ui/widgets/custom_app_bar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late String title;
  dynamic screen;

  @override
  Widget build(BuildContext context) {
    final CategoryArguments args =
        ModalRoute.of(context)!.settings.arguments! as CategoryArguments;

    title = args.data["name"].split("\n").join(" ");

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          context: context,
          title: title,
          trailing: [
            GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, "/bag");
                if (context.mounted) setState(() {});
              },
              child: Padding(
                padding: screenSize.all(18),
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/Bag.png",
                      width: 30,
                      height: 30,
                    ),
                    Positioned(
                      left: 11,
                      top: 7,
                      child: Text(
                        bag.products.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: firestore
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
                    final dynamic screen = args.data["type"] == "product"
                        ? ProductPage(
                            parent: this,
                            title: title,
                            tabsData: snapshot.data!.docs
                                .map<Map<dynamic, dynamic>>(
                                  (e) => e.data()! as Map,
                                )
                                .toList(),
                            tabs: snapshot.data!.docs
                                .map<DocumentReference>((e) => e.reference)
                                .toList(),
                          )
                        : RequestPage(
                            title: title,
                            tabsData: snapshot.data!.docs
                                .map<Map<dynamic, dynamic>>(
                                  (e) => e.data()! as Map,
                                )
                                .toList(),
                          );

                    return Column(children: [Expanded(child: screen)]);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class CategoryArguments {
  final Map<String, dynamic> data;
  final int uId;

  CategoryArguments(this.data, this.uId);
}
