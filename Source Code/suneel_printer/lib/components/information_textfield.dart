import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InformationTextField extends StatefulWidget {
  String title;
  String placeholder;
  String errorMessage;
  TextInputType inputType;

  InformationTextField(
      {this.title,
        this.placeholder,
        this.errorMessage,
        this.inputType = TextInputType.name});

  bool error = false;
  TextEditingController controller = TextEditingController();

  String get value => controller.text;

  @override
  _InformationTextFieldState createState() => _InformationTextFieldState();
}

class _InformationTextFieldState extends State<InformationTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      TextField(
        decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: widget.placeholder),
        controller: widget.controller,
        keyboardType: widget.inputType,
        style: TextStyle(
            fontSize: 17, color: Colors.grey[600], fontWeight: FontWeight.w500),
      ),
      if (widget.error) ...[
        Text(
          widget.errorMessage,
          style: TextStyle(fontSize: 15, color: Colors.redAccent),
        ),
        SizedBox(height: 8),
      ],
      Divider(
        height: 8,
        thickness: 2,
      ),
      SizedBox(height: 12),
    ]);
  }
}
