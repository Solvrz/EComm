import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';

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
      int.parse(data.split("\n")[1]),
    );
  }
}

class Cart {
  List<CartItem> _products = [];

  List<CartItem> get products => _products;

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
        List<String> splits = item.product.uId.split("/");
        QuerySnapshot categories = await database
            .collection("categories")
            .where(
              "uId",
              isEqualTo: int.parse(splits[0]),
            )
            .get();
        QuerySnapshot tabs = await categories.docs.first.reference
            .collection("tabs")
            .where(
              "uId",
              isEqualTo: int.parse(splits[1]),
            )
            .get();
        QuerySnapshot products = await tabs.docs.first.reference
            .collection("products")
            .where(
              "uId",
              isEqualTo: splits.join("/"),
            )
            .get();

        if (products.docs.isEmpty) {
          //Product has been removed from the database
        } else {
          Map cartProduct = item.product.toJson();
          Map product = products.docs.first.data();
          List diff = cartProduct.values
              .toSet()
              .difference(
                product.values.toSet(),
              )
              .toList();

          diff.forEach((element) {
            var changeKey = cartProduct.keys
                .toList()[cartProduct.values.toList().indexOf(element)];
            print(changeKey);
            print("Changed $changeKey from $element to ${product[changeKey]}");
          });
        }
      }
    }
  }
}
