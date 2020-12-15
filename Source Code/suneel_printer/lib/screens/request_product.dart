import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suneel_printer/components/home.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/payment.dart';

// ignore: must_be_immutable
class RequestProductPage extends StatefulWidget {
  String title;
  List tabsData;

  RequestProductPage({this.title, this.tabsData});

  @override
  _RequestProductPageState createState() => _RequestProductPageState();
}

class _RequestProductPageState extends State<RequestProductPage> {
  String value;

  @override
  void initState() {
    super.initState();
    value = "Choose a Service";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                height: getHeight(context, 100),
                width: MediaQuery.of(context).size.width / 1.3,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Service: ",
                          style: TextStyle(
                            color: kUIDarkText,
                            fontSize: getHeight(context, 25),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton(
                          hint: Text(value),
                          onChanged: (val) {
                            if (mounted)
                              setState(() {
                                value = val;
                              });
                          },
                          items: List.generate(widget.tabsData.length,
                                  (index) => widget.tabsData[index]["name"])
                              .map<DropdownMenuItem>(
                                (var val) => DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                    style: TextStyle(
                                        fontSize: getHeight(context, 18),
                                        color: Colors.grey[900],
                                        letterSpacing: 0.2,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "sans-serif-condensed"),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      ]),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                height: getHeight(context, 200),
                width: MediaQuery.of(context).size.width / 1.3,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: selectedInfo == null
                      ? Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (_) => Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: InformationSheet(),
                                ),
                              );

                              if (mounted) setState(() {});
                            },
                            child: Container(
                              child: Text(
                                "Click Here \nSelect Information",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: kUIDarkText,
                                  fontSize: getHeight(context, 20),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Name: ",
                                        style: TextStyle(
                                          color: kUIDarkText,
                                          fontSize: getHeight(context, 20),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${selectedInfo['name'].toString().capitalize()}",
                                        style: TextStyle(
                                          fontSize: getHeight(context, 18),
                                          color: Colors.grey[900],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (_) => Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: InformationSheet(),
                                        ),
                                      );

                                      if (mounted) setState(() {});
                                    },
                                    child: Container(
                                      child: Icon(
                                        Icons.edit,
                                        size: 25,
                                        color: kUIDarkText.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Phone: ",
                                    style: TextStyle(
                                      color: kUIDarkText,
                                      fontSize: getHeight(context, 20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${selectedInfo['phone']}",
                                    style: TextStyle(
                                      fontSize: getHeight(context, 18),
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Email: ",
                                    style: TextStyle(
                                      color: kUIDarkText,
                                      fontSize: getHeight(context, 20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${selectedInfo['email']}",
                                    style: TextStyle(
                                      fontSize: getHeight(context, 18),
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Address: ",
                                    style: TextStyle(
                                      color: kUIDarkText,
                                      fontSize: getHeight(context, 20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${selectedInfo['address'].toString().capitalize()}, ${selectedInfo['pincode']}"
                                          .replaceAll("", "\u{200B}"),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: getHeight(context, 18),
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                ),
              )
            ]),
            Padding(
              padding: EdgeInsets.all(8),
              child: MaterialButton(
                onPressed: value != "Choose a Service" && selectedInfo != null
                    ? () async {
                        Navigator.popAndPushNamed(
                          context,
                          "/payment",
                          arguments: PaymentArguments(
                              success: true,
                              msg:
                                  "You will soon receive a confirmation mail from us.",
                              process: () async {
                                await http.post(
                                  "https://suneel-printers.herokuapp.com/request",
                                  headers: <String, String>{
                                    "Content-Type":
                                        "application/json; charset=UTF-8",
                                  },
                                  body: jsonEncode(<String, String>{
                                    "name": selectedInfo["name"],
                                    "phone": selectedInfo["phone"],
                                    "address": selectedInfo["address"],
                                    "email": selectedInfo["email"],
                                    "order_list": value
                                  }),
                                );
                              }),
                        );
                      }
                    : null,
                disabledColor: kUIDarkText.withOpacity(0.5),
                color: kUIAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.grey[200]),
                      SizedBox(width: 8),
                      Text(
                        "Place Order",
                        style: TextStyle(
                            fontSize: getHeight(context, 16),
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[200]),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
    );
  }
}