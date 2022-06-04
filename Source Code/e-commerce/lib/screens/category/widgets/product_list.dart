import 'package:flutter/material.dart';

import './product_card.dart';
import '../../../config/constant.dart';
import '../../../models/product.dart';

class ProductList extends StatefulWidget {
  final State? parent;
  final List<Product> products;

  const ProductList({
    Key? key,
    this.parent,
    required this.products,
  }) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: screenSize.aspectRatio(0.74),
      children: List.generate(
        widget.products.length,
        (index) => ProductCard(
          product: widget.products[index],
          parent: widget.parent,
        ),
      ),
    );
  }
}
