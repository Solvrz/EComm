import 'package:flutter/material.dart';

import './product_card.dart';
import '../../../config/constant.dart';
import '../../../models/product.dart';

class ProductList extends StatefulWidget {
  final State? parent;
  final List<Product> products;

  ProductList({this.parent, required this.products});

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
        childAspectRatio: screenSize.aspectRatio(0.74),
        children: List.generate(
          widget.products.length,
          (index) => ProductCard(
            product: widget.products[index],
            parent: widget.parent,
          ),
        ),
      ),
    );
  }
}
