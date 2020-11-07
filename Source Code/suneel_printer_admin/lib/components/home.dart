import 'package:flutter/material.dart';
import 'package:suneel_printer_admin/constant.dart';
import 'package:suneel_printer_admin/models/product.dart';
import 'package:suneel_printer_admin/screens/product.dart';

class SearchCard extends StatefulWidget {
  final Product product;

  SearchCard({this.product});

  @override
  _SearchCardState createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 2;
    final double height = width / 0.8;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(
          FocusNode(),
        );

        Navigator.pushNamed(
          context,
          "/product",
          arguments: ProductArguments(widget.product),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400], width: 0.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Align(
            alignment: Alignment.center,
            child: Stack(children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 12, 0),
                  child: widget.product.images.length > 0
                      ? Container(
                          height: height / 1.7,
                          constraints: BoxConstraints(maxWidth: width - 64),
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
                          height: height / 1.7,
                          child: Center(
                            child: Text("No Image Provided"),
                          ),
                        ),
                ),
              ),
            ]),
          ),
          SizedBox(height: 18),
          Row(
            children: [
              Text(
                "₹ ${widget.product.price}",
                style: TextStyle(
                    color: kUIDarkText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "sans-serif-condensed"),
              ),
              SizedBox(width: 12),
              Text(
                "₹ ${widget.product.mrp}",
                style: TextStyle(
                    color: kUIDarkText.withOpacity(0.7),
                    decoration: TextDecoration.lineThrough,
                    fontSize: 18,
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
                  fontSize: 20,
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
