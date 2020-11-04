import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/screens/product.dart';

class PastOrderSheet extends StatelessWidget {
  final Map order;

  PastOrderSheet(this.order);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: order["products"].length > 3
            ? MediaQuery.of(context).size.height / 1.05
            : MediaQuery.of(context).size.height / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: kUIColor,
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Summary",
                    style: TextStyle(
                      color: kUIDarkText,
                      fontSize: 32,
                      fontFamily: "sans-serif-condensed",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(thickness: 2, height: 10),
                  Text(
                    "Products:",
                    style: TextStyle(
                      color: kUIDarkText,
                      fontSize: 26,
                      fontFamily: "sans-serif-condensed",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: order["products"].length > 3
                        ? MediaQuery.of(context).size.height * 375 / 816
                        : MediaQuery.of(context).size.height * 275 / 816,
                    child: ListView.builder(
                        itemCount: order["products"].length,
                        itemBuilder: (BuildContext context, int index) {
                          Product product = Product.fromJson(
                              order["products"][index]["product"]);

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.grey[200]),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 18),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                            context,
                                            "/product",
                                            arguments:
                                                ProductArguments(product),
                                          ),
                                          child: product.images.length > 0
                                              ? Image(image: product.images[0])
                                              : Text("No Image Provided"),
                                        ),
                                        SizedBox(width: 24),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "${product.name} × ${order["products"][index]["quantity"]}",
                                                maxLines: 3,
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        "sans-serif-condensed",
                                                    letterSpacing: -0.4),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "₹ ${product.price}",
                                                    style: TextStyle(
                                                        color: kUIDarkText,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            "sans-serif-condensed"),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    "₹ ${product.mrp}",
                                                    style: TextStyle(
                                                        color: kUIDarkText
                                                            .withOpacity(0.7),
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontFamily:
                                                            "sans-serif-condensed"),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  Divider(thickness: 2, height: 10),
                  Text(
                    "Delivery Information:",
                    style: TextStyle(
                      color: kUIDarkText,
                      fontSize: 26,
                      fontFamily: "sans-serif-condensed",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name: ",
                        style: TextStyle(
                          color: kUIDarkText,
                          fontSize: 20,
                          fontFamily: "sans-serif-condensed",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${order['name'].toString().capitalize()}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            color: kUIDarkText,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Date: ",
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: 20,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${order['time'].toDate().toString().split(" ")[0].split("-").reversed.join("-")}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: 18,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Phone: ",
                        style: TextStyle(
                          color: kUIDarkText,
                          fontSize: 20,
                          fontFamily: "sans-serif-condensed",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${order['phone']}",
                        style: TextStyle(
                          fontSize: 18,
                          color: kUIDarkText,
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
                          color: kUIDarkText,
                          fontSize: 20,
                          fontFamily: "sans-serif-condensed",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${order['email']}",
                        style: TextStyle(
                          color: kUIDarkText,
                          fontSize: 18,
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
                          color: kUIDarkText,
                          fontSize: 20,
                          fontFamily: "sans-serif-condensed",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${order['address'].toString().capitalize()}, ${order['pincode']}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            color: kUIDarkText,
                            fontSize: 18,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 15, thickness: 2),
                  Row(
                    children: [
                      Text(
                        "Payment Mode: ",
                        style: TextStyle(
                          color: kUIDarkText,
                          fontSize: 20,
                          fontFamily: "sans-serif-condensed",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${order['payment_mode']}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kUIDarkText,
                          fontSize: 18,
                          fontFamily: "sans-serif-condensed",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Total Price: ",
                        style: TextStyle(
                          color: kUIDarkText,
                          fontSize: 20,
                          fontFamily: "sans-serif-condensed",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹ ${order['price']}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kUIDarkText,
                          fontSize: 18,
                          fontFamily: "sans-serif-condensed",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 15, thickness: 2),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
