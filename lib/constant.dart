import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/models/cart.dart';
import 'package:suneel_printer/models/wishlist.dart';

bool admin = false;

const kUIAccent = Colors.redAccent;
const kUIColor = Color(0xffeff5f5);
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
