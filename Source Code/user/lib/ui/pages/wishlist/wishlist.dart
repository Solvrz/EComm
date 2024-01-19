import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';

import '/config/constant.dart';
import '/models/product.dart';
import '/ui/pages/product/export.dart';
import '/ui/widgets/custom_app_bar.dart';
import '/ui/widgets/marquee.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(context: context, title: "My Wishlist"),
        body: Column(
          children: [
            Expanded(
              child: WISHLIST.products.isNotEmpty
                  ? Padding(
                      padding:
                          screenSize.symmetric(horizontal: 12, vertical: 24),
                      child: AnimatedList(
                        shrinkWrap: true,
                        key: _listKey,
                        initialItemCount: WISHLIST.products.length,
                        itemBuilder: (context, index, animation) =>
                            _buildItem(context, index, animation),
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.25,
                        child: EmptyWidget(
                          packageImage: PackageImage.Image_4,
                          title: "No Items",
                          subTitle: "Shop and add more items",
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final Product product = WISHLIST.products[index];

    return SizeTransition(
      sizeFactor: animation,
      child: Slidable(
        key: ObjectKey(WISHLIST.products[index]),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            Flexible(
              flex: 6,
              child: GestureDetector(
                onTap: () {
                  Timer(const Duration(milliseconds: 200), () {
                    WISHLIST.removeProduct(product);
                    if (context.mounted) setState(() {});
                  });

                  _listKey.currentState!.removeItem(
                    index,
                    (context, animation) =>
                        _buildItem(context, index, animation),
                    duration: const Duration(milliseconds: 200),
                  );
                },
                child: Container(
                  margin: screenSize.only(left: 12),
                  height: MediaQuery.of(context).size.height / 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: theme.primaryColor,
                  ),
                  child: Icon(
                    Icons.delete,
                    color: theme.colorScheme.onSecondary,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            "/product",
            arguments: ProductArguments(WISHLIST.products[index]),
          ),
          child: Container(
            margin: screenSize.symmetric(vertical: 8),
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: theme.highlightColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: screenSize.symmetric(horizontal: 24, vertical: 18),
                    child: Row(
                      children: [
                        if (product.images.isNotEmpty)
                          SizedBox(
                            width: screenSize.height(100),
                            child: CachedNetworkImage(
                              imageUrl: product.images[0],
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
                          const Text("No Image"),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Marquee(
                                child: Text(
                                  product.name,
                                  style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: screenSize.height(22),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "$CURRENCY ${product.price}",
                                    style: TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                      fontSize: screenSize.height(21),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "sans-serif-condensed",
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "$CURRENCY ${product.mrp}"
                                          .replaceAll("", "\u{200B}"),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimary
                                            .withOpacity(0.7),
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: screenSize.height(18),
                                        fontWeight: FontWeight.w800,
                                        fontFamily: "sans-serif-condensed",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
