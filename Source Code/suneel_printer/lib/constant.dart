import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suneel_printer/models/cart.dart';
import 'package:suneel_printer/models/wishlist.dart';

bool admin = false;

const kUIAccent = Colors.redAccent;
const kUIColor = Colors.white;
const kUILightText = Color(0xffF1F9F8);
const kUIDarkText = Color(0xff031715);

const InputDecoration kInputDialogDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
    borderSide: BorderSide(color: Colors.grey),
  ),
  focusedBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
    borderSide: BorderSide(color: kUIAccent, width: 1.5),
  ),
);

FirebaseFirestore database = FirebaseFirestore.instance;
Cart cart = Cart();
Wishlist wishlist = Wishlist();

SharedPreferences preferences;

const List<Map<String, dynamic>> categories = [
  {"uId": 1, "name": "Office\nBooks", "image": "assets/images/Office.png"},
  {
    "uId": 2,
    "name": "Stationary",
    "image": "assets/images/Stationery.png",
  },
  {
    "uId": 3,
    "name": "Shagun",
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
