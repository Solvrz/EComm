import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Cart {
  List<Map<String, dynamic>> _products = [];

  List<Map<String, dynamic>> get products => _products;

  void addItem(Map<String, dynamic> itemData) {
    itemData["quantity"] = 1;
    _products.add(itemData);
    _save();
  }

  void removeItem(String uId) {
    _products.removeWhere((element) => element["uId"] == uId);
    _save();
  }

  void clear() {
    _products.clear();
  }

  void increaseQuantity(String uId, {int increase = 1}) {
    _products.forEach((element) {
      if (element["uId"] == uId) element["quantity"]++;
    });
    _save();
  }

  void decreaseQuantity(String uId, {int decrease = 1}) {
    for (var element in _products) {
      if (element["uId"] == uId) {
        element["quantity"]--;
        if (element["quantity"] == 0) {
          removeItem(uId);
          break;
        }
      }
    }
    _save();
  }

  bool containsProduct(String uId) {
    bool contains;
    _products.forEach((element) {
      if (element["uId"] == uId) contains = true;
    });

    return contains ?? false;
  }

  Map<String, dynamic> productInfo(String uId) {
    Map<String, dynamic> info;

    _products.forEach((element) {
      if (element["uId"] == uId) info = element;
    });

    return info;
  }

  void _save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList("cart", _products.map((e) => jsonEncode(e)).toList());
  }

  void load() async {
    final preferences = await SharedPreferences.getInstance();
    final List<String> data = preferences.getStringList("cart");

    if (data != null) _products = data.map<Map<String, dynamic>>((element) => jsonDecode(element)).toList();
  }
}
