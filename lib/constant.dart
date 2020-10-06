import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/components/cart.dart';

const kUIAccent = Colors.redAccent;
const kUIColor = Color(0xffeff5f5);
const kUILightText = Color(0xffF1F9F8);
const kUIDarkText = Color(0xff031715);

FirebaseFirestore database = FirebaseFirestore.instance;
Cart cart = Cart();
Wishlist wishlist = Wishlist();
