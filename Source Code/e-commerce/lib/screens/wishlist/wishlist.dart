import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/constant.dart';
import '../../models/product.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/marquee.dart';
import '../product/export.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(parent: context, title: "My Wishlist"),
        body: Column(
          children: [
            Expanded(
              child: wishlist.products.isNotEmpty
                  ? Padding(
                      padding:
                          screenSize.symmetric(horizontal: 12, vertical: 24),
                      child: AnimatedList(
                        shrinkWrap: true,
                        key: _listKey,
                        initialItemCount: wishlist.products.length,
                        itemBuilder: (BuildContext context, int index,
                                Animation<double> animation) =>
                            _buildItem(context, index, animation),
                      ),
                    )
                  : Center(
                      child: Container(
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
      BuildContext context, int index, Animation<double> animation) {
    final Product product = wishlist.products[index];

    return SizeTransition(
      sizeFactor: animation,
      child: Slidable(
        key: ObjectKey(wishlist.products[index]),
        startActionPane: ActionPane(
          // TODO: Test Me
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              label: 'Archive',
              backgroundColor: Colors.blue,
              icon: Icons.archive,
              onPressed: (context) {},
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              label: 'Delete',
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: (context) {},
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            "/product",
            arguments: ProductArguments(wishlist.products[index]),
          ),
          child: Container(
            margin: screenSize.symmetric(vertical: 8),
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).highlightColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: screenSize.symmetric(horizontal: 24, vertical: 18),
                    child: Row(
                      children: [
                        product.images.length > 0
                            ? Container(
                                width: screenSize.height(100),
                                child: CachedNetworkImage(
                                  imageUrl: product.images[0],
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Theme.of(context).highlightColor,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(color: Colors.grey),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              )
                            : Text("No Image"),
                        SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Marquee(
                                child: Text(
                                  product.name,
                                  style: TextStyle(
                                      color: kUIDarkText,
                                      fontSize: screenSize.height(22),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.4),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "₹ ${product.price}",
                                    style: TextStyle(
                                        color: kUIDarkText,
                                        fontSize: screenSize.height(21),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "sans-serif-condensed"),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "₹ ${product.mrp}"
                                          .replaceAll("", "\u{200B}"),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: kUIDarkText.withOpacity(0.7),
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: screenSize.height(18),
                                          fontWeight: FontWeight.w800,
                                          fontFamily: "sans-serif-condensed"),
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
        // secondaryActions: [
        //   GestureDetector(
        //     onTap: () {
        //       Timer(Duration(milliseconds: 200), () {
        //         wishlist.removeProduct(product);
        //         if (mounted) setState(() {});
        //       });

        //       _listKey.currentState.removeItem(
        //         index,
        //         (context, animation) => _buildItem(context, index, animation),
        //         duration: Duration(milliseconds: 200),
        //       );
        //     },
        //     child: Container(
        //       margin: screenSize.only(left: 12),
        //       height: MediaQuery.of(context).size.height / 6,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(25),
        //           color: Theme.of(context).primaryColor),
        //       child: Icon(Icons.delete, color: kUILightText, size: 32),
        //     ),
        //   )
        // ],
      ),
    );
  }
}
