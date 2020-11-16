import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/variation.dart';

// ignore: must_be_immutable
class OptionRadioTile extends StatefulWidget {
  final Variation variation;
  final Function onChanged;
  final double size;
  final double margin;
  int currIndex;

  OptionRadioTile(
      {@required this.variation,
      @required this.onChanged,
      this.currIndex = 0,
      this.size = 10,
      this.margin = 6});

  @override
  _OptionRadioTileState createState() => _OptionRadioTileState();
}

class _OptionRadioTileState extends State<OptionRadioTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.size + widget.margin) * 2 + 44,
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.variation.name,
              style: TextStyle(
                  color: kUIDarkText,
                  fontSize: getHeight(context, 22),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              widget.variation.options.length,
              (index) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (widget.currIndex != index)
                    setState(() {
                      widget.currIndex = index;
                    });
                  widget.onChanged(index);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.fromLTRB(2, 0, 2, 4),
                      width: (widget.size + widget.margin) * 2,
                      height: (widget.size + widget.margin) * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: widget.currIndex == index
                            ? Border.all(color: Colors.grey[400], width: 2)
                            : null,
                      ),
                      child: Center(
                        child: CircleAvatar(
                          radius: widget.size,
                          backgroundColor:
                              widget.variation.options[index].color ??
                                  Colors.grey[400],
                          child: widget.variation.options[index].color == null
                              ? Text(
                                  widget.variation.options[index].label[0]
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: getHeight(context, 13),
                                      fontWeight: FontWeight.w600,
                                      color: kUIDarkText),
                                )
                              : null,
                        ),
                      ),
                    ),
                    AnimatedDefaultTextStyle(
                      child: Text(widget.variation.options[index].label),
                      duration: Duration(milliseconds: 200),
                      style: widget.currIndex == index
                          ? TextStyle(
                              fontSize: getHeight(context, 14),
                              color: kUIDarkText)
                          : TextStyle(color: kUIDarkText, fontSize: 0),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
