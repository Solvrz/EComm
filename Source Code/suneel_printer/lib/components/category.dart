import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/screens/product.dart';

class ProductList extends StatefulWidget {
  final State parent;
  final List<Product> products;

  ProductList({this.parent, @required this.products});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: getAspect(context, 0.74),
        children: List.generate(
          widget.products.length,
              (index) =>
              ProductCard(
                product: widget.products[index],
                parent: widget.parent,
              ),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  final State parent;

  ProductCard({this.product, this.parent});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery
        .of(context)
        .size
        .width / 3;
    final double height = width / 0.8;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        await Navigator.pushNamed(
          context,
          "/product",
          arguments: ProductArguments(widget.product),
        );
        widget.parent.setState(() {});
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey[400], width: 1),
            right: BorderSide(color: Colors.grey[400], width: 1),
            left: BorderSide(color: Colors.grey[400], width: 1),
            bottom: BorderSide(color: Colors.grey[400], width: 1),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (mounted)
                        setState(
                              () =>
                          wishlist.containsProduct(widget.product)
                              ? wishlist.removeProduct(widget.product)
                              : wishlist.addProduct(widget.product),
                        );
                    },
                    child: Container(
                      child: Icon(
                        wishlist.containsProduct(widget.product)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: wishlist.containsProduct(widget.product)
                            ? kUIAccent
                            : kUIDarkText,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 4, 12, 0),
                    child: widget.product.images.length > 0
                        ? Container(
                      height: height / getAspect(context, 1.2),
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
                      height: height / getAspect(context, 1.2),
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
            height: getHeight(context, 22),
          ),
          Row(
            children: [
              Text(
                "₹ ${widget.product.price}",
                style: TextStyle(
                    color: kUIDarkText,
                    fontSize: getHeight(context, 20),
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
                      fontSize: getHeight(context, 18),
                      fontWeight: FontWeight.w800,
                      fontFamily: "sans-serif-condensed"),
                ),
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
                  fontSize: getHeight(context, 20),
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
