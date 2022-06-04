import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/product.dart';

class Wishlist {
  List<Product> _products = [];

  List<Product> get products => _products;

  bool get hasProducts => _products.isNotEmpty;

  bool get hasNoProducts => !(_products.isNotEmpty);

  void addProduct(Product product) {
    _products.add(product);
    _save();
  }

  void removeProduct(Product product) {
    _products.removeWhere((element) => element == product);
    _save();
  }

  void clear() {
    _products.clear();
  }

  bool containsProduct(Product product) {
    bool? contains;

    for (Product element in _products) {
      if (element == product) {
        contains = true;
        break;
      }
    }

    return contains ?? false;
  }

  Future<void> _save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      "wishlist",
      _products
          .map<String>(
            (e) => jsonEncode(
              e.toJson(),
            ),
          )
          .toList(),
    );
  }

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final List<String>? wishlistData = preferences.getStringList("wishlist");

    if (wishlistData != null) {
      _products = wishlistData
          .map<Product>(
            (element) => Product.fromJson(
              jsonDecode(element),
            ),
          )
          .toList();
    }
  }
}
