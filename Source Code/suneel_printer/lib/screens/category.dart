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
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    CategoryArguments args = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: false,
        floatingActionButton: admin
            ? Builder(
                builder: (BuildContext context) => FloatingActionButton(
                      elevation: 10,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.add, color: kUIAccent, size: 30),
                      onPressed: () async {
                        Navigator.pushNamed(context, "/add",
                            arguments: AddProductArguments(args.tabsData,
                                args.tabs, args.title, _currentTab));
//                        final TextEditingController name =
//                            TextEditingController();
//                        final TextEditingController price =
//                            TextEditingController();
//
//                        await showDialog(
//                          context: context,
//                          builder: (_) => RoundedAlertDialog(
//                              titleSize: 22,
//                              title: "Add Product",
//                              centerTitle: true,
//                              isExpanded: false,
//                              otherWidgets: [
//                                Container(
//                                  margin: EdgeInsets.only(bottom: 8),
//                                  width: MediaQuery.of(context).size.width,
//                                  child: TextField(
//                                    maxLines: 2,
//                                    minLines: 1,
//                                    controller: name,
//                                    decoration: kInputDialogDecoration.copyWith(
//                                        hintText: "Name"),
//                                  ),
//                                ),
//                                Container(
//                                  margin: EdgeInsets.only(bottom: 8),
//                                  width: MediaQuery.of(context).size.width,
//                                  child: TextField(
//                                    maxLines: 1,
//                                    minLines: 1,
//                                    keyboardType: TextInputType.number,
//                                    controller: price,
//                                    decoration: kInputDialogDecoration.copyWith(
//                                        hintText: "Price"),
//                                  ),
//                                ),
//                              ],
//                              buttonsList: [
//                                AlertButton(
//                                    title: "Add Image",
//                                    onPressed: () async {
//                                      FocusScope.of(context).unfocus();
//
//                                      String fName = name.text;
//                                      String fPrice = price.text;
//
//                                      name.clear();
//                                      price.clear();
//

//                                    })
//                              ]),
//                        );
                      },
                    ))
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
                    child: Text(args.title,
                        style: TextStyle(
                            fontSize: 24,
                            color: kUIDarkText,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                if (!admin)
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
                    horizontal: BorderSide(color: Colors.grey[400], width: 1))),
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
            stream: args.tabs[_currentTab].collection("products").snapshots(),
            builder: (context, future) {
              if (future.hasData) {
                if (future.data.docs.isNotEmpty) {
                  return Expanded(
                      child: ProductList(
                          products: future.data.docs
                              .map<Product>((DocumentSnapshot e) =>
                                  Product.fromJson(e.data()))
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
        ]),
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  ProductList({@required this.products});

  final List<Product> products;

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
  final Product product;

  ProductCard(this.product);

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
                          Padding(
                            padding:
                                EdgeInsets.only(top: 12 * _animation.value),
                            child: Icon(
                              Icons.edit,
                              size: 20 * _animation.value,
                              color: kUIDarkText.withOpacity(0.8),
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
  final String title;
  final List<Map> tabsData;
  final List<DocumentReference> tabs;
  final DocumentReference docRef;

  CategoryArguments(this.title, this.tabsData, this.tabs, this.docRef);
}
