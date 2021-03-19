import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suneel_printer_admin/config/constant.dart';
import 'package:suneel_printer_admin/models/product.dart';
import 'package:suneel_printer_admin/widgets/alert_button.dart';
import 'package:suneel_printer_admin/widgets/rounded_alert_dialog.dart';

import '../../add_product/add_product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final AddProductArguments args;

  ProductCard({@required this.product, @required this.args});

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
        await Navigator.pushNamed(context, "/add_product",
            arguments: widget.args);
        if (mounted) setState(() {});
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (_) => RoundedAlertDialog(
            title: "Do you want to delete this Product?",
            buttonsList: [
              AlertButton(
                onPressed: () => Navigator.pop(context),
                title: "No",
              ),
              AlertButton(
                onPressed: () async {
                  Navigator.pop(context);
                  List<String> uIds = widget.product.uId.split("/");

                  if (widget.product.images != null)
                    widget.product.images.forEach(
                      (element) => storage
                          .ref()
                          .child(
                            element
                                .replaceAll(
                                    RegExp(
                                        r'https://firebasestorage.googleapis.com/v0/b/suneelprinters37.appspot.com/o/'),
                                    '')
                                .replaceAll(RegExp(r'%2F'), '/')
                                .replaceAll(RegExp(r'(\?alt).*'), '')
                                .replaceAll(RegExp(r'%20'), ' ')
                                .replaceAll(RegExp(r'%3A'), ':'),
                          )
                          .delete(),
                    );

                  QuerySnapshot category = await database
                      .collection("categories")
                      .where(
                        "uId",
                        isEqualTo: int.parse(uIds[0]),
                      )
                      .get();

                  QuerySnapshot tab = await category.docs.first.reference
                      .collection("tabs")
                      .where(
                        "uId",
                        isEqualTo: int.parse(uIds[1]),
                      )
                      .get();

                  QuerySnapshot product = await tab.docs.first.reference
                      .collection("products")
                      .where("uId", isEqualTo: widget.product.uId)
                      .get();

                  product.docs.first.reference.delete();

                  QuerySnapshot query = await database
                      .collection("products")
                      .where("uId", isEqualTo: widget.product.uId)
                      .get();
                  query.docs.first.reference.delete();
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
            color: Colors.grey[400],
            width: 1,
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: screenSize.fromLTRB(0, 32, 12, 0),
                    child: widget.product.images.length > 0
                        ? Container(
                            height: height / screenSize.aspectRatio(1.2),
                            child: CachedNetworkImage(
                              imageUrl: widget.product.images[0],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.fill),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[400],
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                        offset: Offset(2, 2),
                                      )
                                    ]),
                              ),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[200],
                                highlightColor: Colors.grey[100],
                                child: Container(
                                  color: Colors.grey,
                                  height: height / screenSize.aspectRatio(1.2),
                                  width: width / screenSize.aspectRatio(1.2),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          )
                        : Container(
                            height: height / screenSize.aspectRatio(1.2),
                            child: Center(
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
                "₹ ${widget.product.price}",
                style: TextStyle(
                    color: kUIDarkText,
                    fontSize: screenSize.height(20),
                    fontWeight: FontWeight.bold,
                    fontFamily: "sans-serif-condensed"),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "₹ ${widget.product.mrp}".replaceAll("", "\u{200B}"),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: kUIDarkText.withOpacity(0.7),
                      decoration: TextDecoration.lineThrough,
                      fontSize: screenSize.height(18),
                      fontWeight: FontWeight.w800,
                      fontFamily: "sans-serif-condensed"),
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
                  color: kUIDarkText,
                  fontSize: screenSize.height(20),
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w800,
                  fontFamily: "sans-serif-condensed"),
            ),
          ),
        ]),
      ),
    );
  }
}
