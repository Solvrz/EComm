import 'package:flutter/material.dart';
import 'package:suneel_printer/models/variation.dart';

class Product {
  String _uId;
  String _name;
  NetworkImage _img;
  String _price;
  Color _bgColor;
  List<Variation> _variations;
  Map _selected;

  String get uId => _uId;

  String get name => _name;

  NetworkImage get img => _img;

  String get price => _price;

  Color get bgColor => _bgColor;

  List<Variation> get variations => _variations;

  Map get selected => _selected;

  Product(
      {String uId,
      String name,
      String img = "",
      String price,
      String bgColor,
      List variations,
      Map selected}) {
    _uId = uId;
    _name = name;
    if (img != "") _img = NetworkImage(img);
    _price = price;
    _bgColor = Color(int.parse("0xff$bgColor"));
    _variations = variations;
    _selected = selected ??
        variations.asMap().map((key, value) =>
            MapEntry(variations[key].name, variations[key].options[0]));
  }

  static Product fromJson(Map data) {
    return Product(
        uId: data["uId"],
        name: data["name"],
        img: data["img"],
        price: data["price"].toString(),
        bgColor: data["bgColor"],
        variations: (data["variations"] ?? [])
            .map<Variation>((variation) => Variation.fromJson(variation))
            .toList(),
        selected: data["selected"] != null
            ? data["selected"].map((key, value) => MapEntry(
                key, Option(label: value["label"], color: value["color"])))
            : null);
  }

  Map toJson() {
    return {
      "uId": _uId,
      "name": _name,
      "img": _img.url,
      "price": _price,
      "bgColor": _bgColor.toString().substring(10, 16).toUpperCase(),
      "variations": _variations
          .map<Map>((Variation variation) => variation.toJson())
          .toList(),
      "selected": _selected.map((key, value) => MapEntry(key, value.toJson()))
    };
  }

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return other is Product &&
        uId == other.uId &&
        name == other.name &&
        img == other.img &&
        price == other.price &&
        bgColor == other.bgColor &&
        selected
                .map((key, value) =>
                    MapEntry(key, {"label": value.label, "color": value.color}))
                .toString() ==
            other.selected
                .map((key, value) =>
                    MapEntry(key, {"label": value.label, "color": value.color}))
                .toString();
  }

  void select(String name, int option) {
    _selected[name] = _variations
        .where((Variation variation) => variation.name == name)
        .first
        .options[option];
  }
}
