import 'package:flutter/material.dart';
import 'package:suneel_printer_admin/config/constant.dart';
import 'package:suneel_printer_admin/models/product.dart';

import './product_card.dart';
import '../../add_product/add_product.dart';

class ProductList extends StatefulWidget {
  final List<Product> products;
  final AddProductArguments args;

  ProductList({this.products, @required this.args});

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
            args: widget.args,
          ),
        ),
      ),
    );
  }
}
