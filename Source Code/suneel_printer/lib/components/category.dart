import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/screens/product.dart';

class ProductList extends StatefulWidget {
  ProductList({@required this.products});

  final List<Product> products;

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
        (index) => ProductCard(product: widget.products[index]),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  ProductCard({this.product});

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
        await Navigator.pushNamed(
          context,
          "/product",
          arguments: ProductArguments(widget.product),
        );
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 24, 12, 0),
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
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 12, 0),
                    child: widget.product.images.length > 0
                        ? Container(
                            height: height / 1.8,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey[600],
                                blurRadius: 12,
                                offset: Offset(2, 2),
                              )
                            ]),
                            child: Image(image: widget.product.images[0]),
                          )
                        : Container(
                            height: height / 1.25,
                            child: Center(
                              child: Text("No Image Provided"),
                            ),
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => setState(
                      () => wishlist.containsProduct(widget.product)
                          ? wishlist.removeProduct(widget.product)
                          : wishlist.addProduct(widget.product),
                    ),
                    child: Icon(
                      wishlist.containsProduct(widget.product)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: wishlist.containsProduct(widget.product)
                          ? kUIAccent
                          : kUIDarkText,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: getHeight(context, 22)),
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
              Text(
                "₹ ${widget.product.mrp}",
                style: TextStyle(
                    color: kUIDarkText.withOpacity(0.7),
                    decoration: TextDecoration.lineThrough,
                    fontSize: getHeight(context, 18),
                    fontWeight: FontWeight.w800,
                    fontFamily: "sans-serif-condensed"),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Text(
              widget.product.name,
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
