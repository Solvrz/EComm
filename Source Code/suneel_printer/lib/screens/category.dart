import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suneel_printer/components/category.dart';
import 'package:suneel_printer/components/home.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/screens/add_product.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String title;
  dynamic screen;

  @override
  Widget build(BuildContext context) {
    CategoryArguments args = ModalRoute.of(context).settings.arguments;

    title = args.data["name"].split("\n").join(" ");

    return SafeArea(
      child: FutureBuilder<QuerySnapshot>(
          future: args.docRef.docs.first.reference
              .collection("tabs")
              .orderBy("uId")
              .get(),
          builder: (context, snapshot) {
            var screen;

            if (snapshot.hasData)
              screen = title != "Printing" && title != "Binding"
                  ? CategoryProductPage(
                      title,
                      snapshot.data.docs
                          .map<Map>(
                            (DocumentSnapshot e) => e.data(),
                          )
                          .toList(),
                      snapshot.data.docs
                          .map<DocumentReference>(
                              (DocumentSnapshot e) => e.reference)
                          .toList(),
                    )
                  : OrderProductPage(
                      title: title,
                      tabsData: snapshot.data.docs
                          .map<Map>(
                            (DocumentSnapshot e) => e.data(),
                          )
                          .toList(),
                    );

            return Scaffold(
              backgroundColor: kUIColor,
              resizeToAvoidBottomInset: false,
              floatingActionButton: admin && screen != null
                  ? Builder(
                      builder: (context) => screen.getFab(context),
                    )
                  : null,
              body: Column(children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back_ios,
                              color: kUIDarkText, size: 26),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 24,
                                color: kUIDarkText,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: admin
                            ? () {}
                            : () => Navigator.pushNamed(context, "/bag"),
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: admin
                                ? SizedBox(height: 34, width: 34)
                                : Image.asset("assets/images/ShoppingBag.png",
                                    width: 30, height: 30)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: snapshot.hasData
                      ? screen
                      : Center(
                          child: Text("Loading..."),
                        ),
                )
              ]),
            );
          }),
    );
  }
}

// ignore: must_be_immutable
class CategoryProductPage extends StatefulWidget {
  final String title;
  final List<Map> tabsData;
  final List<DocumentReference> tabs;
  int _currentTab = 0;

  CategoryProductPage(this.title, this.tabsData, this.tabs);

  Widget getFab(BuildContext context) => FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: kUIAccent, size: 30),
        onPressed: () async {
          Navigator.pushNamed(
            context,
            "/add_prdouct",
            arguments: AddProductArguments(
                tabsData: tabsData,
                tabs: tabs,
                title: title,
                currentTab: _currentTab),
          );
        },
      );

  @override
  _CategoryProductPageState createState() => _CategoryProductPageState();
}

class _CategoryProductPageState extends State<CategoryProductPage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: kUIColor,
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.grey[400], width: 1),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(widget.tabs.length, (int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: () {
                      if (index == widget._currentTab) return;
                      setState(() {
                        widget._currentTab = index;
                      });
                    },
                    child: AnimatedDefaultTextStyle(
                      child: Text(
                        widget.tabsData[index]["name"].split("\\n").join("\n"),
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(milliseconds: 150),
                      style: TextStyle(
                          fontSize: index == widget._currentTab ? 16 : 14,
                          fontWeight: index == widget._currentTab
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: index == widget._currentTab
                              ? kUIDarkText
                              : Colors.grey[600]),
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
            if (future.data.docs.isNotEmpty) {
              return Expanded(
                child: ProductList(
                  products: future.data.docs
                      .map<Product>(
                        (DocumentSnapshot e) => Product.fromJson(
                          e.data(),
                        ),
                      )
                      .toList(),
                  args: AddProductArguments(
                      tabsData: widget.tabsData,
                      tabs: widget.tabs,
                      title: widget.title,
                      currentTab: widget._currentTab),
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
                child: Text("Loading..."),
              ),
            );
          }
        },
      ),
    ]);
  }
}

// ignore: must_be_immutable
class OrderProductPage extends StatefulWidget {
  String title;
  List tabsData;
  OrderProductPage({this.title, this.tabsData});
  @override
  _OrderProductPageState createState() => _OrderProductPageState();
}

class _OrderProductPageState extends State<OrderProductPage> {
  String value;

  @override
  void initState() {
    super.initState();
    value = "Choose a Service";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                height: 100.0,
                width: MediaQuery.of(context).size.width / 1.5,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Service: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton(
                          hint: Text(value),
                          onChanged: (val) {
                            setState(() {
                              value = val;
                            });
                          },
                          items: List.generate(widget.tabsData.length,
                                  (index) => widget.tabsData[index]["name"])
                              .map<DropdownMenuItem>(
                                (var val) => DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[900],
                                        letterSpacing: 0.2,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "sans-serif-condensed"),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      ]),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  height: 130.0,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: selectedInfo == null
                        ? Center(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (_) => Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: InformationSheet(
                                      parentContext: context,
                                    ),
                                  ),
                                );

                                setState(() {});
                              },
                              child: Text(
                                "Pick Info",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "sans-serif-condensed",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Name: ",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "sans-serif-condensed",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${selectedInfo['name'].toString().capitalize()}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[900],
                                            fontFamily: "sans-serif-condensed",
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () async {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (_) => Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: InformationSheet(
                                              parentContext: context,
                                            ),
                                          ),
                                        );

                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 25,
                                        color: kUIDarkText.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Phone: ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "sans-serif-condensed",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${selectedInfo['phone']}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[900],
                                        fontFamily: "sans-serif-condensed",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Email: ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "sans-serif-condensed",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${selectedInfo['email']}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[900],
                                        fontFamily: "sans-serif-condensed",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Address: ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "sans-serif-condensed",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${selectedInfo['address'].toString().capitalize()}, ${selectedInfo['pincode']}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[900],
                                          fontFamily: "sans-serif-condensed",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                  ))
            ]),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: value != "Choose a Service" && selectedInfo != null
                    ? () async {
                        await http.post(
                          "https://suneel-printers.herokuapp.com/on_order",
                          headers: <String, String>{
                            "Content-Type": "application/json; charset=UTF-8",
                          },
                          body: jsonEncode(<String, String>{
                            "name": selectedInfo["name"],
                            "phone": selectedInfo["phone"],
                            "address": selectedInfo["address"],
                            "email": selectedInfo["email"],
                            "order_list": value
                          }),
                        );

                        // TODO: SHow Order Sucessful Screen

                        Navigator.pop(context);
                      }
                    : null,
                disabledColor: kUIDarkText.withOpacity(0.5),
                color: kUIAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.grey[200]),
                    SizedBox(width: 8),
                    Text("Place Order",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[200])),
                  ],
                ),
              ),
            )
          ]),
    );
  }
}

class CategoryArguments {
  final Map<String, dynamic> data;
  final QuerySnapshot docRef;

  CategoryArguments(this.data, this.docRef);
}
