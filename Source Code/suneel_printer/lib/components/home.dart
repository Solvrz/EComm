import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suneel_printer/constant.dart';

class InformationSheet extends StatefulWidget {
  final bool popable;

  InformationSheet({this.popable = true});

  @override
  _InformationSheetState createState() => _InformationSheetState();
}

class _InformationSheetState extends State<InformationSheet> {
  Future<void> save() async {
    await preferences.setStringList(
      "info",
      addresses
          .map(
            (e) => jsonEncode(e),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.popable) {
          await save();
          return true;
        }
        return false;
      },
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: kUIColor,
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Delivery Information",
                      style: TextStyle(
                          color: kUIDarkText,
                          fontSize: getHeight(context, 24),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (widget.popable)
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        await save();
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.close, color: kUIDarkText),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 11.5),
              Divider(height: 1, thickness: 1, color: Colors.grey[400]),
              Expanded(
                child: Column(children: [
                  Expanded(
                    child: addresses.length > 0
                        ? ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: addresses.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map address = addresses[index];
                              bool isSelected = address["selected"];

                              return ListTile(
                                onTap: () async {
                                  selectedInfo = address;
                                  addresses[index]["selected"] = true;
                                  await save();
                                  if (mounted) setState(() {});
                                  Navigator.pop(context);
                                },
                                leading: Icon(Icons.home_outlined,
                                    size: 28,
                                    color: isSelected
                                        ? kUIDarkText
                                        : Colors.grey[600]),
                                trailing: SizedBox(
                                  width: 60,
                                  child: Row(children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () async {
                                        await showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (_) => Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: AddInformationSheet(
                                              addresses: addresses,
                                              edit: true,
                                              data: address,
                                            ),
                                          ),
                                        );
                                        await save();
                                        if (mounted) setState(() {});
                                      },
                                      child: Container(
                                        child: Icon(Icons.edit,
                                            color: Colors.grey[700]),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () async {
                                        if (isSelected) {
                                          if (addresses.length == 1) {
                                            addresses.remove(address);
                                            selectedInfo = null;
                                          } else {
                                            Map newAddress = addresses[
                                                index - 1 >= 0
                                                    ? index - 1
                                                    : index + 1];
                                            addresses.remove(address);
                                            newAddress["selected"] = true;
                                            selectedInfo = newAddress;
                                          }
                                        } else {
                                          addresses.remove(address);
                                        }
                                        await save();
                                        if (mounted) setState(() {});
                                      },
                                      child: Container(
                                        child: Icon(Icons.delete,
                                            color: Colors.grey[700]),
                                      ),
                                    )
                                  ]),
                                ),
                                title: Text(
                                  "${address["name"].toString().capitalize()}, ${address["phone"]}",
                                  style: TextStyle(
                                      color: isSelected
                                          ? kUIDarkText
                                          : Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: getHeight(context, 18),
                                      letterSpacing: 0.2),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    address["address"],
                                    style: TextStyle(
                                        color: kUIDarkText, letterSpacing: 0.2),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                                    thickness: 0.75, color: Colors.grey[400]),
                          )
                        : Center(
                            child: Text(
                              "No Information Added",
                              style: TextStyle(
                                  color: kUIDarkText,
                                  fontSize: getHeight(context, 20),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) => Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: AddInformationSheet(addresses: addresses),
                        ),
                      );
                      if (mounted) setState(() {});
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: kUIAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Add Information",
                          style: TextStyle(
                              fontSize: getHeight(context, 18),
                              fontWeight: FontWeight.bold,
                              color: kUIColor),
                        ),
                      ),
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddInformationSheet extends StatefulWidget {
  final List<Map> addresses;
  final bool edit;
  final Map data;

  AddInformationSheet({
    this.addresses,
    this.edit = false,
    this.data = const {},
  });

  @override
  _AddInformationSheetState createState() => _AddInformationSheetState();
}

class _AddInformationSheetState extends State<AddInformationSheet> {
  Map<String, Map> fields = {
    "name": {
      "title": "Name",
      "placeholder": "Your Name",
      "errorMessage": "Please enter a name"
    },
    "phone": {
      "title": "Phone Number",
      "placeholder": "Your Phone Number",
      "errorMessage": "Please enter a valid phone number",
      "inputType": TextInputType.number,
    },
    "email": {
      "title": "Email Address",
      "placeholder": "Your Email Address",
      "errorMessage": "Please enter a valid email address",
      "inputType": TextInputType.emailAddress,
    },
    "address": {
      "title": "Shipping Address",
      "placeholder": "Your Address",
      "errorMessage": "Please enter an address",
    },
    "pincode": {
      "title": "Pincode",
      "placeholder": "Your Pincode",
      "errorMessage": "Please enter a valid pincode",
      "inputType": TextInputType.number,
    }
  };

