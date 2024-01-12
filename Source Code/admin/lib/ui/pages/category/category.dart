import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/config/constant.dart';
import '/ui/widgets/custom_app_bar.dart';
import 'product.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
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
                    final dynamic screen = ProducPage(
                      title,
                      snapshot.data!.docs
                          .map<Map<dynamic, dynamic>>((e) => e.data()! as Map)
                          .toList(),
                      snapshot.data!.docs
                          .map<DocumentReference>((e) => e.reference)
                          .toList(),
                    );

                    return Scaffold(
                      resizeToAvoidBottomInset: false,
                      appBar: CustomAppBar(context: context, title: title),
                      floatingActionButton: screen != null
                          ? Builder(
                              builder: (context) => screen.getFab(context),
                            )
                          : null,
                      body: Column(children: [Expanded(child: screen)]),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
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
