import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:suneel_printer/components/information_textfield.dart';
import 'package:suneel_printer/constant.dart';

class InformationSheet extends StatefulWidget {
  final BuildContext parentContext;
  final bool popable;

  InformationSheet({@required this.parentContext, this.popable = true});

  @override
  _InformationSheetState createState() => _InformationSheetState();
}

class _InformationSheetState extends State<InformationSheet> {
  List<Map> addresses;

  @override
  void initState() {
    super.initState();
    addresses = (preferences.getStringList("info") ?? [])
        .map<Map>((e) => jsonDecode(e))
        .toList();
  }

  Future<void> save() async {
    await preferences.setStringList(
        "info", addresses.map((e) => jsonEncode(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await save();
        return widget.popable ? true : false;
      },
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Delivery Information",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (widget.popable)
                    GestureDetector(
                      onTap: () async {
                        await save();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.close, color: kUIDarkText),
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
                            itemBuilder: (context, int index) {
                              Map address = addresses[index];
                              bool isSelected =
                                  address.toString() == selectedInfo.toString();

                              return ListTile(
                                onTap: () async {
                                  await save();
                                  selectedInfo = address;
                                  setState(() {});
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
                                        onTap: () async {
                                          await showMaterialModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (_, __) => Padding(
                                              padding: MediaQuery.of(context)
                                                  .viewInsets,
                                              child: AddInformationSheet(
                                                addresses: addresses,
                                                edit: true,
                                                data: address,
                                              ),
                                            ),
                                          );
                                          setState(() {});
                                        },
                                        child: Icon(Icons.edit,
                                            color: Colors.grey[700])),
                                    SizedBox(width: 12),
                                    GestureDetector(
                                        onTap: () async {
                                          if (isSelected) {
                                            if (addresses.length == 1)
                                              selectedInfo = null;
                                            else
                                              selectedInfo = addresses[
                                                  index - 1 >= 0
                                                      ? index - 1
                                                      : index + 1];

                                            // TODO: Save Selected Info to Shared Prefrences
                                          }

                                          addresses.removeAt(index);
                                          setState(() {});
                                        },
                                        child: Icon(Icons.delete,
                                            color: Colors.grey[700]))
                                  ]),
                                ),
                                title: Text(
                                    "${address["name"].toString().capitalize()}, ${address["phone"]}",
                                    style: TextStyle(
                                        color: isSelected
                                            ? kUIDarkText
                                            : Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        fontFamily: "sans-serif-condensed",
                                        letterSpacing: 0.2)),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    address["address"],
                                    style: TextStyle(
                                        fontFamily: "sans-serif-condensed",
                                        letterSpacing: 0.2),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, int index) => Divider(
                                thickness: 0.75, color: Colors.grey[400]),
                          )
                        : Center(
                            child: Text("No Information Added",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500))),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await showMaterialModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_, __) => Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: AddInformationSheet(addresses: addresses),
                        ),
                      );
                      setState(() {});
                    },
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: kUIAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text("Add Information",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)))),
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
  final Map<String, dynamic> data;

  AddInformationSheet({this.addresses, this.edit = false, this.data});

  @override
  _AddInformationSheetState createState() => _AddInformationSheetState();
}

class _AddInformationSheetState extends State<AddInformationSheet> {
  Map<String, InformationTextField> fields = {
    "name": InformationTextField(
        title: "Name",
        placeholder: "Your Name",
        errorMessage: "Please enter a name"),
    "phone": InformationTextField(
      title: "Phone Number",
      placeholder: "Your Phone Number",
      errorMessage: "Please enter a valid phone number",
      inputType: TextInputType.number,
    ),
    "email": InformationTextField(
      title: "Email Address",
      placeholder: "Your Email Address",
      errorMessage: "Please enter a valid email address",
      inputType: TextInputType.emailAddress,
    ),
    "address": InformationTextField(
      title: "Shipping Address",
      placeholder: "Your Address",
      errorMessage: "Please enter an address",
    ),
    "pincode": InformationTextField(
      title: "Pincode",
      placeholder: "Your Pincode",
      errorMessage: "Please enter a valid pincode",
      inputType: TextInputType.number,
    )
  };

  @override
  void initState() {
    super.initState();

    if ((widget.data ?? {}).length > 0) {
      widget.data.forEach((key, value) {
        fields[key].controller.text = value;
      });
    }
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
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: Icon(Icons.arrow_back_ios, color: kUIDarkText),
                  ),
                ),
                Text(
                  "${widget.edit ? "Edit" : "Add"} Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(height: 12),
            ...fields.values.toList(),
            GestureDetector(
              onTap: () async {
                if (await validateFields() == false)
                  return;
                else
                  setState(() {}); 
                  //TODO FIXME: Doesn't show error till hot refresh

                String name = fields["name"].value;
                String phone = fields["phone"].value;
                String address = fields["address"].value;
                String email = fields["email"].value;
                String pincode = fields["pincode"].value;

                if (widget.edit) {
                  int index = widget.addresses.indexOf(widget.data);
                  widget.addresses.removeAt(index);
                  widget.addresses.insert(index, {
                    "name": name,
                    "phone": phone,
                    "address": address,
                    "email": email,
                    "pincode": pincode
                  });
                } else {
                  widget.addresses.add({
                    "name": name,
                    "phone": phone,
                    "address": address,
                    "email": email,
                    "pincode": pincode
                  });
                }

                await preferences.setStringList("info",
                    widget.addresses.map((e) => jsonEncode(e)).toList());

                Navigator.pop(context);
              },
              child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: kUIAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text("${widget.edit ? "Save" : "Add"} Information",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)))),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> validateFields() async {
    String name = fields["name"].value;
    String phone = fields["phone"].value;
    String address = fields["address"].value;
    String email = fields["email"].value;
    String pincode = fields["pincode"].value;

    if (name.trim() == "")
      fields["name"].error = true;
    else
      fields["name"].error = false;

    if (!RegExp(r"^(\+91[\-\s]?)?[0]?(91)?[789]\d{9}$").hasMatch(phone))
      fields["phone"].error = true;
    else
      fields["phone"].error = false;

    if (address.trim() == "")
      fields["address"].error = true;
    else
      fields["address"].error = false;

    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email))
      fields["email"].error = true;
    else
      fields["email"].error = false;

    http.Response result =
        await http.get("https://api.postalpincode.in/pincode/$pincode");

    if (jsonDecode(result.body)[0]["Status"] == "Error" || pincode.trim() == "")
      fields["pincode"].error = true;
    else
      fields["pincode"].error = false;

    return !fields.values.toList().map((e) => e.error).toList().contains(true);
  }
}
