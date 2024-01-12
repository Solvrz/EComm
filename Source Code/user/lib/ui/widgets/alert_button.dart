import 'package:flutter/material.dart';

import '/config/constant.dart';

class AlertButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final Color? backgroundColor;
  final double titleSize;
  final BorderRadius? borderRadius;

  const AlertButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
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
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.background,
          fontSize: titleSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