  Map<String, TextEditingController> controllers;
  Map<String, bool> error;

  @override
  void initState() {
    super.initState();

    controllers = fields.map((key, _) =>
        MapEntry(key, TextEditingController(text: widget.data[key] ?? "")));
    error = fields.map((key, _) => MapEntry(key, false));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: kUIColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                      child: Icon(Icons.arrow_back_ios, color: kUIDarkText),
                    ),
                  ),
                ),
                Text(
                  "${widget.edit ? "Edit" : "Add"} Information",
                  style: TextStyle(
                      color: kUIDarkText,
                      fontSize: getHeight(context, 24),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(height: 12),
            ...List.generate(fields.length, (int index) {
              String field = fields.keys.elementAt(index);
              Map data = fields.values.elementAt(index);
              TextEditingController controller = controllers[field];

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["title"],
                      style: TextStyle(
                          color: kUIDarkText,
                          fontSize: getHeight(context, 16),
                          fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: data["placeholder"]),
                      controller: controller,
                      keyboardType: data["inputType"] ?? TextInputType.name,
                      minLines: 1,
                      maxLines: data["maxLines"] ?? 3,
                      style: TextStyle(
                          color: kUIDarkText,
                          fontSize: getHeight(context, 16),
                          fontWeight: FontWeight.w500),
                    ),
                    if (error[field]) ...[
                      Text(
                        data["errorMessage"],
                        style: TextStyle(
                            fontSize: getHeight(context, 15), color: kUIAccent),
                      ),
                      SizedBox(height: 8),
                    ],
                    Divider(
                      height: 8,
                      thickness: 2,
                    ),
                    SizedBox(height: 12),
                  ]);
            }),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                if (await validateFields() == false) {
                  return;
                } else {
                  String name = controllers["name"].text.trim();
                  String phone = controllers["phone"].text.trim();
                  String address = controllers["address"].text.trim();
                  String email = controllers["email"].text.trim();
                  String pincode = controllers["pincode"].text.trim();

                  if (widget.edit) {
                    int index = widget.addresses.indexOf(widget.data);
                    widget.addresses.removeAt(index);
                    widget.addresses.insert(index, {
                      "name": name,
                      "phone": phone,
                      "address": address,
                      "email": email,
                      "pincode": pincode,
                      "selected": false
                    });
                    selectedInfo = widget.addresses[index];
                  } else {
                    widget.addresses.add({
                      "name": name,
                      "phone": phone,
                      "address": address,
                      "email": email,
                      "pincode": pincode,
                      "selected": false
                    });
                  }

                  await preferences.setStringList(
                    "info",
                    widget.addresses
                        .map(
                          (e) => jsonEncode(e),
                        )
                        .toList(),
                  );

                  Navigator.pop(context);
                }
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: kUIAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "${widget.edit ? "Save" : "Add"} Information",
                    style: TextStyle(
                      fontSize: getHeight(context, 18),
                      fontWeight: FontWeight.bold,
                      color: kUIColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> validateFields() async {
    String name = controllers["name"].text.trim();
    String phone = controllers["phone"].text.trim();
    String address = controllers["address"].text.trim();
    String email = controllers["email"].text.trim();
    String pincode = controllers["pincode"].text.trim();

    if (name == "")
      error["name"] = true;
    else
      error["name"] = false;

    if (!RegExp(r"^(\+91[\-\s]?)?[0]?(91)?[789]\d{9}$").hasMatch(phone))
      error["phone"] = true;
    else
      error["phone"] = false;

    if (address == "")
      error["address"] = true;
    else
      error["address"] = false;

    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email))
      error["email"] = true;
    else
      error["email"] = false;

    http.Response result =
        await http.get("https://api.postalpincode.in/pincode/$pincode");

    if (jsonDecode(result.body)[0]["Status"] == "Error" || pincode == "")
      error["pincode"] = true;
    else
      error["pincode"] = false;

    if (mounted) setState(() {});

    return !error.values.toList().contains(true);
  }
}
