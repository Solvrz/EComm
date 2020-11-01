import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';

class AlertButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color backgroundColor;
  final Color titleColor;
  final double titleSize;
  final BorderRadius borderRadius;

  AlertButton(
      {@required this.title,
      @required this.onPressed,
      this.backgroundColor = kUIAccent,
      this.titleColor = kUIColor,
      this.titleSize = 17,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Colors.transparent,
      padding: EdgeInsets.only(top: 12, bottom: 12),
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
            fontFamily: "sans-serif-condensed",
            color: titleColor,
            fontSize: titleSize,
            fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
    );
  }
}
