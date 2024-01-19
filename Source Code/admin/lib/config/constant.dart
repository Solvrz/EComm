// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '/services/screen_size.dart';

late ScreenSize screenSize;
late ThemeData theme;

// TODO: Change These
const String CURRENCY = "₹";

// TODO: Enter Storage Base URL Here (Ex: https://firebasestorage.googleapis.com/v0/b/projectid.appspot.com/o/)
const STORAGE_URL =
    'https://firebasestorage.googleapis.com/v0/b/ecomm-37.appspot.com/o/';

final FirebaseFirestore FIRESTORE = FirebaseFirestore.instance;
final FirebaseMessaging MESSAGING = FirebaseMessaging.instance;
final FirebaseStorage STORAGE = FirebaseStorage.instance;
final FirebaseCrashlytics CRASHLYTICS = FirebaseCrashlytics.instance;
