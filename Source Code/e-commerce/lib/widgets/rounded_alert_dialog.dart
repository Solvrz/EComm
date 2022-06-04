import 'package:flutter/material.dart';

import '../config/constant.dart';

class RoundedAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> buttonsList;
  final List<Widget>? widgets;
  final bool isExpanded;
  final bool centerTitle;
  final double titleSize;
  final double descriptionSize;

  const RoundedAlertDialog({
    Key? key,
    required this.title,
    this.description = "",
    this.buttonsList = const [],
    this.widgets,
    this.isExpanded = true,
    this.centerTitle = true,
    this.titleSize = 24,
    this.descriptionSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: title != ""
          ? Text(
              title,
              textAlign: centerTitle ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                  color: kUIDarkText,
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold),
            )
          : null,
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        if (description != "")
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: kUIDarkText, fontSize: descriptionSize),
          ),
        if (widgets != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets!,
          ),
        if (buttonsList.isNotEmpty)
          Row(
            mainAxisAlignment: isExpanded
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.end,
            children: List.generate(
              buttonsList.length,
              (index) => isExpanded
                  ? Expanded(
                      child: Padding(
                        padding: screenSize.symmetric(horizontal: 4),
                        child: buttonsList[index],
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: buttonsList[index],
                    ),
            ),
          )
      ]),
    );
  }
}
