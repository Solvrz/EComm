import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/components/rounded_alert_dialog.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/product.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
          height: MediaQuery
              .of(context)
              .size
              .height * 0.1,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      "₹ ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "sans-serif-condensed",
                      ),
                    ),
                    Text(price.toString(),
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            fontFamily: "sans-serif-condensed",
                            letterSpacing: -2,
                            color: Colors.black))
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
                  final TextEditingController name = TextEditingController();
                  final TextEditingController phone = TextEditingController();
                  final TextEditingController address = TextEditingController();

                  return showBottomSheet(
                      context: context,
                      builder: (_) =>
                          Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height - 300,
                            margin: EdgeInsets.only(top: 50),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[600],
                                    blurRadius: 12,
                                    offset: Offset(0, -2))
                              ],
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: TextField(
                                        controller: name,
                                        maxLines: 3,
                                        minLines: 1,
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                          hintText: "Name *",
                                          border: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: TextField(
                                        controller: phone,
                                        maxLines: 3,
                                        minLines: 1,
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                          hintText: "Phone *",
                                          border: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: TextField(
                                        controller: address,
                                        maxLines: 3,
                                        minLines: 1,
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                          hintText: "Adderess *",
                                          border: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 100),
                                    Container(
                                      height: 60,
                                      width: 300,
                                      child: FlatButton(
                                          color: kUIAccent,
                                          textColor: kUILightText,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.store),
                                              SizedBox(width: 8),
                                              Text("Place Order"),
                                            ],
                                          ),
                                          onPressed: () {
                                            if (name.text != "" ||
                                                phone.text != "" ||
                                                address.text != "") {
                                              name.clear();
                                              phone.clear();
                                              address.clear();

                                              Navigator.pop(context);

                                              showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    RoundedAlertDialog(
                                                      title:
                                                      "Your Order has been placed.",
                                                      buttonsList: [
                                                        FlatButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Ok",
                                                            style: TextStyle(
                                                                color: kUIAccent,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              );
                                            } else {
                                              name.clear();
                                              phone.clear();
                                              address.clear();

                                              Navigator.pop(context);
                                              FocusScope.of(context).unfocus();

                                              Scaffold.of(context)
                                                  .removeCurrentSnackBar();
                                              Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Details can't be empty",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  backgroundColor: kUIAccent,
                                                ),
                                              );
                                            }
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ));
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
                    onTap: () {
                      Navigator.pop(context);
                    },
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
                    onTap: () {
                      cart.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.delete,
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cart.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, "/product",
                                arguments:
                                ProductArguments(cart.products[index])),
                        child: Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 18),
                                  child: Row(
                                    children: [
                                      Image.network(cart.products[index]["img"]),
                                      SizedBox(width: 24),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              cart.products[index]["name"],
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                  "sans-serif-condensed",
                                                  letterSpacing: -0.4),
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
                                                    fontFamily:
                                                    "sans-serif-condensed"),
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
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 6,
                                decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        cart.decreaseQuantity(
                                            cart.products[index]["uId"]);
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Icon(Icons.remove,
                                            color: kUIColor, size: 20),
                                      ),
                                    ),
                                    Text(
                                        cart
                                            .productInfo(cart.products[index]
                                        ["uId"])["quantity"]
                                            .toString(),
                                        style: TextStyle(
                                            color: kUIColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                    GestureDetector(
                                      onTap: () async {
                                        cart.increaseQuantity(
                                            cart.products[index]["uId"]);
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
                      );
                    },
                  )),
            )
                : Center(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 1.25,
                child: EmptyListWidget(
                  title: "No Items",
                  subTitle: "Shop and add more items",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
