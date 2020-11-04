import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';

// ignore: must_be_immutable
class InformationTextField extends StatelessWidget {
  final String title;
  final String placeholder;
  final String errorMessage;
  final TextInputType inputType;
  final int maxLines;

  InformationTextField(
      {this.title,
      this.placeholder,
      this.errorMessage,
      this.inputType = TextInputType.name,
      this.maxLines = 3});

  bool error = false;
  TextEditingController controller = TextEditingController();

  String get value => controller.text;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: TextStyle(
            fontFamily: "sans-serif-condensed",
            color: kUIDarkText,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      TextField(
        decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: placeholder),
        controller: controller,
        keyboardType: inputType,
        minLines: 1,
        maxLines: maxLines,
        style: TextStyle(
            fontFamily: "sans-serif-condensed",
            color: kUIDarkText,
            fontSize: 17,
            fontWeight: FontWeight.w500),
      ),
      if (error) ...[
        Text(
          errorMessage,
          style: TextStyle(
              fontFamily: "sans-serif-condensed",
              fontSize: 15,
              color: kUIAccent),
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
