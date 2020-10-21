import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/components/rounded_alert_dialog.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/screens/add_product.dart';
import 'package:suneel_printer/screens/product.dart';

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

            if (snapshot.hasData) {
              print(title != "Binding");
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
                      // TODO On-Order Page

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
                    );
            }

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
                            : () => Navigator.pushNamed(context, "/cart"),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                              admin ? null : Icons.shopping_cart_outlined,
                              size: 26),
                        ),
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
  final String title;
  final List<Map> tabsData;
  final List<DocumentReference> tabs;
  int _currentTab = 0;

  OrderProductPage(this.title, this.tabsData, this.tabs);

  @override
  _OrderProductPageState createState() => _OrderProductPageState();
}

class _OrderProductPageState extends State<OrderProductPage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Container(
      //   padding: EdgeInsets.symmetric(vertical: 6),
      //   width: MediaQuery.of(context).size.width,
      //   decoration: BoxDecoration(
      //     color: kUIColor,
      //     border: Border.symmetric(
      //       horizontal: BorderSide(color: Colors.grey[400], width: 1),
      //     ),
      //   ),
      //   child: SingleChildScrollView(
      //     scrollDirection: Axis.horizontal,
      //     child: Row(
      //       children: [
      //         ...List.generate(widget.tabs.length, (int index) {
      //           return Padding(
      //             padding: EdgeInsets.symmetric(horizontal: 24),
      //             child: GestureDetector(
      //               onTap: () {
      //                 if (index == widget._currentTab) return;
      //                 setState(() {
      //                   widget._currentTab = index;
      //                 });
      //               },
      //               child: AnimatedDefaultTextStyle(
      //                 child: Text(
      //                   widget.tabsData[index]["name"].split("\\n").join("\n"),
      //                   textAlign: TextAlign.center,
      //                 ),
      //                 duration: Duration(milliseconds: 150),
      //                 style: TextStyle(
      //                     fontSize: index == widget._currentTab ? 16 : 14,
      //                     fontWeight: index == widget._currentTab
      //                         ? FontWeight.w600
      //                         : FontWeight.normal,
      //                     color: index == widget._currentTab
      //                         ? kUIDarkText
      //                         : Colors.grey[600]),
      //               ),
      //             ),
      //           );
      //         })
      //       ],
      //     ),
      //   ),
      // ),
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

class ProductList extends StatefulWidget {
  ProductList({@required this.products, this.args});

  final List<Product> products;
  final AddProductArguments args;

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
      children: List.generate(
        widget.products.length,
        (index) => ProductCard(widget.products[index], widget.args),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  final AddProductArguments args;

  ProductCard(this.product, this.args);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            setState(() {});
          });
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
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
          padding: EdgeInsets.fromLTRB(12, admin ? 12 : 24, 12, 0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400], width: 0.5)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Align(
                alignment: Alignment.centerRight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 24, 12, 0),
                      child: widget.product.images != null
                          ? Container(
                              height: height / 1.8,
                              constraints: BoxConstraints(maxWidth: width - 64),
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[600],
                                    blurRadius: 12,
                                    offset: Offset(2, 2))
                              ]),
                              child: Image(image: widget.product.images[0]))
                          : Container(
                              height: height / 2,
                              child: Center(
                                child: Text("No Image Provided"),
                              ),
                            ),
                    ),
                    if (admin)
                      Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                if (!_animationController.isAnimating) {
                                  if (_animationController.isCompleted)
                                    _animationController.reverse();
                                  else
                                    _animationController.forward();
                                }
                              },
                              child: AnimatedIcon(
                                icon: AnimatedIcons.menu_close,
                                progress: _animation,
                              )),
                          GestureDetector(
                            onTap: () async {
                              _animationController.reverse();

                              widget.args.product = widget.product;
                              Navigator.pushNamed(context, "/add",
                                  arguments: widget.args);
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 12 * _animation.value),
                              child: Icon(
                                Icons.edit,
                                size: 20 * _animation.value,
                                color: kUIDarkText.withOpacity(0.8),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => RoundedAlertDialog(
                                  title: "Do you want to delete this Product?",
                                  buttonsList: [
                                    FlatButton(
                                      onPressed: () => Navigator.pop(context),
                                      textColor: kUIAccent,
                                      child: Text("No"),
                                    ),
                                    FlatButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        _animationController.reverse();

                                        List<String> uIds =
                                            widget.product.uId.split("/");

                                        if (widget.product.images != null)
                                          widget.product.images
                                              .forEach((element) {
                                            FirebaseStorage.instance
                                                .getReferenceFromUrl(
                                                    element.url)
                                                .then(
                                                    (value) => value.delete());
                                          });

                                        QuerySnapshot category = await database
                                            .collection("categories")
                                            .where("uId",
                                                isEqualTo: int.parse(uIds[0]))
                                            .get();

                                        QuerySnapshot tab = await category
                                            .docs.first.reference
                                            .collection("tabs")
                                            .where("uId",
                                                isEqualTo: int.parse(uIds[1]))
                                            .get();

                                        QuerySnapshot product = await tab
                                            .docs.first.reference
                                            .collection("products")
                                            .where("uId",
                                                isEqualTo: widget.product.uId)
                                            .get();

                                        product.docs.first.reference.delete();

                                        QuerySnapshot query = await database.collection("products").where("uId", isEqualTo: widget.product.uId).get();
                                        query.docs.first.reference.delete();
                                      },
                                      textColor: kUIAccent,
                                      child: Text("Yes"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 8 * _animation.value),
                              child: Icon(
                                Icons.delete,
                                size: 20 * _animation.value,
                                color: kUIDarkText.withOpacity(0.8),
                              ),
                            ),
                          )
                        ],
                      )
                  ],
                )),
            SizedBox(height: 12),
            Text(
              "₹ ${widget.product.price}",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "sans-serif-condensed"),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: AutoSizeText(
                widget.product.name,
                maxLines: 2,
                minFontSize: 18,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    letterSpacing: 0.3, fontFamily: "sans-serif-condensed"),
              ),
            ),
          ])),
    );
  }
}

class CategoryArguments {
  final Map<String, dynamic> data;
  final QuerySnapshot docRef;

  CategoryArguments(this.data, this.docRef);
}
