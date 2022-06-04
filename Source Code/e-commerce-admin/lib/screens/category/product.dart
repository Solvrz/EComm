import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';

import './widgets/product_list.dart';
import '../../config/constant.dart';
import '../../models/product.dart';
import '../add_product/export.dart';

// ignore: must_be_immutable
class ProducScreen extends StatefulWidget {
  final String title;
  final List<Map> tabsData;
  final List<DocumentReference> tabs;
  int _currentTab = 0;

  ProducScreen(this.title, this.tabsData, this.tabs);

  Widget getFab(BuildContext context) => FloatingActionButton(
        elevation: 10,
        child: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 30),
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            "/add_product",
            arguments: AddProductArguments(tabsData, tabs, title, _currentTab),
          );
        },
      );

  @override
  _ProducScreenState createState() => _ProducScreenState();
}

class _ProducScreenState extends State<ProducScreen> {
  late ScrollController tabsController;

  @override
  void initState() {
    super.initState();
    tabsController = ScrollController()
      ..addListener(
        () => setState(() {}),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: screenSize.symmetric(vertical: 6),
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
            children: [
              ...List.generate(widget.tabs.length, (index) {
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
                      padding: screenSize.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          if (index == widget._currentTab) ...[
                            const CircleAvatar(
                              backgroundColor: Color(0xffa5c4f2),
                              radius: 4,
                            ),
                            const SizedBox(width: 8),
                          ],
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 150),
                            style: TextStyle(
                                fontSize: screenSize.height(
                                    index == widget._currentTab ? 16 : 14),
                                fontWeight: index == widget._currentTab
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: index == widget._currentTab
                                    ? kUIDarkText
                                    : Colors.grey[600]),
                            child: Text(
                              widget.tabsData[index]["name"]
                                  .split("\\n")
                                  .join("\n"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
      StreamBuilder<QuerySnapshot>(
        stream:
            widget.tabs[widget._currentTab].collection("products").snapshots(),
        builder: (context, future) {
          if (future.hasData) {
            if (future.data!.docs.isNotEmpty) {
              return Expanded(
                child: ProductList(
                  products: future.data!.docs.map<Product>(
                    (e) {
                      return Product.fromJson(
                        e.data() as Map,
                      );
                    },
                  ).toList(),
                  args: AddProductArguments(
                    widget.tabsData,
                    widget.tabs,
                    widget.title,
                    widget._currentTab,
                  ),
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
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    ]);
  }
}
