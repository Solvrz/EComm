import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/services/screen_size.dart';
import '/ui/pages/bag/models/bag.dart';
import '/ui/pages/wishlist/models/wishlist.dart';

late ScreenSize screenSize;
late SharedPreferences preferences;

// TODO: Change These
const String CURRENCY = "₹";
const String CONTACT = "91 99999 99999";

// TODO: Change This
const String SERVER = "ecomm-qle6y82s.b4a.run";

// TODO: Add Razopay Keys
const String KEY_TESTING = "";
const String KEY_PRODUCTION = "";

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Bag bag = Bag();
Wishlist wishlist = Wishlist();

Map<dynamic, dynamic>? selectedInfo;
late List<Map<dynamic, dynamic>> addresses;

// TODO: Change These
const List<Map<String, dynamic>> categories = <Map<String, dynamic>>[
  {
    "uId": 1,
    "type": "product",
    "name": "Category 1",
    "image": "assets/images/Category1.png",
    "color": Color(0xfff0cbb6),
  },
  {
    "uId": 2,
    "type": "product",
    "name": "Catergory 2",
    "image": "assets/images/Category2.png",
    "color": Color(0xffead7b7),
  },
  {
    "uId": 3,
    "type": "service",
    "name": "Service 1",
    "image": "assets/images/Service1.png",
    "color": Color(0xFFD0B485),
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
    return DateTime.fromMicrosecondsSinceEpoch(
      toString().split("(")[1].split("=")[1].split(",")[0].toInt() * 1000000 +
          toString().split("(")[1].split("=")[2].split(")")[0].toInt() ~/ 1000,
    );
  }
}
