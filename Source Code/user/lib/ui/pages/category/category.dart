import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './product.dart';
import '/config/constant.dart';
import '/ui/widgets/custom_app_bar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  dynamic screen;

  @override
  Widget build(BuildContext context) {
    final CategoryArguments args =
        ModalRoute.of(context)!.settings.arguments! as CategoryArguments;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          context: context,
          title: args.title,
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
                        BAG.products.length.toString(),
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
          future: args.reference.collection("tabs").orderBy("uId").get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ProductPage(
                parent: this,
                title: args.title,
                tabsData: snapshot.data!.docs
                    .map<Map<dynamic, dynamic>>(
                      (e) => e.data()! as Map,
                    )
                    .toList(),
                tabs: snapshot.data!.docs
                    .map<DocumentReference>((e) => e.reference)
                    .toList(),
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
