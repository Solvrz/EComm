import 'dart:async';

import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool added = false;

  @override
  Widget build(BuildContext context) {
    ProductArguments args = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            args.title,
            style: TextStyle(color: kUILightText),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, "/cart"),
            child: Icon(Icons.shopping_cart),
            backgroundColor: kUIAccent),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Image.network(args.img),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    args.title,
                    style: TextStyle(fontSize: 22, color: kUIDarkText),
                  ),
                  Text(
                    "₹ ${args.price}",
                    style: TextStyle(color: Colors.green, fontSize: 22),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              height: 60,
              width: 300,
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      added = true;
                    });
                    Timer(Duration(milliseconds: 300),
                        () => Navigator.pushReplacementNamed(context, "/cart"));
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
                      Text(!added ? "Add to Cart" : "In Cart"),
                    ],
                  )),
            )
          ]),
        ),
      ),
    );
  }
}

class ProductArguments {
  String title;
  String img;
  String price;

  ProductArguments(this.title, this.img, this.price);
}
