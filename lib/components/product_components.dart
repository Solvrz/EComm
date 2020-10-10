import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';

class Option {
  String _name;
  Color _color;

  String get name => _name;

  Color get color => _color;

  Option({String name, dynamic color}) {
    _name = name;
    _color = color is String ? Color(int.parse("0xff$color")) : color;
  }
}

class OptionRadioTile extends StatefulWidget {
  final Text label;
  final List<Option> options;
  final double size;
  final double margin;

  OptionRadioTile(
      {@required this.label,
      @required this.options,
      this.size = 10,
      this.margin = 6});

  @override
  _OptionRadioTileState createState() => _OptionRadioTileState();
}

class _OptionRadioTileState extends State<OptionRadioTile> {
  int _currIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: widget.label,
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  widget.options.length,
                  (index) => GestureDetector(
                        onTap: () {
                          if (_currIndex != index)
                            setState(() {
                              _currIndex = index;
                            });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(2, 0, 2, 4),
                              width: (widget.size + widget.margin) * 2,
                              height: (widget.size + widget.margin) * 2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: _currIndex == index
                                    ? Border.all(
                                        color: Colors.grey[400], width: 2)
                                    : null,
                              ),
                              child: Center(
                                child: CircleAvatar(
                                  radius: widget.size,
                                  backgroundColor:
                                      widget.options[index].color ??
                                          Colors.grey[400],
                                  child: widget.options[index].color == null
                                      ? Text(
                                          widget.options[index].name[0]
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: kUIDarkText))
                                      : null,
                                ),
                              ),
                            ),
                            if (_currIndex == index)
                              Text(
                                widget.options[index].name,
                              ),
                          ],
                        ),
                      )))
        ],
      ),
    );
  }
}
