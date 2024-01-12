import 'package:flutter/material.dart';

import '/config/constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final String title;
  final Color? color;
  final Color textColor;
  final double elevation;
  final Widget? leading;
  final List<Widget> trailing;

  const CustomAppBar({
    super.key,
    required this.context,
    required this.title,
    this.color,
    this.textColor = Colors.black,
    this.elevation = 1,
    this.leading,
    this.trailing = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: color ?? Theme.of(context).colorScheme.background,
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
      leading: leading ??
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: screenSize.all(10),
              child: Icon(Icons.arrow_back_ios, color: textColor, size: 30),
            ),
          ),
      actions: trailing,
    );
  }
}
