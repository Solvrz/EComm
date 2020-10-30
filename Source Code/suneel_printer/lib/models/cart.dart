import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/models/variation.dart';

class CartItem {
  Product product;
  int quantity;

  CartItem(this.product, this.quantity);

  String toString() {
    return "${jsonEncode(
      product.toJson(),
    )}\n$quantity";
  }

  static CartItem fromString(String data) {
    return CartItem(
      Product.fromJson(
        jsonDecode(data.split("\n")[0]),
      ),
      data.split("\n")[1].toInt(),
    );
  }
}

class Cart {
  List<CartItem> _products = [];
  List<String> _changeLog = [];

  List<CartItem> get products => _products;
  List<String> get changeLog => _changeLog;

  bool get hasNoProducts => !(_products.length > 0);

  bool get hasProducts => _products.length > 0;

  void addItem(Product product) {
    _products.add(
      CartItem(
          Product.fromJson(
            product.toJson(),
          ),
          1),
    );
    _save();
  }

  void removeItem(Product product) {
    _products.removeWhere((CartItem cartItem) => cartItem.product == product);
    _save();
  }

  void clear() {
    _products.clear();
  }

  void increaseQuantity(Product product, {int increase = 1}) {
    _products.forEach((CartItem cartItem) {
      if (cartItem.product == product) {
        cartItem.quantity += increase;

        if (cartItem.quantity > 15) cartItem.quantity = 15;
      }
    });
    _save();
  }

  void decreaseQuantity(Product product, {int decrease = 1}) {
    for (var cartItem in _products) {
      if (cartItem.product == product) {
        cartItem.quantity -= decrease;
        if (cartItem.quantity == 0) {
          removeItem(product);
          break;
        }
      }
    }
    _save();
  }

  bool containsProduct(Product product) {
    bool contains;
    for (CartItem cartItem in _products) {
      if (cartItem.product == product) {
        contains = true;
        break;
      }
    }

    return contains ?? false;
  }

  int getQuantity(Product product) {
    int quantity = 0;

    _products.forEach((cartItem) {
      if (cartItem.product == product) quantity = cartItem.quantity;
    });

    return quantity;
  }

  void _save() async {
    await preferences.setStringList(
      "cart",
      _products
          .map<String>(
            (CartItem cartItem) => cartItem.toString(),
          )
          .toList(),
    );
  }

  void load() async {
    final List<String> cartData = preferences.getStringList("cart");

    if (cartData != null) {
      List<CartItem> items = cartData
          .map<CartItem>(
            (String data) => CartItem.fromString(data),
          )
          .toList();

      for (CartItem item in items) {
        QuerySnapshot products = await database
            .collection("products")
            .where("uId", isEqualTo: item.product.uId)
            .get();

        if (products.docs.isEmpty) {
          _changeLog.add(
              "The product '${item.product.name}' has been removed from the store");
          cart.removeItem(item.product);
        } else {
          Map productData = products.docs.first.data();
          List<String> diff =
              item.product.difference(Product.fromJson(productData));

          Map updatedData = item.product.toJson();

          diff.forEach((changeKey) {
            if (changeKey == "variations") {
              _changeLog.add(
                  "The variations for product '${productData["name"]}' have been updated.");

              updatedData["selected"] =
                  productData["variations"].asMap().map((_, element) {
                Variation variation = Variation.fromJson(element);
                return MapEntry(
                    variation.name, variation.options.first.toJson());
              });
            } else if (changeKey == "name") {
              _changeLog.add(
                  "The name of the product '${item.product.name}' has been changed to ${productData["name"]}.");
            } else {
              _changeLog.add(
                  "The ${changeKey.capitalize()} for product '${productData["name"]}' has been changed from ${item.product.toJson()[changeKey]} to ${productData[changeKey]}.");
            }

            updatedData[changeKey] = productData[changeKey];
          });

          item.product = Product.fromJson(updatedData);
        }
      }

      _products = items;

      _save();
    }
  }
}
