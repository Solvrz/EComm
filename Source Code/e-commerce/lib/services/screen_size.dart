import 'package:flutter/material.dart';

class ScreenSize {
  final BuildContext context;

  const ScreenSize({required this.context});

  double height(double height) => scaleHeight(height / 816);

  double scaleHeight(double scaleFactor) =>
      MediaQuery.of(context).size.height * scaleFactor;

  double width(double width) => scaleWidth(width / 411.42);

  double scaleWidth(double scaleFactor) =>
      MediaQuery.of(context).size.width * scaleFactor;

  double aspectRatio(double aspect) =>
      aspect * 816 / MediaQuery.of(context).size.height;

  EdgeInsets all(double value) => symmetric(horizontal: value, vertical: value);

  EdgeInsets symmetric({
    double horizontal = 0,
    double vertical = 0,
  }) =>
      EdgeInsets.symmetric(
        horizontal: width(horizontal),
        vertical: height(vertical),
      );

  EdgeInsets fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) =>
      EdgeInsets.fromLTRB(
        width(left),
        height(top),
        width(right),
        height(bottom),
      );

  EdgeInsets only(
          {double left = 0,
          double top = 0,
          double right = 0,
          double bottom = 0}) =>
      EdgeInsets.only(
        left: width(left),
        top: height(top),
        right: width(right),
        bottom: height(bottom),
      );
}
