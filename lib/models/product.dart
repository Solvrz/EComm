import 'package:flutter/material.dart';

class Product {
  String _uId;
  String _name;
  NetworkImage _img;
  String _price;
  Color _bgColor;

  String get uId => _uId;

  String get name => _name;

  NetworkImage get img => _img;

  String get price => _price;

  Color get bgColor => _bgColor;

  Product(
      {String uId,
      String name,
      String img = "",
      String price,
      String bgColor}) {
    _uId = uId;
    _name = name;
    if (img != "") _img = NetworkImage(img);
    _price = price;
    _bgColor = Color(int.parse("0xff$bgColor"));
  }

  static Product fromJson(Map data) {
    return Product(
      uId: data["uId"],
      name: data["name"],
      img: data["img"],
      price: data["price"],
      bgColor: data["bgColor"],
    );
  }

  Map toJson() {
    return {
      "uId": _uId,
      "name": _name,
      "img": _img.url,
      "price": _price,
      "bgColor": _bgColor.toString().substring(10, 16).toUpperCase()
    };
  }

  @override
  bool operator==(other) {
    return uId == other.uId && name == other.name && img == other.img && price == other.price && bgColor == other.bgColor;
  }
}
