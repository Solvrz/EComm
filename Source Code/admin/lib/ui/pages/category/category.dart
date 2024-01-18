import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/ui/widgets/custom_app_bar.dart';
import 'product.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  dynamic screen;

  @override
  Widget build(BuildContext context) {
    final CategoryArguments args =
        ModalRoute.of(context)!.settings.arguments! as CategoryArguments;

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<QuerySnapshot>(
          future: args.reference.collection("tabs").orderBy("uId").get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final dynamic screen = ProducPage(
                args.title,
                snapshot.data!.docs
                    .map<Map<dynamic, dynamic>>((e) => e.data()! as Map)
                    .toList(),
                snapshot.data!.docs
                    .map<DocumentReference>((e) => e.reference)
                    .toList(),
              );

              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: CustomAppBar(context: context, title: args.title),
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
        ),
      ),
    );
  }
}

class CategoryArguments {
  final String title;
  final DocumentReference reference;

  CategoryArguments(this.title, this.reference);
}
