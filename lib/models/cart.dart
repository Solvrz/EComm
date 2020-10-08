import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suneel_printer/models/product.dart';

class CartItem {
  Product product;
  int quantity;

  CartItem(this.product, this.quantity);

  String toString() {
    return "${jsonEncode(product.toJson())}\n$quantity";
  }

  static CartItem fromString(String data) {
    return CartItem(Product.fromJson(jsonDecode(data.split("\n")[0])), int.parse(data.split("\n")[1]));
  }
}

class Cart {
  List<CartItem> _products = [];

  List<CartItem> get products => _products;

  bool get isEmpty => !(_products.length > 0);
  bool get isNotEmpty => _products.length > 0;

  void addItem(Product product) {
    _products.add(CartItem(product, 1));
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
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList("cart", _products.map((CartItem cartItem) => cartItem.toString()).toList());
  }

  void load() async {
    final preferences = await SharedPreferences.getInstance();
    final List<String> cartData = preferences.getStringList("cart");

    if (cartData != null) _products = cartData.map<CartItem>((String data) => CartItem.fromString(data)).toList();
  }
}
