import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/components/category.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';

// ignore: must_be_immutable
class CategoryProductPage extends StatefulWidget {
  final String title;
  final List<Map> tabsData;
  final List<DocumentReference> tabs;
  int _currentTab = 0;

  CategoryProductPage(this.title, this.tabsData, this.tabs);

  @override
  _CategoryProductPageState createState() => _CategoryProductPageState();
}

class _CategoryProductPageState extends State<CategoryProductPage> {
  ScrollController tabsController;

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
        padding: EdgeInsets.fromLTRB(0, 6, 2, 6),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: kUIColor,
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.grey[400], width: 1),
          ),
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            SingleChildScrollView(
              controller: tabsController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(widget.tabs.length, (int index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (index == widget._currentTab) return;
                      if (mounted)
                        setState(() {
                          widget._currentTab = index;
                        });
                    },
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          children: [
                            if (index == widget._currentTab) ...[
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: kUISecondaryAccent,
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
                                  fontSize:
                                      index == widget._currentTab ? 16 : 14,
                                  fontWeight: index == widget._currentTab
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: index == widget._currentTab
                                      ? kUIDarkText
                                      : Colors.grey[600]),
                            ),
                            if (index == widget._currentTab) ...[
                              SizedBox(width: 8),
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: kUISecondaryAccent,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            if (tabsController.hasClients)
              if (tabsController.offset <
                  tabsController.position.maxScrollExtent * 0.9)
                Icon(Icons.arrow_forward_ios, size: 18)
          ],
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
                  products: future.data.docs.map<Product>(
                    (DocumentSnapshot e) {
                      return Product.fromJson(
                        e.data(),
                      );
                    },
                  ).toList(),
                ),
              );
            } else {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: EmptyListWidget(
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
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[700]),
                ),
              ),
            );
          }
        },
      ),
    ]);
  }
}
