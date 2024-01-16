import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '/services/screen_size.dart';

late ScreenSize screenSize;

// TODO: Change These
const String CURRENCY = "₹";
const String CONTACT = "91 99999 99999";

// TODO: Enter Storage Base URL Here (Ex: https://firebasestorage.googleapis.com/v0/b/projectid.appspot.com/o/)
const STORAGE =
    'https://firebasestorage.googleapis.com/v0/b/ecomm-37.appspot.com/o/';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseMessaging messaging = FirebaseMessaging.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

Map<dynamic, dynamic>? selectedInfo;
late List<Map<dynamic, dynamic>> addresses;

// TODO: Change These
const List<Map<String, dynamic>> categories = <Map<String, dynamic>>[
  {
    "uId": 1,
    "name": "Category 1",
    "image": "assets/images/Category1.png",
    "color": Color(0xfff0cbb6),
  },
  {
    "uId": 2,
    "name": "Category 2",
    "image": "assets/images/Category2.png",
    "color": Color(0xffead7b7),
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
