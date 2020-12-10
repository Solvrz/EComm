import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suneel_printer/models/bag.dart';
import 'package:suneel_printer/models/wishlist.dart';

bool testing = true;
String contact = "1234567890";

FirebaseFirestore database = FirebaseFirestore.instance;

Bag bag = Bag();
Wishlist wishlist = Wishlist();
SharedPreferences preferences;

Map selectedInfo;
List<Map> addresses;

const kUIAccent = Colors.redAccent;
const kUISecondaryAccent = Color(0xffa5c4f2);
const kUIColor = Colors.white;
const kUILightText = Colors.white;
const kUIDarkText = Color(0xff031715);

double getHeight(BuildContext context, double desiredHeight) =>
    MediaQuery.of(context).size.height * desiredHeight / 816;

double getAspect(BuildContext context, double aspect) =>
    aspect * 816 / MediaQuery.of(context).size.height;

InputDecoration kInputDialogDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
    borderSide: BorderSide(color: Colors.grey),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
    borderSide: BorderSide(color: kUIAccent, width: 1.5),
  ),
);

CircularProgressIndicator indicator = CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[700]),
);

const List<String> onOrder = <String>["Printing", "Binding"];

const List<Map<String, dynamic>> categories = <Map<String, dynamic>>[
  {
    "uId": 1,
    "name": "Office\nBooks",
    "image": "assets/images/Office.png",
    "color": Color(0xfff0cbb6)
  },
  {
    "uId": 2,
    "name": "Stationary",
    "image": "assets/images/Stationery.png",
    "color": Color(0xffead7b7)
  },
  {
    "uId": 3,
    "name": "Shagun & Envelopes",
    "image": "assets/images/Shagun.png",
    "color": Color(0xfff5e5e3)
  },
  {
    "uId": 4,
    "name": "Computer \nAccessories",
    "image": "assets/images/Computer.png",
    "color": Color(0xffa5c4f2)
  },
  {
    "uId": 5,
    "name": "Printing",
    "image": "assets/images/Printing.png",
    "color": Color(0xffc3cde2)
  },
  {
    "uId": 6,
    "name": "Binding",
    "image": "assets/images/Binding.png",
    "color": Color(0xffebcfa0)
  },
];

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : "";
  }

  int toInt() {
    return int.parse(this);
  }
}
