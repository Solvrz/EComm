import 'dart:convert';

import 'package:flutter/material.dart';

import '../config/constant.dart';

class Variation {
  late String _name;
  late List<Option> _options;

  String get name => _name;

  set name(name) => _name = name;

  List<Option> get options => _options;

  Variation({required String name, required List<Option> options}) {
    _name = name;
    _options = options;
  }

  static Variation fromJson(Map data) {
    return Variation(
      name: data["name"],
      options: data["options"].map<Option>((option) {
        return Option(label: option["label"], color: option["color"]);
      }).toList(),
    );
  }

  Map toJson() {
    return {
      "name": _name,
      "options": _options.map((Option option) {
        return option.toJson();
      }).toList()
    };
  }

  String toString() => jsonEncode(toJson());
}

class Option {
  late String _label;
  late Color _color;

  String get label => _label;

  set label(label) => _label = label;

  Color get color => _color;

  set color(color) => _color = color;

  Option({required String label, Color? color}) {
    _label = label;
    _color = color is String && color != null
        ? Color(
            "0xff$color".toInt(),
          )
        : color!;
  }

  Map toJson() {
    return {
      "label": _label,
      "color": _color.toString().substring(10, 16).toUpperCase(),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Option && label == other.label && color == other.color;
  }
}
