import 'package:flutter/material.dart';
import 'package:suneel_printer_admin/config/constant.dart';

class AlertButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color backgroundColor;
  final Color titleColor;
  final double titleSize;
  final BorderRadius borderRadius;

  AlertButton({
    @required this.title,
    @required this.onPressed,
    this.backgroundColor,
    this.titleColor,
    this.titleSize = 17,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Colors.transparent,
      padding: screenSize.symmetric(vertical: 12),
      color: backgroundColor ?? Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Container(
        child: Text(
          title,
          style: TextStyle(
            color: titleColor ?? Theme.of(context).backgroundColor,
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
