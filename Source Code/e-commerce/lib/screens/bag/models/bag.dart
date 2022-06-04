import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../config/constant.dart';
import '../../../models/product.dart';
import '../../../models/variation.dart';

class BagItem {
  Product product;
  int quantity;

  BagItem(this.product, this.quantity);

  @override
  String toString() => "${jsonEncode(
        product.toJson(),
      )}\n$quantity";

  static BagItem fromString(String data) {
    return BagItem(
      Product.fromJson(
        jsonDecode(data.split("\n")[0]),
      ),
      data.split("\n")[1].toInt(),
    );
  }
}

class Bag {
  List<BagItem> _products = [];
  final List<String> _changeLog = [];

  List<BagItem> get products => _products;

  List<String> get changeLog => _changeLog;

  bool get hasNoProducts => !(_products.isNotEmpty);

  bool get hasProducts => _products.isNotEmpty;

  void addProduct(Product product) {
    _products.add(
      BagItem(
          Product.fromJson(
            product.toJson(),
          ),
          1),
    );
    _save();
  }

  void removeProduct(Product product) {
    _products.removeWhere((bagItem) {
      return bagItem.product == product;
    });
    _save();
  }

  void clear() {
    _products.clear();
    preferences.setStringList("bag", []);
  }

  void increaseQuantity(Product product, {int increase = 1}) {
    for (var bagItem in _products) {
      if (bagItem.product == product) bagItem.quantity += increase;
    }
    _save();
  }

  void decreaseQuantity(Product product, {int decrease = 1}) {
    for (var bagItem in _products) {
      if (bagItem.product == product) {
        bagItem.quantity -= decrease;
        if (bagItem.quantity == 0) {
          removeProduct(product);
          break;
        }
      }
    }
    _save();
  }

  bool containsProduct(Product product) {
    bool? contains;
    for (BagItem bagItem in _products) {
      if (bagItem.product == product) {
        contains = true;
        break;
      }
    }

    return contains ?? false;
  }

  int getQuantity(Product product) {
    int quantity = 0;

    for (var bagItem in _products) {
      if (bagItem.product == product) quantity = bagItem.quantity;
    }

    return quantity;
  }

  Future<void> _save() async {
    await preferences.setStringList(
      "bag",
      _products
          .map<String>(
            (bagItem) => bagItem.toString(),
          )
          .toList(),
    );
  }

  Future<void> load() async {
    final List<String>? bagData = preferences.getStringList("bag");

    if (bagData != null) {
      List<BagItem?> items = bagData
          .map<BagItem>(
            (data) => BagItem.fromString(data),
          )
          .toList();

      for (BagItem? item in items) {
        if (item != null) {
          QuerySnapshot products = await database
              .collection("products")
              .where("uId", isEqualTo: item.product.uId)
              .get();

          if (products.docs.isEmpty) {
            _changeLog.add(
                "The product '${item.product.name}' has been removed from the store");
            wishlist.removeProduct(item.product);
            items.removeAt(
              items.indexOf(item),
            );
          } else {
            Map productData = products.docs.first.data() as Map;
            List<String> diff = item.product.difference(
              Product.fromJson(productData),
            );

            Map updatedData = item.product.toJson();

            for (var changeKey in diff) {
              if (changeKey == "variations") {
                _changeLog.add(
                    "The variations for product '${productData["name"]}' have been updated.");

                updatedData["selected"] =
                    productData["variations"].asMap().map((_, element) {
                  Variation variation = Variation.fromJson(element);
                  return MapEntry(
                    variation.name,
                    variation.options.first.toJson(),
                  );
                });
              } else if (changeKey == "name") {
                _changeLog.add(
                    "The name of the product '${item.product.name}' has been changed to ${productData["name"]}.");
              } else {
                _changeLog.add(
                    "The ${changeKey.capitalize()} for product '${productData["name"]}' has been changed from ${item.product.toJson()[changeKey]} to ${productData[changeKey]}.");
              }

              updatedData[changeKey] = productData[changeKey];
            }

            item.product = Product.fromJson(updatedData);
          }
        }
        _products = items as List<BagItem>;
      }

      items.removeWhere((element) => element == null);

      await _save();
    }
  }
}
