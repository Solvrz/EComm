// ignore_for_file: prefer_constructors_over_static_methods

import '../models/variation.dart';

class Product {
  String uId;
  String name;
  List<dynamic> images;
  String price;
  String mrp;
  List<Variation> variations;
  bool featured;
  Map<dynamic, dynamic>? selected;

  Product({
    required this.uId,
    required this.name,
    required this.price,
    required this.mrp,
    required this.variations,
    required this.featured,
    this.images = const [],
    this.selected,
  }) {
    selected = selected ??
        variations.asMap().map(
              (key, value) =>
                  MapEntry(variations[key].name, variations[key].options[0]),
            );
  }

  static Product fromJson(Map<dynamic, dynamic> data) {
    return Product(
      uId: data["uId"],
      name: data["name"],
      images: data["imgs"] ?? [],
      price: data["price"].toString(),
      mrp: data["mrp"].toString(),
      featured: data["featured"],
      variations: (data["variations"] ?? [])
          .map<Variation>(
            (variation) => Variation.fromJson(variation),
          )
          .toList(),
      selected: data["selected"] != null
          ? data["selected"].map(
              (key, value) => MapEntry(
                key,
                Option(
                  label: value["label"],
                  color: value["color"],
                ),
              ),
            )
          : null,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      "uId": uId,
      "name": name,
      "imgs": images,
      "price": price,
      "mrp": mrp,
      "featured": featured,
      "variations": variations
          .map<Map<dynamic, dynamic>>(
            (variation) => variation.toJson(),
          )
          .toList(),
      "selected": selected!.map(
        (key, value) => MapEntry(
          key,
          value.toJson(),
        ),
      ),
    };
  }

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    return other is Product &&
        uId == other.uId &&
        name == other.name &&
        images.toString() == other.images.toString() &&
        price == other.price &&
        selected!
                .map(
                  (key, value) => MapEntry(
                    key,
                    {"label": value.label, "color": value.color},
                  ),
                )
                .toString() ==
            other.selected!
                .map(
                  (key, value) => MapEntry(
                    key,
                    {"label": value.label, "color": value.color},
                  ),
                )
                .toString();
  }

  void select(String name, int option) {
    selected![name] = variations
        .where((variation) => variation.name == name)
        .first
        .options[option];
  }

  List<String> difference(Product other) {
    final List<String> difference = [];

    if (name != other.name) difference.add("name");
    if (images.toString() != other.images.toString()) difference.add("images");
    if (price != other.price) difference.add("price");
    if (mrp != other.mrp) difference.add("mrp");
    if (variations
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
