import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {@required this.parent,
      @required this.title,
      this.elevation = 1.0,
      this.leading,
      this.trailing = const []});

  final BuildContext parent;
  final String title;
  final double elevation;
  final Widget leading;
  final List<Widget> trailing;

  Size get preferredSize => Size.fromHeight(65.0);

  @override
  Widget build(parent) {
    return AppBar(
      centerTitle: true,
      backgroundColor: kUIColor,
      elevation: elevation,
      toolbarHeight: 65,
      title: Text(
        title,
        style: TextStyle(
          color: kUIDarkText,
          fontSize: 24,
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
                  border: Border.all(color: kUIColor),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_back_ios, color: kUIDarkText, size: 26),
              ),
            )
          : leading,
      actions: trailing,
    );
  }
}
