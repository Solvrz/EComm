import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer_admin/components/alert_button.dart';
import 'package:suneel_printer_admin/components/rounded_alert_dialog.dart';
import 'package:suneel_printer_admin/constant.dart';
import 'package:suneel_printer_admin/models/product.dart';
import 'package:suneel_printer_admin/screens/add_product.dart';

class ProductList extends StatefulWidget {
  ProductList({@required this.products, this.args});

  final List<Product> products;
  final AddProductArguments args;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: getAspect(context, 0.75),
      children: List.generate(
        widget.products.length,
            (index) =>
            ProductCard(product: widget.products[index], args: widget.args),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  final AddProductArguments args;

  ProductCard({this.product, this.args});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery
        .of(context)
        .size
        .width / 2;
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
          builder: (_) =>
              RoundedAlertDialog(
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
                              (element) =>
                              storage
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
        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey[400], width: 1),
            left: BorderSide(color: Colors.grey[400], width: 1),
            bottom: BorderSide(color: Colors.grey[400], width: 1),
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 4, 18, 0),
                child: widget.product.images.length > 0
                    ? Container(
                  height: height / 1.675,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400],
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(2, 2),
                    )
                  ]),
                  child: CachedNetworkImage(
                    imageUrl: widget.product.images[0],
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                        CircularProgressIndicator(
                            value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error),
                  ),
                )
                    : Container(
                  height: height / 1.65,
                  child: Center(
                    child: Text("No Image Provided"),
                  ),
                ),
              ),
              SizedBox(height: 22),
              Row(
                children: [
                  Text(
                    "₹ ${widget.product.price}",
                    style: TextStyle(
                        color: kUIDarkText,
                        fontSize: getHeight(context, 22),
                        fontWeight: FontWeight.bold,
                        fontFamily: "sans-serif-condensed"),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "₹ ${widget.product.mrp}",
                    style: TextStyle(
                        color: kUIDarkText.withOpacity(0.7),
                        decoration: TextDecoration.lineThrough,
                        fontSize: getHeight(context, 20),
                        fontWeight: FontWeight.w800,
                        fontFamily: "sans-serif-condensed"),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Text(
                  widget.product.name.replaceAll("", "\u{200B}"),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: kUIDarkText,
                      fontSize: getHeight(context, 24),
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
