import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../services/screen_size.dart';

late ScreenSize screenSize;

FirebaseFirestore database = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

const kUILightText = Color(0xffF1F9F8);
const kUIDarkText = Color(0xff031715);

InputDecoration kInputDialogDecoration = const InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Colors.grey),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
  ),
);

List<Map<String, dynamic>> categories = [
  {
    "uId": 1,
    "name": "Office\nBooks",
    "image": "assets/images/Office.png",
    "color": const Color(0xfff0cbb6)
  },
  {
    "uId": 2,
    "name": "Stationary",
    "image": "assets/images/Stationery.png",
    "color": const Color(0xffead7b7)
  },
  {
    "uId": 3,
    "name": "Shagun & Envelopes",
    "image": "assets/images/Shagun.png",
    "color": const Color(0xfff5e5e3)
  },
  {
    "uId": 4,
    "name": "Computer \nAccessories",
    "image": "assets/images/Computer.png",
    "color": const Color(0xffa5c4f2)
  }
];

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : "";
  }
}
