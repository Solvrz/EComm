import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/constant.dart';
import '../../../models/product.dart';
import '../../../models/variation.dart';
import '../../../widgets/marquee.dart';

// ignore: must_be_immutable
class VariationButton extends StatefulWidget {
  final Variation variation;
  final Function onChanged;
  final double size;
  final double margin;

  int currIndex;

  VariationButton({
    Key? key,
    required this.variation,
    required this.onChanged,
    this.currIndex = 0,
    this.size = 10,
    this.margin = 6,
  }) : super(key: key);

  @override
  State<VariationButton> createState() => _VariationButtonState();
}

class _VariationButtonState extends State<VariationButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.size + widget.margin) * 2 + 44,
      padding: screenSize.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.variation.name,
              style: TextStyle(
                  color: kUIDarkText,
                  fontSize: screenSize.height(22),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              widget.variation.options.length,
              (index) => GestureDetector(
                onTap: () {
                  if (widget.currIndex != index) {
                    if (mounted) {
                      setState(() {
                        widget.currIndex = index;
                      });
                    }
                  }
                  widget.onChanged(index);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: screenSize.fromLTRB(2, 0, 2, 4),
                      width: (widget.size + widget.margin) * 2,
                      height: (widget.size + widget.margin) * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: widget.currIndex == index
                            ? Border.all(color: Colors.grey[400]!, width: 2)
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
                                      fontSize: screenSize.height(13),
                                      fontWeight: FontWeight.w600,
                                      color: kUIDarkText),
                                )
                              : null,
                        ),
                      ),
                    ),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: widget.currIndex == index
                          ? TextStyle(
                              fontSize: screenSize.height(12),
                              color: kUIDarkText)
                          : const TextStyle(color: kUIDarkText, fontSize: 0),
                      child: Text(widget.variation.options[index].label),
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

class AddProductSheet extends StatefulWidget {
  final Product product;

  const AddProductSheet({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        padding: screenSize.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                "Item added to bag",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: screenSize.fromLTRB(16, 24, 16, 32),
              height: screenSize.height(140),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  widget.product.images.isNotEmpty
                      ? SizedBox(
                          width: screenSize.height(100),
                          child: CachedNetworkImage(
                            imageUrl: widget.product.images[0],
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Theme.of(context).highlightColor,
                              highlightColor: Colors.grey[100]!,
                              child: Container(color: Colors.grey),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        )
                      : Container(
                          padding: screenSize.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: const Center(
                            child: Text(
                              "No Image",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                  const SizedBox(width: 36),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Marquee(
                        child: Text(
                          widget.product.name,
                          maxLines: 2,
                          style: const TextStyle(
                              color: kUIDarkText,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.4),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "₹ ${widget.product.price}",
                            style: const TextStyle(
                                color: kUIDarkText,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "sans-serif-condensed"),
                          ),
                          const SizedBox(width: 12),
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
                const Text(
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
                          if (bag.getQuantity(widget.product) > 1) {
                            bag.decreaseQuantity(widget.product);
                          }
                        });
                      },
                      child: Container(
                        padding: screenSize.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).highlightColor,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: kUIDarkText.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Text(
                      bag.getQuantity(widget.product).toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 18),
                    GestureDetector(
                      onTap: () {
                        setState(
                          () => bag.increaseQuantity(widget.product),
                        );
                      },
                      child: Container(
                        padding: screenSize.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).highlightColor,
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
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding:
                          screenSize.symmetric(vertical: 18, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
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
                const SizedBox(width: 18),
                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, "/bag");
                    },
                    child: Container(
                      padding:
                          screenSize.symmetric(vertical: 18, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
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
