import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '/config/constant.dart';
import '/models/product.dart';
import '/tools/extensions.dart';
import '/ui/pages/add_product/add_product.dart';
import '/ui/widgets/alert_button.dart';
import '/ui/widgets/rounded_alert_dialog.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final AddProductArguments args;

  const ProductCard({
    super.key,
    required this.product,
    required this.args,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 3;
    final double height = width / 0.8;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        widget.args.product = widget.product;
        await Navigator.pushNamed(
          context,
          "/add_product",
          arguments: widget.args,
        );
        if (context.mounted) setState(() {});
      },
      onLongPress: () async {
        await showDialog(
          context: context,
          builder: (context) => RoundedAlertDialog(
            title: "Do you want to delete this Product?",
            buttonsList: [
              AlertButton(
                onPressed: () => Navigator.pop(context),
                title: "No",
              ),
              AlertButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final List<String> uIds = widget.product.uId.split("/");

                  try {
                    widget.product.images.forEach(
                      (element) => STORAGE
                          .ref()
                          .child(
                            element
                                .replaceAll(RegExp(STORAGE_URL), '')
                                .replaceAll(RegExp('%2F'), '/')
                                .replaceAll(RegExp(r'(\?alt).*'), '')
                                .replaceAll(RegExp('%20'), ' ')
                                .replaceAll(RegExp('%3A'), ':'),
                          )
                          .delete(),
                    );

                    final QuerySnapshot category = await FIRESTORE
                        .collection("categories")
                        .where(
                          "uId",
                          isEqualTo: uIds[0].toInt(),
                        )
                        .get();

                    final QuerySnapshot tab = await category
                        .docs.first.reference
                        .collection("tabs")
                        .where("uId", isEqualTo: uIds[1].toInt())
                        .get();

                    final QuerySnapshot product = await tab.docs.first.reference
                        .collection("products")
                        .where("uId", isEqualTo: widget.product.uId)
                        .get();

                    await product.docs.first.reference.delete();

                    final QuerySnapshot query = await FIRESTORE
                        .collection("products")
                        .where("uId", isEqualTo: widget.product.uId)
                        .get();
                    await query.docs.first.reference.delete();
                  } catch (e, s) {
                    log(e.toString());
                    log(s.toString());
                  }
                },
                title: "Yes",
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: screenSize.fromLTRB(12, 16, 12, 0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[400]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: screenSize.fromLTRB(0, 10, 10, 0),
                      child: widget.product.images.isNotEmpty
                          ? SizedBox(
                              height: height / screenSize.aspectRatio(1.1),
                              child: CachedNetworkImage(
                                imageUrl: widget.product.images[0],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[400]!,
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    color: Colors.grey,
                                    height:
                                        height / screenSize.aspectRatio(1.2),
                                    width: width / screenSize.aspectRatio(1.2),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            )
                          : SizedBox(
                              height: height / screenSize.aspectRatio(1.2),
                              child: const Center(
                                child: Text("No Image Provided"),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenSize.height(22),
            ),
            Row(
              children: [
                Text(
                  "$CURRENCY ${widget.product.price}",
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: screenSize.height(20),
                    fontWeight: FontWeight.bold,
                    fontFamily: "sans-serif-condensed",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "$CURRENCY ${widget.product.mrp}"
                        .replaceAll("", "\u{200B}"),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      decoration: TextDecoration.lineThrough,
                      fontSize: screenSize.height(18),
                      fontWeight: FontWeight.w800,
                      fontFamily: "sans-serif-condensed",
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: screenSize.only(right: 12),
              child: Text(
                widget.product.name.replaceAll("", "\u{200B}"),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: screenSize.height(20),
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w800,
                  fontFamily: "sans-serif-condensed",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
