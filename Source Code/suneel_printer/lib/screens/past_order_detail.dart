import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/bag.dart';
import 'package:suneel_printer/models/product.dart';

class PastOrderDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PastOrderDetailArguments args =
        ModalRoute.of(context).settings.arguments;

    double price = 0;

    args.orderDetails.forEach((element) {
      price += double.parse(element.product.price) * element.quantity;
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
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
                    color: kUIDarkText),
              ),
              SizedBox(width: 12),
              Text("(${bag.products.length} items)",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600])),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
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
                      child: Text(
                        "Order Details",
                        style: TextStyle(
                            fontFamily: "sans-serif-condensed",
                            color: kUIDarkText,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: null,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        null,
                        color: kUIDarkText,
                        size: 28,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: bag.products.length,
                  itemBuilder: (BuildContext context, int index) {
                    Product product = args.orderDetails[index].product;
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
                                  product.images.length > 0
                                      ? Image(image: product.images[0])
                                      : Text("No Image Provided"),
                                  SizedBox(width: 24),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 3,
                                          style: TextStyle(
                                              color: kUIDarkText,
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
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      "sans-serif-condensed"),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              "₹ ${product.mrp}",
                                              style: TextStyle(
                                                  color: kUIDarkText
                                                      .withOpacity(0.7),
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
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
                          if (product.selected.length > 0)
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 12, left: 4, top: 18, bottom: 18),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: List.generate(
                                  product.selected.length,
                                  (index) => CircleAvatar(
                                    radius: 12,
                                    backgroundColor: product.selected.values
                                            .toList()[index]
                                            .color ??
                                        Colors.grey[400],
                                    child: product.selected.values
                                                .toList()[index]
                                                .color ==
                                            null
                                        ? Text(
                                            product.selected.values
                                                .toList()[index]
                                                .label[0]
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontFamily:
                                                    "sans-serif-condensed",
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: kUIDarkText),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
            )),
          ],
        ),
      ),
    );
  }
}

class PastOrderDetailArguments {
  List<BagItem> orderDetails;

  PastOrderDetailArguments(this.orderDetails);
}
