import 'package:flutter/material.dart';

import '../config/constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext parent;
  final String title;
  final Color? color;
  final Color textColor;
  final double elevation;
  final Widget? leading;
  final List<Widget> trailing;

  CustomAppBar({
    required this.parent,
    required this.title,
    this.color,
    this.textColor = kUIDarkText,
    this.elevation = 1,
    this.leading,
    this.trailing = const [],
  });

  Size get preferredSize => Size.fromHeight(65);

  @override
  Widget build(parent) {
    return AppBar(
      centerTitle: true,
      backgroundColor: color ?? Theme.of(parent).backgroundColor,
      elevation: elevation,
      toolbarHeight: 65,
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: screenSize.height(24),
          fontWeight: FontWeight.bold,
          fontFamily: "sans-serif-condensed",
        ),
      ),
      leading: leading == null
          ? GestureDetector(
              onTap: () => Navigator.pop(parent),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: color ?? Theme.of(parent).backgroundColor,
                  ),
                ),
                padding: screenSize.all(8),
                child: Icon(Icons.arrow_back_ios, color: textColor, size: 26),
              ),
            )
          : leading,
      actions: trailing,
    );
  }
}
