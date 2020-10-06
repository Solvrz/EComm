import 'package:cloud_firestore/cloud_firestore.dart';
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
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back_ios,
                          color: kUIDarkText, size: 26),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(args.title,
                          style: TextStyle(
                              fontSize: 24,
                              color: kUIDarkText,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/cart"),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.shopping_cart_outlined, size: 26),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: kUIColor,
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(color: Colors.grey[400], width: 1))),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(args.tabs.length, (int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: GestureDetector(
                          onTap: () {
                            if (index == _currentTab) return;
                            setState(() {
                              _currentTab = index;
                            });
                          },
                          child: AnimatedDefaultTextStyle(
                            child: Text(
                              args.tabsData[index]["name"]
                                  .split("\\n")
                                  .join("\n"),
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(milliseconds: 150),
                            style: TextStyle(
                                fontSize: index == _currentTab ? 16 : 14,
                                fontWeight: index == _currentTab
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: index == _currentTab
                                    ? Colors.black
                                    : Colors.grey[600]),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: args.tabs[_currentTab].collection("products").get(),
              builder: (context, future) {
                if (future.hasData) {
                  if (future.data.docs.isNotEmpty) {
                    return Expanded(
                        child: ProductList(
                            products: future.data.docs
                                .map<Map<String, dynamic>>(
                                    (DocumentSnapshot e) => e.data())
                                .toList()));
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
                      child: Center(child: Text("Loading...")));
                }
              },
            ),
          ])),
    );
  }
}

class ProductList extends StatefulWidget {
  ProductList({@required this.products});

  final List<Map> products;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 0.8,
      children: List.generate(widget.products.length,
          (index) => ProductCard(widget.products[index])),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductCard(this.product);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            setState(() {});
          });
    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);

    if (cart.containsProduct(widget.product["uId"]))
      animationController.value = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 2;
    final double height = width / 0.8;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/product",
            arguments: ProductArguments(widget.product));
      },
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400], width: 0.5)),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () {
                              if (wishlist
                                  .containsProduct(widget.product["uId"])) {
                                wishlist.removeItem(widget.product["uId"]);
                              } else {
                                wishlist.addItem(widget.product);
                              }
                              setState(() {});
                            },
                            child: Icon(
                              wishlist.containsProduct(widget.product["uId"])
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: wishlist
                                      .containsProduct(widget.product["uId"])
                                  ? kUIAccent
                                  : kUIDarkText,
                            )),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[600],
                                    blurRadius: 20,
                                    offset: Offset(2, 2))
                              ]),
                              child: Image.network(widget.product["img"],
                                  height: height / 2)),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text("₹ ${widget.product["price"]}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sans-serif-condensed")),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Text(widget.product["name"],
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 0.2,
                                fontFamily: "sans-serif-condensed")),
                      ),
                    ]),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(20))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (cart.containsProduct(widget.product["uId"]) ||
                          animationController.isAnimating)
                        SizeTransition(
                          sizeFactor: animation,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (cart.productInfo(
                                          widget.product["uId"])["quantity"] ==
                                      1) animationController.reverse();
                                  cart.decreaseQuantity(widget.product["uId"]);
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(Icons.remove,
                                      color: kUIColor, size: 20),
                                ),
                              ),
                              Text(
                                  ((cart.productInfo(widget.product["uId"]) ??
                                              {})["quantity"] ??
                                          "0")
                                      .toString(),
                                  style: TextStyle(
                                      color: kUIColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      GestureDetector(
                        onTap: () async {
                          if (cart.containsProduct(widget.product["uId"])) {
                            cart.increaseQuantity(widget.product["uId"]);
                          } else {
                            cart.addItem(widget.product);
                            animationController.forward();
                          }
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.add,
                            color: kUIColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class CategoryArguments {
  final String title;
  final List<Map> tabsData;
  final List<DocumentReference> tabs;
  final DocumentReference docRef;

  CategoryArguments(this.title, this.tabsData, this.tabs, this.docRef);
}
