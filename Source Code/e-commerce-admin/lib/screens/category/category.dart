import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './product.dart';
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
        body: FutureBuilder<QuerySnapshot>(
            future: database
                .collection("categories")
                .where("uId", isEqualTo: args.uId)
                .get(),
            // TODO: SS  Firebase Structure
            builder: (context, future) {
              if (future.hasData) {
                return FutureBuilder<QuerySnapshot>(
                    future: future.data!.docs.first.reference
                        .collection("tabs")
                        .orderBy("uId")
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        dynamic screen = ProducScreen(
                          title,
                          snapshot.data!.docs
                              .map<Map>((e) => e.data() as Map)
                              .toList(),
                          snapshot.data!.docs
                              .map<DocumentReference>((e) => e.reference)
                              .toList(),
                        );

                        return Scaffold(
                          resizeToAvoidBottomInset: false,
                          appBar: CustomAppBar(parent: context, title: title),
                          floatingActionButton: screen != null
                              ? Builder(
                                  builder: (context) => screen.getFab(context))
                              : null,
                          body: Column(children: [Expanded(child: screen)]),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
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
