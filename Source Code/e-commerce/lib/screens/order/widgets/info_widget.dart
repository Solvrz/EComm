import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/constant.dart';
import '../../../models/product.dart';
import '../../../widgets/marquee.dart';

class InfoWidget extends StatelessWidget {
  final Map order;
  final bool overflow;

  InfoWidget({required this.order, this.overflow = false});

  @override
  Widget build(BuildContext context) {
    DateTime timestamp = order["time"].toString().toDate();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Name: ",
              style: TextStyle(
                color: kUIDarkText,
                fontSize: screenSize.height(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                "${order['name'].toString().capitalize()}"
                    .replaceAll("", "\u{200B}"),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: screenSize.height(18),
                  color: kUIDarkText,
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
                    fontSize: screenSize.height(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${timestamp.day}-${timestamp.month}-${timestamp.year}"
                      .replaceAll("", "\u{200B}"),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: kUIDarkText,
                    fontSize: screenSize.height(18),
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Phone: ",
              style: TextStyle(
                color: kUIDarkText,
                fontSize: screenSize.height(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                "${order['phone']}",
                style: TextStyle(
                  fontSize: screenSize.height(18),
                  color: kUIDarkText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "Time: ",
                  style: TextStyle(
                    color: kUIDarkText,
                    fontSize: screenSize.height(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${timestamp.hour.toString().padLeft(2, "0")}:${timestamp.minute.toString().padLeft(2, "0")}"
                      .replaceAll("", "\u{200B}"),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: kUIDarkText,
                    fontSize: screenSize.height(18),
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Email: ",
              style: TextStyle(
                color: kUIDarkText,
                fontSize: screenSize.height(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${order['email']}",
              style: TextStyle(
                color: kUIDarkText,
                fontSize: screenSize.height(18),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Address: ",
              style: TextStyle(
                color: kUIDarkText,
                fontSize: screenSize.height(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                "${order['address'].toString().capitalize()}, ${order['pincode']}"
                    .replaceAll("", "\u{200B}"),
                overflow: overflow ? null : TextOverflow.ellipsis,
                maxLines: overflow ? 3 : 1,
                style: TextStyle(
                  color: kUIDarkText,
                  fontSize: screenSize.height(18),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Divider(height: 15),
        Row(
          children: [
            Text(
              "Payment Mode: ",
              style: TextStyle(
                color: kUIDarkText,
                fontSize: screenSize.height(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                "${order['payment_mode']}".replaceAll("", "\u{200B}"),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kUIDarkText,
                  fontSize: screenSize.height(18),
                  fontWeight: FontWeight.w500,
                ),
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
                fontSize: screenSize.height(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                "₹ ${order['price']}".replaceAll("", "\u{200B}"),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kUIDarkText,
                  fontSize: screenSize.height(18),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Total Items: ",
              style: TextStyle(
                color: kUIDarkText,
                fontSize: screenSize.height(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                "${order["products"].length} items".replaceAll("", "\u{200B}"),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kUIDarkText,
                  fontSize: screenSize.height(18),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Divider(height: 15),
        SizedBox(height: 8),
      ],
    );
  }
}

class OrderSheet extends StatelessWidget {
  final Map order;

  OrderSheet(this.order);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        padding: screenSize.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: TextStyle(
                color: kUIDarkText,
                fontSize: screenSize.height(32),
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(height: 10),
            SizedBox(height: 10),
            Container(
              height: order["products"].length > 3
                  ? screenSize.height(375)
                  : screenSize.height(275),
              child: ListView.builder(
                  itemCount: order["products"].length,
                  itemBuilder: (BuildContext context, int index) {
                    Product product =
                        Product.fromJson(order["products"][index]["product"]);

                    return Container(
                      margin: screenSize.symmetric(vertical: 8),
                      height: MediaQuery.of(context).size.height / 6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context).highlightColor),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: screenSize.symmetric(
                                  horizontal: 24, vertical: 18),
                              child: Row(
                                children: [
                                  product.images.length > 0
                                      ? Container(
                                          width: screenSize.height(100),
                                          child: CachedNetworkImage(
                                            imageUrl: product.images[0],
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                              baseColor: Theme.of(context)
                                                  .highlightColor,
                                              highlightColor: Colors.grey[100]!,
                                              child:
                                                  Container(color: Colors.grey),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        )
                                      : Text("No Image"),
                                  SizedBox(width: 24),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Marquee(
                                          child: Text(
                                            "${product.name} × ${order["products"][index]["quantity"]}",
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: screenSize.height(22),
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    "sans-serif-condensed",
                                                letterSpacing: -0.4),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "₹ ${product.price}",
                                              style: TextStyle(
                                                  color: kUIDarkText,
                                                  fontSize:
                                                      screenSize.height(20),
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
                                                  fontSize:
                                                      screenSize.height(18),
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily:
                                                      "sans-serif-condensed"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      product.selected!.length,
                                      (index) => CircleAvatar(
                                        radius: 12,
                                        backgroundColor: product
                                                .selected!.values
                                                .toList()[index]
                                                .color ??
                                            Colors.grey[400],
                                        child: product.selected!.values
                                                    .toList()[index]
                                                    .color ==
                                                null
                                            ? Text(
                                                product.selected!.values
                                                    .toList()[index]
                                                    .label[0]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize:
                                                        screenSize.height(13),
                                                    fontWeight: FontWeight.w600,
                                                    color: kUIDarkText),
                                              )
                                            : null,
                                      ),
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
            Divider(height: 10),
            Text(
              "Delivery Information:",
              style: TextStyle(
                color: kUIDarkText,
                fontSize: screenSize.height(26),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            InfoWidget(
              order: order,
              overflow: true,
            )
          ],
        ),
      ),
    );
  }
}
