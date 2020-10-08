import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/product.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double price = 0.0;

    cart.products.forEach((element) {
      price += double.parse(element["price"]) * element["quantity"];
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      "₹ ",
                      style: TextStyle(
                        color: kUIDarkText,
                        fontSize: 16,
                        fontFamily: "sans-serif-condensed",
                      ),
                    ),
                    Text(
                        price - price.toInt() == 0
                            ? price.toInt().toString()
                            : price.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            fontFamily: "sans-serif-condensed",
                            letterSpacing: -2,
                            color: kUIDarkText))
                  ],
                ),
              ),
              MaterialButton(
                color: kUIAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                textColor: kUILightText,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, size: 20),
                    SizedBox(width: 8),
                    Text("Checkout"),
                  ],
                ),
                onPressed: () {
                  return showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (_) => CheckOutSheet(price));
                },
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: kUIDarkText,
                        size: 26,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text("My Cart",
                          style: TextStyle(
                              fontSize: 24,
                              color: kUIDarkText,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  GestureDetector(
                    onTap: cart.isNotEmpty
                        ? () {
                            cart.clear();
                            setState(() {});
                          }
                        : () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        cart.isNotEmpty ? Icons.delete : null,
                        size: 26,
                        color: kUIDarkText.withOpacity(0.6),
                      ),
                    ),
                  )
                ],
              ),
            ),
            cart.products.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 24.0),
                    child: Scrollbar(
                        child: AnimatedList(
                      shrinkWrap: true,
                      key: _listKey,
                      initialItemCount: cart.products.length,
                      itemBuilder: (BuildContext context, int index,
                              Animation<double> animation) =>
                          _buildItem(context, index, animation),
                    )),
                  )
                : Expanded(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.25,
                        child: EmptyListWidget(
                          packageImage: PackageImage.Image_2,
                          title: "No Items",
                          subTitle: "Shop and add more items",
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Slidable(
        key: ObjectKey(cart.products[index]),
        actionPane: SlidableDrawerActionPane(),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, "/product",
              arguments: ProductArguments(cart.products[index])),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.white),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    child: Row(
                      children: [
                        cart.products[index]["img"] != null &&
                                cart.products[index]["img"] != ""
                            ? Image.network(cart.products[index]["img"])
                            : Text("No Image Provided"),
                        SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  cart.products[index]["name"],
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "sans-serif-condensed",
                                      letterSpacing: -0.4),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  "₹ ${cart.products[index]["price"]}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -1,
                                      fontFamily: "sans-serif-condensed"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 6,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (cart.productInfo(
                                  cart.products[index]["uId"])["quantity"] >
                              1)
                            cart.decreaseQuantity(cart.products[index]["uId"]);
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.remove, color: kUIColor, size: 20),
                        ),
                      ),
                      Text(
                          cart
                              .productInfo(
                                  cart.products[index]["uId"])["quantity"]
                              .toString(),
                          style: TextStyle(
                              color: kUIColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                      GestureDetector(
                        onTap: () async {
                          cart.increaseQuantity(cart.products[index]["uId"]);
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
                )
              ],
            ),
          ),
        ),
        secondaryActions: [
          GestureDetector(
            onTap: () {
              Timer(Duration(milliseconds: 200), () {
                cart.removeItem(cart.products[index]["uId"]);
                setState(() {});
              });
              _listKey.currentState.removeItem(index,
                  (context, animation) => _buildItem(context, index, animation),
                  duration: Duration(milliseconds: 200));
            },
            child: Container(
              margin: EdgeInsets.only(left: 12),
              height: MediaQuery.of(context).size.height / 6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: kUIAccent),
              child: Icon(Icons.delete, color: kUILightText, size: 32),
            ),
          )
        ],
      ),
    );
  }
}

class CheckOutSheet extends StatefulWidget {
  final double price;

  CheckOutSheet(this.price);

  @override
  _CheckOutSheetState createState() => _CheckOutSheetState();
}

class _CheckOutSheetState extends State<CheckOutSheet> {
  String name = "Your name";
  String phone = "Your phone number";
  String address = "Your address";
  String editing = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Icon(Icons.close, color: kUIDarkText),
                ),
              ),
              Text("Check Out",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text("Name",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            editing = "name";
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.edit_outlined,
                              color: Colors.grey[500]),
                        ),
                      )
                    ],
                  ),
                  editing == "name"
                      ? TextField(
                          decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none),
                          controller: TextEditingController(text: name),
                          autofocus: true,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500),
                          onChanged: (String value) {
                            name = value;
                          },
                          onEditingComplete: () {
                            setState(() {
                              editing = "";
                            });
                          },
                        )
                      : Text(name,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500)),
                  SizedBox(height: 12),
                  Divider(
                    height: 20,
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Phone Number",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            editing = "phone";
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.edit_outlined,
                              color: Colors.grey[500]),
                        ),
                      )
                    ],
                  ),
                  editing == "phone"
                      ? TextField(
                          scrollPadding: EdgeInsets.zero,
                          decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none),
                          controller: TextEditingController(text: phone),
                          autofocus: true,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500),
                          onChanged: (String value) {
                            phone = value;
                          },
                          onEditingComplete: () {
                            setState(() {
                              editing = "";
                            });
                          },
                        )
                      : Text(phone,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500)),
                  SizedBox(height: 12),
                  Divider(
                    height: 20,
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Shipping Address",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            editing = "address";
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.edit_outlined,
                              color: Colors.grey[500]),
                        ),
                      )
                    ],
                  ),
                  editing == "address"
                      ? TextField(
                          maxLines: 4,
                          minLines: 1,
                          decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none),
                          controller: TextEditingController(text: address),
                          autofocus: true,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500),
                          onChanged: (String value) {
                            address = value;
                          },
                          onEditingComplete: () {
                            setState(() {
                              editing = "";
                            });
                          },
                        )
                      : Text(address,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500)),
                  SizedBox(height: 12),
                  Divider(
                    height: 36,
                    thickness: 2,
                  ),
                  Text("${cart.products.length} Items",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600])),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Total:",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Text("₹ ",
                          style: TextStyle(
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                          widget.price - widget.price.toInt() == 0
                              ? widget.price.toInt().toString()
                              : widget.price.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  SizedBox(height: 32),
                  Center(
                    child: MaterialButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      onPressed: () {
                        //TODO: Implement Proceed To Buy
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: kUIAccent,
                      child: Text("Proceed To Buy",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.w600,
                              color: kUILightText)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
