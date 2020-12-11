import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';

class AlertButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color backgroundColor;
  final double titleSize;
  final BorderRadius borderRadius;

  AlertButton({@required this.title,
    @required this.onPressed,
    this.backgroundColor = kUIAccent,
    this.titleSize = 17,
    this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 12),
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Container(
        child: Text(
          title,
          style: TextStyle(
              color: kUIColor,
              fontSize: titleSize,
              fontWeight: FontWeight.bold),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
