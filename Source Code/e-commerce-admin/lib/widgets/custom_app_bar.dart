import 'package:flutter/material.dart';

import '../config/constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext parent;
  final String title;
  final double elevation;
  final Widget? leading;
  final List<Widget> trailing;

  CustomAppBar({
    required this.parent,
    required this.title,
    this.elevation = 1,
    this.leading,
    this.trailing = const [],
  });

  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(parent) {
    return AppBar(
      centerTitle: true,
      elevation: elevation,
      toolbarHeight: 65,
      title: Text(
        title,
        style: TextStyle(
          color: kUIDarkText,
          fontSize: screenSize.height(24),
          fontWeight: FontWeight.bold,
          fontFamily: "sans-serif-condensed",
        ),
      ),
      leading: leading == null
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pop(parent),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                padding: screenSize.all(8),
                child: Icon(Icons.arrow_back_ios, color: kUIDarkText, size: 26),
              ),
            )
          : leading,
      actions: trailing,
    );
  }
}
