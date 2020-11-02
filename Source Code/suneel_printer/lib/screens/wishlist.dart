import 'dart:async';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/screens/product.dart';

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
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: kUIDarkText,
                        size: 26,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "My Wishlist",
                        style: TextStyle(
                            fontSize: 24,
                            color: kUIDarkText,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: wishlist.products.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 24.0),
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
                        child: EmptyListWidget(
                          packageImage: PackageImage.Image_2,
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
        actionPane: SlidableDrawerActionPane(),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            "/product",
            arguments: ProductArguments(wishlist.products[index]),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey[200]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    child: Row(
                      children: [
                        product.images.length > 0
                            ? Image(image: product.images[0])
                            : Text("No Image Provided"),
                        SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                product.name,
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "sans-serif-condensed",
                                    letterSpacing: -0.4),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  "₹ ${product.price}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -1,
                                      fontFamily: "sans-serif-condensed"),
                                ),
                              )
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
        secondaryActions: [
          GestureDetector(
            onTap: () {
              Timer(Duration(milliseconds: 200), () {
                wishlist.removeItem(product);
                setState(() {});
              });
              _listKey.currentState.removeItem(
                index,
                (context, animation) => _buildItem(context, index, animation),
                duration: Duration(milliseconds: 200),
              );
            },
            child: Container(
              margin: EdgeInsets.only(left: 12),
              height: MediaQuery.of(context).size.height / 6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: kUIAccent),
              child: Icon(Icons.delete, color: kUILightText, size: 32),
            ),
          )
        ],
      ),
    );
  }
}
