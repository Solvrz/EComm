import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '/config/constant.dart';
import '/models/product.dart';
import '/ui/pages/product/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final State? parent;

  const ProductCard({
    super.key,
    required this.product,
    this.parent,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 3;
    final double height = width / 1;

    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          "/product",
          arguments: ProductArguments(widget.product),
        );
        if (widget.parent != null) widget.parent!.setState(() {});
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
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        if (context.mounted) {
                          setState(
                            () => WISHLIST.containsProduct(widget.product)
                                ? WISHLIST.removeProduct(widget.product)
                                : WISHLIST.addProduct(widget.product),
                          );
                        }
                      },
                      child: Icon(
                        WISHLIST.containsProduct(widget.product)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: WISHLIST.containsProduct(widget.product)
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: screenSize.fromLTRB(0, 22, 12, 0),
                      child: widget.product.images.isNotEmpty
                          ? SizedBox(
                              height: height / screenSize.aspectRatio(1.2),
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
                                  baseColor: Theme.of(context).highlightColor,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(color: Colors.grey),
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
                    color: Theme.of(context).colorScheme.onPrimary,
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
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.7),
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
                  color: Theme.of(context).colorScheme.onPrimary,
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
