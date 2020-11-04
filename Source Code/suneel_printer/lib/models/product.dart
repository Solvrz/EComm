import 'package:flutter/material.dart';
import 'package:suneel_printer/models/variation.dart';

class Product {
  String _uId;
  String _name;
  List<NetworkImage> _images;
  String _price;
  String _mrp;
  List<Variation> _variations;
  Map _selected;

  String get uId => _uId;

  String get name => _name;

  List<NetworkImage> get images => _images;

  String get price => _price;

  String get mrp => _mrp;

  List<Variation> get variations => _variations;

  Map get selected => _selected;

  Product(
      {String uId,
      String name,
      List images = const [],
      String price,
      String mrp,
      List variations,
      Map selected}) {
    _uId = uId;
    _name = name;
    if (images.length > 0)
      _images = images
          .map(
            (e) => NetworkImage(e),
          )
          .toList();
    _price = price;
    _mrp = mrp;
    _variations = variations;
    _selected = selected ??
        variations.asMap().map(
              (key, value) =>
                  MapEntry(variations[key].name, variations[key].options[0]),
            );
  }

  static Product fromJson(Map data) {
    return Product(
        uId: data["uId"],
        name: data["name"],
        images: data["imgs"],
        price: data["price"].toString(),
        mrp: data["mrp"].toString(),
        variations: (data["variations"] ?? [])
            .map<Variation>(
              (variation) => Variation.fromJson(variation),
            )
            .toList(),
        selected: data["selected"] != null
            ? data["selected"].map(
                (key, value) => MapEntry(
                  key,
                  Option(label: value["label"], color: value["color"]),
                ),
              )
            : null);
  }

  Map toJson() {
    return {
      "uId": _uId,
      "name": _name,
      "imgs": _images.map((e) => e.url).toList(),
      "price": _price,
      "mrp": _mrp,
      "variations": _variations
          .map<Map>(
            (Variation variation) => variation.toJson(),
          )
          .toList(),
      "selected": _selected.map(
        (key, value) => MapEntry(
          key,
          value.toJson(),
        ),
      )
    };
  }

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return other is Product &&
        _uId == other.uId &&
        _name == other.name &&
        _images.toString() == other.images.toString() &&
        _price == other.price &&
        _selected
                .map(
                  (key, value) => MapEntry(
                      key, {"label": value.label, "color": value.color}),
                )
                .toString() ==
            other.selected
                .map(
                  (key, value) => MapEntry(
                      key, {"label": value.label, "color": value.color}),
                )
                .toString();
  }

  void select(String name, int option) {
    _selected[name] = _variations
        .where((Variation variation) => variation.name == name)
        .first
        .options[option];
  }

  List<String> difference(Product other) {
    List<String> difference = [];
    if (_name != other.name) difference.add("name");
    if (_images.toString() != other.images.toString()) difference.add("images");
    if (_price != other.price) difference.add("price");
    if (_mrp != other.mrp) difference.add("mrp");
    if (_variations
            .map(
              (e) => e.toString(),
            )
            .toList()
            .toString() !=
        other.variations
            .map(
              (e) => e.toString(),
            )
            .toList()
            .toString()) difference.add("variations");

    return difference;
  }
}
