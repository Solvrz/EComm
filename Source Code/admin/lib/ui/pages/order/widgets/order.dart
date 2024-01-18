import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '/config/constant.dart';
import '/models/product.dart';
import '/tools/extensions.dart';
import '/ui/widgets/marquee.dart';

class InfoWidget extends StatelessWidget {
  final Map<dynamic, dynamic> order;
  final bool shortAddress;
  final bool large;

  const InfoWidget({
    super.key,
    required this.order,
    this.shortAddress = false,
    this.large = true,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime timestamp = order['time'].toDate();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Name: ",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: screenSize.height(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                order['name']
                    .toString()
                    .capitalize()
                    .replaceAll("", "\u{200B}"),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: screenSize.height(18),
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "Date: ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: screenSize.height(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${timestamp.day}-${timestamp.month}-${timestamp.year}"
                      .replaceAll("", "\u{200B}"),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: screenSize.height(18),
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: screenSize.height(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                "${order['phone']}",
                style: TextStyle(
                  fontSize: screenSize.height(18),
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "Time: ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: screenSize.height(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${timestamp.hour.toString().padLeft(2, "0")}:${timestamp.minute.toString().padLeft(2, "0")}"
                      .replaceAll("", "\u{200B}"),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: screenSize.height(18),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (large) ...[
          Row(
            children: [
              Text(
                "Email: ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: screenSize.height(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${order['email']}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
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
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: screenSize.height(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  "${order['address'].toString().capitalize()}, ${order['pincode']}"
                      .replaceAll("", "\u{200B}"),
                  overflow: shortAddress ? null : TextOverflow.ellipsis,
                  maxLines: shortAddress ? 3 : 1,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: screenSize.height(18),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 15, thickness: 2),
          Row(
            children: [
              Text(
                "Payment Mode: ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: screenSize.height(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${order['payment_mode']}".replaceAll("", "\u{200B}"),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: screenSize.height(18),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
        if (!large) const Divider(height: 15, thickness: 2),
        Row(
          children: [
            Text(
              "Total Price: ",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: screenSize.height(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$CURRENCY ${order['price']}".replaceAll("", "\u{200B}"),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: screenSize.height(18),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Total Items: ",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: screenSize.height(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${order["products"].length} items".replaceAll("", "\u{200B}"),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: screenSize.height(18),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        if (large) const Divider(height: 21, thickness: 2),
      ],
    );
  }
}

class OrderSheet extends StatelessWidget {
  final Map<dynamic, dynamic> order;

  const OrderSheet(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Theme.of(context).colorScheme.background,
        ),
        padding: screenSize.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: screenSize.height(32),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 2, height: 10),
            const SizedBox(height: 10),
            SizedBox(
              height: order["products"].length > 3
                  ? MediaQuery.of(context).size.height * 375 / 816
                  : MediaQuery.of(context).size.height * 275 / 816,
              child: ListView.builder(
                itemCount: order["products"].length,
                itemBuilder: (context, index) {
                  final Product product =
                      Product.fromJson(order["products"][index]["product"]);

                  return Container(
                    margin: screenSize.symmetric(vertical: 8),
                    height: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: screenSize.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            child: Row(
                              children: [
                                if (product.images.isNotEmpty)
                                  SizedBox(
                                    width: screenSize.height(100),
                                    child: CachedNetworkImage(
                                      imageUrl: product.images[0],
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Colors.grey[200]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(color: Colors.grey),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  )
                                else
                                  const Text("No Image Provided"),
                                const SizedBox(width: 24),
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
                                          style: TextStyle(
                                            fontSize: screenSize.height(22),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "sans-serif-condensed",
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "$CURRENCY ${product.price}",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontSize: screenSize.height(20),
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  "sans-serif-condensed",
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            "$CURRENCY ${product.mrp}",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                                  .withOpacity(0.7),
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: screenSize.height(18),
                                              fontWeight: FontWeight.w800,
                                              fontFamily:
                                                  "sans-serif-condensed",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: screenSize.only(
                                    right: 12,
                                    left: 4,
                                    top: 18,
                                    bottom: 18,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                ),
                                              )
                                            : null,
                                      ),
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
                },
              ),
            ),
            const Divider(thickness: 2, height: 10),
            Text(
              "Delivery Information:",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: screenSize.height(26),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            InfoWidget(
              order: order,
              shortAddress: true,
            ),
          ],
        ),
      ),
    );
  }
}
