import 'package:flutter/material.dart';

class Variation {
  String _name;
  List<Option> _options;

  String get name => _name;
  List<Option> get options => _options;

  Variation({String name, List<Option> options}) {
    _name = name;
    _options = options;
  }

  static Variation fromJson(Map data) {
    return Variation(
        name: data["name"],
        options: data["options"].map<Option>((option) {
          return Option(label: option["label"], color: option["color"]);
        }).toList());
  }

  Map toJson() {
    return {
      "name": _name,
      "options": _options.map((Option option) {
        return option.toJson();
      }).toList()
    };
  }
}

class Option {
  String _label;
  Color _color;

  String get label => _label;

  Color get color => _color;

  Option({String label, dynamic color}) {
    _label = label;
    _color = color is String ? Color(int.parse("0xff$color")) : color;
  }

  Map toJson() {
    return {
      "label": _label,
      "color": _color != null ? _color.toString().substring(10, 16).toUpperCase() : null,
    };
  }

  @override
  //ignore: hash_and_equals
  bool operator ==(Object other) {
    return other is Option && label == other.label && color == other.color;
  }
}
