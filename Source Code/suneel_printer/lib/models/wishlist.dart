import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:suneel_printer/models/product.dart';

class Wishlist {
  List<Product> _products = [];

  List<Product> get products => _products;

  bool get hasProducts => _products.length > 0;
  bool get hasNoProducts => !(_products.length > 0);

  void addItem(Product product) {
    _products.add(product);
    _save();
  }

  void removeItem(Product product) {
    _products.removeWhere((Product element) => element == product);
    _save();
  }

  void clear() {
    _products.clear();
  }

  bool containsProduct(Product product) {
    bool contains;
    for (Product element in _products) {
      if (element == product) {
        contains = true;
        break;
      }
    }

    return contains ?? false;
  }

  void _save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      "wishlist",
      _products
          .map<String>(
            (Product e) => jsonEncode(
              e.toJson(),
            ),
          )
          .toList(),
    );
  }

  void load() async {
    final preferences = await SharedPreferences.getInstance();
    final List<String> wishlistData = preferences.getStringList("wishlist");

    if (wishlistData != null)
      _products = wishlistData
          .map<Product>(
            (element) => Product.fromJson(
              jsonDecode(element),
            ),
          )
          .toList();
  }
}
