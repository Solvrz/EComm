import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool added;

  @override
  Widget build(BuildContext context) {
    ProductArguments args = ModalRoute.of(context).settings.arguments;

    if (added == null) added = cart.containsProduct(args.data["uId"]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: kUIColor)),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(left: 16, top: 16),
                      child: Icon(Icons.arrow_back_ios, color: kUIDarkText),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/cart"),
                    child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: kUIColor)),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(right: 26, top: 16),
                      child: Icon(Icons.shopping_cart_outlined,
                          color: kUIDarkText),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
              child: Text(
                args.data["name"],
                style: TextStyle(
                    fontSize: 28,
                    fontFamily: "sans-serif-condensed",
                    letterSpacing: 0.2),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.25 + 24,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                    height: MediaQuery.of(context).size.height / 2.25,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                          Color(int.parse("0xff${args.data["bgColor"]}"))
                              .withOpacity(0.6),
                          kUIColor
                        ],
                            stops: [
                          0.5,
                          0.9
                        ])),
                    child: Row(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height / 3,
                            child: Image.network(
                              args.data["img"],
                              fit: BoxFit.fill,
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("PRICE",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    )),
                                SizedBox(height: 4),
                                Text("₹ ${args.data["price"]}",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: "sans-serif-condensed",
                                      color: kUIDarkText,
                                    )),
                                SizedBox(height: 48),
                                Text("TYPE",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    )),
                                SizedBox(height: 4),
                                Text("Single Lined",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: "sans-serif-condensed",
                                      color: kUIDarkText,
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 40,
                      child: Container(
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: kUIAccent,
                            boxShadow: [
                              BoxShadow(
                                  color: kUIAccent.withOpacity(0.6),
                                  offset: Offset(4, 4),
                                  blurRadius: 8)
                            ]),
                        child: Icon(Icons.favorite, color: kUIColor, size: 20),
                      ))
                ],
              ),
            ),
            SizedBox(height: 128),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: FlatButton(
                      onPressed: () {
                        if (!added) setState(() {
                          added = true;
                          cart.addItem(args.data);
                        });
                      },
                      color: !added ? kUIAccent : Colors.grey,
                      textColor: kUILightText,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(!added
                              ? Icons.add_shopping_cart
                              : Icons.shopping_basket),
                          SizedBox(width: 8),
                          Text(!added ? "ADD TO CART" : "IN CART"),
                        ],
                      )),
                ),
                if (added) ...[
                  SizedBox(width: 24),
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            cart.increaseQuantity(args.data["uId"]);
                            setState(() {});
                          },
                          child: Text("+", style: TextStyle(fontSize: 24))),
                      Text(
                          cart
                              .productInfo(args.data["uId"])["quantity"]
                              .toString(),
                          style: TextStyle(fontSize: 24)),
                        GestureDetector(
                            onTap: () {
                              cart.decreaseQuantity(args.data["uId"]);
                              setState(() {
                                if (cart.productInfo(args.data["uId"]) == null) added = false;
                              });
                            },
                            child: Text("-", style: TextStyle(fontSize: 26))),
                    ],
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProductArguments {
  final Map data;

  ProductArguments(this.data);
}
