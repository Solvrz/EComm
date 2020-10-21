import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/components/marquee.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/category.dart';

class CategoryList extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  CategoryList(
      {@required this.categories,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
        children: List.generate(categories.length, (int index) {
          Map<String, dynamic> data = categories[index];
          return GestureDetector(
            onTap: () async {
              return Navigator.pushNamed(context, "/category",
                  arguments: CategoryArguments(
                      data,
                      await database.collection("categories").where("uId", isEqualTo: data["uId"]).get()
                  ));
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xffFBD9D8),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  data["icon"] != null
                      ? Icon(
                          data["icon"],
                          color: kUIAccent,
                          size: 42,
                        )
                      : Image.asset(data["image"], height: 40, width: 40),
                  SizedBox(height: 4),
                  Text(
                    data["name"],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kUIDarkText, fontSize: 17),
                  ),
                ],
              ),
            ),
          );
        }),
      ));
  }
}