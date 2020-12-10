import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suneel_printer/models/bag.dart';
import 'package:suneel_printer/models/wishlist.dart';

bool testing = true;
String contact = "1234567890";

String keyTesting = "";
String keyProduction = "";

FirebaseFirestore database = FirebaseFirestore.instance;
FlutterSecureStorage secureStorage = FlutterSecureStorage();

Bag bag = Bag();
Wishlist wishlist = Wishlist();
SharedPreferences preferences;

Map selectedInfo;
List<Map> addresses;

const kUIAccent = Colors.redAccent;
const kUIColor = Colors.white;
const kUILightText = Color(0xffF1F9F8);
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

List onOrder = ["Printing", "Binding"];

List<Map<String, dynamic>> categories = [
  {
    "uId": 1,
    "name": "Office\nBooks",
    "image": "assets/images/Office.png",
  },
  {
    "uId": 2,
    "name": "Stationary",
    "image": "assets/images/Stationery.png",
  },
  {
    "uId": 3,
    "name": "Shagun & Envelopes",
    "image": "assets/images/Shagun.png",
  },
  {
    "uId": 4,
    "name": "Computer \nAccessories",
    "image": "assets/images/Computer.png",
  },
  {
    "uId": 5,
    "name": "Printing",
    "image": "assets/images/Printing.png",
  },
  {
    "uId": 6,
    "name": "Binding",
    "image": "assets/images/Binding.png",
  },
];

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : "";
  }
}
