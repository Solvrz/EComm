import 'package:flutter/material.dart';

import '../../add_product/add_product.dart';
import '/config/constant.dart';
import '/models/product.dart';
import 'product_card.dart';

class ProductList extends StatefulWidget {
  final List<Product> products;
  final AddProductArguments args;

  const ProductList({super.key, required this.products, required this.args});

  @override
  _ProductListState createState() => _ProductListState();
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
          args: widget.args,
        ),
      ),
    );
  }
}
