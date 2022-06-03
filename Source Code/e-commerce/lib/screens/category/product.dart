import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';

import './widgets/product_list.dart';
import '../../config/constant.dart';
import '../../models/product.dart';

// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  final State parent;
  final String title;
  final List<Map> tabsData;
  final List<DocumentReference> tabs;
  int _currentTab = 0;

  ProductScreen(this.parent, this.title, this.tabsData, this.tabs);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ScrollController tabsController;

  @override
  void initState() {
    super.initState();

    tabsController = ScrollController()..addListener(() => setState(() {}));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: screenSize.fromLTRB(0, 6, 2, 6),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.grey[400]!, width: 1),
          ),
        ),
        child: SingleChildScrollView(
          controller: tabsController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(widget.tabs.length, (int index) {
              return GestureDetector(
                onTap: () {
                  if (index == widget._currentTab) return;
                  if (mounted) setState(() => widget._currentTab = index);
                },
                child: Container(
                  child: Padding(
                    padding: screenSize.symmetric(horizontal: 18),
                    child: Row(children: [
                      if (index == widget._currentTab) ...[
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: Color(0xffa5c4f2),
                        ),
                        SizedBox(width: 8),
                      ],
                      AnimatedDefaultTextStyle(
                        child: Text(
                          widget.tabsData[index]["name"]
                              .split("\\n")
                              .join("\n"),
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(milliseconds: 150),
                        style: TextStyle(
                            fontSize: screenSize
                                .height(index == widget._currentTab ? 16 : 14),
                            fontWeight: index == widget._currentTab
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: index == widget._currentTab
                                ? kUIDarkText
                                : Colors.grey[600]),
                      ),
                    ]),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      StreamBuilder<QuerySnapshot>(
        stream:
            widget.tabs[widget._currentTab].collection("products").snapshots(),
        builder: (BuildContext context, AsyncSnapshot future) {
          if (future.hasData) {
            if (future.data.docs.isNotEmpty) {
              return Expanded(
                child: ProductList(
                  parent: widget.parent,
                  products: future.data.docs
                      .map<Product>(
                        (DocumentSnapshot e) =>
                            Product.fromJson(e.data() as Map),
                      )
                      .toList(),
                ),
              );
            } else {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: EmptyWidget(
                    title: "No Product",
                    subTitle: "No Product Available Yet",
                  ),
                ),
              );
            }
          } else {
            return Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    ]);
  }
}
