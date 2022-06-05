import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/bag/models/bag.dart';
import '../screens/wishlist/models/wishlist.dart';
import '../services/screen_size.dart';

late ScreenSize screenSize;

bool testing = true;
String contact = "1234567890"; // TODO: Change this Mobile No.

String keyTesting = "";
String keyProduction = "";

FirebaseFirestore database = FirebaseFirestore.instance;
FlutterSecureStorage secureStorage = const FlutterSecureStorage();

Bag bag = Bag();
Wishlist wishlist = Wishlist();

late SharedPreferences preferences;

Map? selectedInfo;
late List<Map> addresses;

const kUILightText = Colors.white;
const kUIDarkText = Color(0xff031715);

InputDecoration kInputDialogDecoration = const InputDecoration(
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
    borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
  ),
);

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
    return length > 0 ? this[0].toUpperCase() + substring(1) : "";
  }

  int toInt() {
    return int.parse(this);
  }

  double toDouble() {
    return double.parse(this);
  }

  DateTime toDate() {
    return DateTime.fromMicrosecondsSinceEpoch(toString()
                .split("(")[1]
                .split("=")[1]
                .split(",")[0]
                .toString()
                .toInt() *
            1000000 +
        toString()
                .split("(")[1]
                .split("=")[2]
                .split(")")[0]
                .toString()
                .toInt() ~/
            1000);
  }
}
