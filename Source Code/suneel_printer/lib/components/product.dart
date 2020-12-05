import 'package:flutter/material.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';
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
                  if (widget.currIndex != index) if (mounted)
                    setState(() {
                      widget.currIndex = index;
                    });
                  widget.onChanged(index);
                },
                child: Container(
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
            ),
          )
        ],
      ),
    );
  }
}

class AddProductSheet extends StatefulWidget {
  final Product product;

  AddProductSheet(this.product);

  @override
  _AddProductSheetState createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                "Item added to bag",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 24, 16, 32),
              height: getHeight(context, 140),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  widget.product.images.length > 0
                      ? Image(image: widget.product.images[0])
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(border: Border.all()),
                          child: Center(
                            child: Text(
                              "No Image",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                  SizedBox(width: 36),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        maxLines: 3,
                        style: TextStyle(
                            color: kUIDarkText,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.4),
                      ),
                      Row(
                        children: [
                          Text(
                            "₹ ${widget.product.price}",
                            style: TextStyle(
                                color: kUIDarkText,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "sans-serif-condensed"),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "₹ ${widget.product.mrp}",
                            style: TextStyle(
                                color: kUIDarkText.withOpacity(0.7),
                                decoration: TextDecoration.lineThrough,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                fontFamily: "sans-serif-condensed"),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Change Quantity:",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "sans-serif-condensed",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (bag.getQuantity(widget.product) > 1)
                            bag.decreaseQuantity(widget.product);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: Icon(
                          Icons.remove,
                          color: kUIDarkText.withOpacity(0.5),
                        ),
                      ),
                    ),
                    SizedBox(width: 18),
                    Text(
                      bag.getQuantity(widget.product).toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 18),
                    GestureDetector(
                      onTap: () {
                        setState(() => bag.increaseQuantity(widget.product));
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: Icon(
                          Icons.add,
                          color: kUIDarkText.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName("/category"));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "Keep Shopping",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            color: kUIDarkText.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, "/bag");
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                      decoration: BoxDecoration(
                        color: kUIAccent.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "To Bag",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            color: kUILightText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
