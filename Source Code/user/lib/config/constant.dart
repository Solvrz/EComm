// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/services/screen_size.dart';
import '/ui/pages/bag/models/bag.dart';
import '/ui/pages/wishlist/models/wishlist.dart';

late ScreenSize screenSize;
late SharedPreferences preferences;
late ThemeData theme;

late List<Map<dynamic, dynamic>> addresses;
Map<dynamic, dynamic>? selectedInfo;

// TODO: Change These
const String CURRENCY = "₹";
const String CONTACT = "91 99999 99999";

// TODO: Change This
const String SERVER = "ecomm-qle6y82s.b4a.run";

// TODO: Add Razopay Keys
const String KEY_TESTING = "";
const String KEY_PRODUCTION = "";

final FirebaseFirestore FIRESTORE = FirebaseFirestore.instance;

final Bag BAG = Bag();
final Wishlist WISHLIST = Wishlist();
