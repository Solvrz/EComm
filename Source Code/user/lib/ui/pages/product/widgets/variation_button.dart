import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '/config/constant.dart';
import '/models/product.dart';
import '/models/variation.dart';
import '/ui/widgets/marquee.dart';

// ignore: must_be_immutable
class VariationButton extends StatefulWidget {
  final Variation variation;
  final Function onChanged;
  final double size;
  final double margin;

  int selected;

  VariationButton({
    super.key,
    required this.variation,
    required this.onChanged,
    required this.selected,
    this.size = 10,
    this.margin = 6,
  });

  @override
  State<VariationButton> createState() => _VariationButtonState();
}

class _VariationButtonState extends State<VariationButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.size + widget.margin) * 2 + 45,
      padding: screenSize.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.variation.name,
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: screenSize.height(22),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              widget.variation.options.length,
              (index) => GestureDetector(
                onTap: () {
                  if (widget.selected != index) {
                    if (context.mounted) {
                      setState(() {
                        widget.selected = index;
                      });
                    }
                  }

                  widget.onChanged(index);
                },
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: screenSize.fromLTRB(2, 0, 2, 4),
                      width: (widget.size + widget.margin) * 2,
                      height: (widget.size + widget.margin) * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: widget.selected == index
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
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: widget.selected == index
                          ? TextStyle(
                              fontSize: screenSize.height(12),
                              color: theme.colorScheme.onPrimary,
                            )
                          : TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 0,
                            ),
                      child: Text(widget.variation.options[index].label),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddProductSheet extends StatefulWidget {
  final Product product;

  const AddProductSheet({
    super.key,
    required this.product,
  });

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
          color: theme.colorScheme.background,
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
                  if (widget.product.images.isNotEmpty)
                    SizedBox(
                      width: screenSize.height(100),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.images[0],
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: theme.highlightColor,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.grey),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    )
                  else
                    Container(
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
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "$CURRENCY ${widget.product.price}",
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sans-serif-condensed",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "$CURRENCY ${widget.product.mrp}",
                            style: TextStyle(
                              color:
                                  theme.colorScheme.onPrimary.withOpacity(0.7),
                              decoration: TextDecoration.lineThrough,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              fontFamily: "sans-serif-condensed",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                          if (BAG.getQuantity(widget.product) > 1) {
                            BAG.decreaseQuantity(widget.product);
                          }
                        });
                      },
                      child: Container(
                        padding: screenSize.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.highlightColor,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: theme.colorScheme.onPrimary.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Text(
                      BAG.getQuantity(widget.product).toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 18),
                    GestureDetector(
                      onTap: () {
                        setState(
                          () => BAG.increaseQuantity(widget.product),
                        );
                      },
                      child: Container(
                        padding: screenSize.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.highlightColor,
                        ),
                        child: Icon(
                          Icons.add,
                          color: theme.colorScheme.onPrimary.withOpacity(0.5),
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
                        color: theme.highlightColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "Keep Shopping",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            color: theme.colorScheme.onPrimary.withOpacity(0.8),
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
                        color: theme.primaryColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "To Bag",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            color: theme.colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
