import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/product.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    CategoryArguments args = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
          backgroundColor: kUIColor,
          resizeToAvoidBottomInset: false,
          body: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 24),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                  color: kUIColor,
                  border: Border(
                      right: BorderSide(color: Colors.grey[400], width: 1))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14, bottom: 14),
                        child: Icon(Icons.arrow_back_ios, color: kUIDarkText),
                      ),
                    ),
                    ...List.generate(
                        args.tabs.length,
                        (int index) => RotatedBox(
                              quarterTurns: 3,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: GestureDetector(
                                  onTap: () {
                                    if (index == _currentTab) return;
                                    setState(() {
                                      _currentTab = index;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      if (index == _currentTab)
                                        Container(
                                            margin: EdgeInsets.only(right: 8),
                                            height: 2,
                                            width: 15,
                                            color: kUIAccent),
                                      AnimatedDefaultTextStyle(
                                        child: Text(
                                          args.tabs[index]["name"],
                                          textAlign: TextAlign.center,
                                        ),
                                        duration: Duration(milliseconds: 100),
                                        style: TextStyle(
                                            fontSize:
                                                index == _currentTab ? 16 : 14,
                                            fontWeight: index == _currentTab
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            color: index == _currentTab
                                                ? Colors.black
                                                : Colors.grey[600]),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ))
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(args.title,
                                style: TextStyle(
                                    fontSize: 24,
                                    color: kUIDarkText,
                                    fontWeight: FontWeight.bold)),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, "/cart"),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Icon(Icons.shopping_cart_outlined, size: 26),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 54),
                    (args.tabs[_currentTab]["products"] ?? []).isNotEmpty
                        ? Expanded(
                            child: ProductList(
                                products: args.tabs[_currentTab]["products"]))
                        : Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 1.5,
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: EmptyListWidget(
                                title: "No Product",
                                subTitle: "No Product Available Yet",
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}

class ProductList extends StatelessWidget {
  ProductList({@required this.products});

  final List<Map> products;

  @override
  Widget build(BuildContext context) {
    final double height = (MediaQuery.of(context).size.width * 0.9) / 1.33;
    final double width = (MediaQuery.of(context).size.width * 0.9) / 2.6;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: width / (height * 0.95),
      children: List.generate(
          products.length,
          (index) => GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/product",
                      arguments: ProductArguments(
                          products[index]["name"],
                          products[index]["img"],
                          products[index]["price"],
                          products[index]["bgColor"]));
                },
                child: Container(
                  width: width,
                  height: height,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: height / 3.25,
                        child: Container(
                          padding: EdgeInsets.only(left: 12, right: 24),
                          width: width,
                          height: height * 0.66,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[500],
                                    offset: Offset(6, 2),
                                    blurRadius: 12)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height * 0.2 + 42),
                              Text(products[index]["name"],
                                  style: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: 0.2,
                                      fontFamily: "sans-serif-condensed")),
                              SizedBox(height: 12),
                              Text("₹ ${products[index]["price"]}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 0.2,
                                      fontFamily: "sans-serif-condensed"))
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        child: Container(
                          height: height / 2,
                          width: width - 12,
                          decoration: BoxDecoration(
                              color: products[index]["bgColor"],
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    products[index]["bgColor"],
                                    products[index]["bgColor"].withOpacity(0.6)
                                  ],
                                  stops: [
                                    0.4,
                                    0.8
                                  ]),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[400],
                                    offset: Offset(2, -2),
                                    blurRadius: 4)
                              ]),
                        ),
                      ),
                      Image.network(products[index]["img"], height: height / 2)
                    ],
                  ),
                ),
              )),
    );
  }
}

class CategoryArguments {
  final String title;
  final List<Map> tabs;

  CategoryArguments(this.title, this.tabs);
}
