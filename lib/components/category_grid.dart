import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/components/marquee.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/category.dart';

class CategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final double fontSize;
  final EdgeInsets margin;

  CategoryGrid(
      {@required this.categories,
      this.fontSize = 17,
      this.margin = const EdgeInsets.fromLTRB(30, 40, 30, 0)});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: margin,
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(categories.length, (int index) {
            Map<String, dynamic> data = categories[index];
            return GestureDetector(
              onTap: () async {
                QuerySnapshot docs =
                    await database.collection("categories").get();
                docs.docs.forEach((element) async {
                  if (element.get("uId").toString() == data["uId"]) {
                    QuerySnapshot tabs = await element.reference
                        .collection("tabs")
                        .orderBy("uId")
                        .get();
                    if (tabs.docs.isNotEmpty) {
                      return Navigator.pushNamed(context, "/category",
                          arguments: CategoryArguments(
                              data["name"].split("\n").join(" "),
                              tabs.docs.map<Map>((DocumentSnapshot e) => e.data()).toList(),
                              tabs.docs.map<DocumentReference>((DocumentSnapshot e) => e.reference).toList(),
                              element.reference));
                    }
                  }
                });
              },
              child: Column(
                children: [
                  data["icon"] != null
                      ? Icon(
                          data["icon"],
                          color: kUIAccent,
                          size: 42,
                        )
                      : Image.asset(data["image"], height: 40, width: 40),
                  SizedBox(height: 4),
                  Marquee(
                    backDuration: Duration(seconds: 2),
                    child: Text(
                      data["name"],
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kUIDarkText, fontSize: fontSize),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
