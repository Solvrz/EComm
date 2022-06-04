import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';

import './widgets/checkout_sheet.dart';
import '../../config/constant.dart';
import '../../models/product.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/information_sheet.dart';
import '../../widgets/marquee.dart';
import '../../widgets/rounded_alert_dialog.dart';
import '../product/export.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({Key? key}) : super(key: key);

  @override
  State<BagScreen> createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double price = 0;

    for (var bagItem in bag.products) {
      price += bagItem.product.price.toDouble() * bagItem.quantity;
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          context: context,
          title: "My Bag",
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).backgroundColor),
              ),
              padding: screenSize.all(8),
              child: const Icon(Icons.arrow_back_ios,
                  color: kUIDarkText, size: 26),
            ),
          ),
          trailing: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/wishlist"),
              child: Padding(
                padding: screenSize.all(18),
                child: const Icon(
                  Icons.favorite_border,
                  color: kUIDarkText,
                  size: 28,
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          padding: screenSize.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      "₹ ",
                      style: TextStyle(
                        color: kUIDarkText,
                        fontSize: screenSize.height(16),
                      ),
                    ),
                    Text(
                      price - price.toInt() == 0
                          ? price.toInt().toString()
                          : price.toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: screenSize.height(34),
                          fontWeight: FontWeight.bold,
                          letterSpacing: -2,
                          color: kUIDarkText),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "(${bag.products.length} items)",
                      style: TextStyle(
                          fontSize: screenSize.height(16),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                disabledColor: kUIDarkText.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: screenSize.symmetric(horizontal: 18, vertical: 12),
                onPressed: bag.hasProducts
                    ? () async {
                        selectedInfo == null
                            ? await showModalBottomSheet(
                                isScrollControlled: true,
                                isDismissible: false,
                                enableDrag: false,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (_) => Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: const InformationSheet(popable: false),
                                ),
                              )
                            : await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (_) => Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: CheckoutSheet(price: price),
                                ),
                              );
                        if (mounted) setState(() {});
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: Theme.of(context).highlightColor),
                    const SizedBox(width: 8),
                    Text(
                      "Checkout",
                      style: TextStyle(
                          fontSize: screenSize.height(16),
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).highlightColor),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            if (bag.changeLog.isNotEmpty)
              GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => WillPopScope(
                      onWillPop: () async {
                        if (mounted) {
                          setState(
                            () => bag.changeLog.clear(),
                          );
                        }
                        return true;
                      },
                      child: RoundedAlertDialog(title: "Alerts", widgets: [
                        SizedBox(
                          height: screenSize.height(280),
                          width: 300,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: bag.changeLog.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Text(
                                    bag.changeLog[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kUIDarkText,
                                        fontSize: screenSize.height(16),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "sans-serif-condensed"),
                                  ),
                                  const Divider(
                                    height: 15,
                                    thickness: 0.8,
                                    color: Colors.black,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ]),
                    ),
                  );
                },
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  margin: screenSize.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.yellow[200]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Alerts for items in your bag",
                        style: TextStyle(
                            color: kUIDarkText,
                            fontSize: screenSize.height(20),
                            fontWeight: FontWeight.w600,
                            fontFamily: "sans-serif-condensed"),
                      ),
                      Text(
                        "Tap to view",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontFamily: "sans-serif-condensed"),
                      )
                    ],
                  ),
                ),
              ),
            Expanded(
              child: bag.products.isNotEmpty
                  ? Padding(
                      padding:
                          screenSize.symmetric(horizontal: 12, vertical: 24),
                      child: AnimatedList(
                        shrinkWrap: true,
                        key: _listKey,
                        initialItemCount: bag.products.length,
                        itemBuilder: (context, index, animation) =>
                            _buildItem(context, index, animation),
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.25,
                        child: EmptyWidget(
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
    final Product product = bag.products[index].product;

    return SizeTransition(
      sizeFactor: animation,
      child: Slidable(
        key: ObjectKey(bag.products[index]),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            Flexible(
              flex: 6,
              child: GestureDetector(
                onTap: () {
                  Timer(const Duration(milliseconds: 200), () {
                    bag.removeProduct(product);
                    if (mounted) setState(() {});
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
                      color: Theme.of(context).primaryColor),
                  child: const Icon(
                    Icons.delete,
                    color: kUILightText,
                    size: 32,
                  ),
                ),
              ),
            )
          ],
        ),
        child: GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(
              context,
              "/product",
              arguments: ProductArguments(bag.products[index].product),
            );
            if (mounted) setState(() {});
          },
          child: Container(
            margin: screenSize.symmetric(vertical: 8),
            height: screenSize.height(125),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).highlightColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: screenSize.symmetric(horizontal: 24, vertical: 18),
                    child: Row(
                      children: [
                        product.images.isNotEmpty
                            ? SizedBox(
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
                                      const Icon(Icons.error),
                                ),
                              )
                            : const Text(
                                "No Image",
                                style: TextStyle(fontSize: 20),
                              ),
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
                                  const SizedBox(width: 12),
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
                if (product.selected!.isNotEmpty)
                  Padding(
                    padding: screenSize.only(
                        right: 12, left: 4, top: 18, bottom: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        product.selected!.length,
                        (index) => CircleAvatar(
                          radius: 12,
                          backgroundColor:
                              product.selected!.values.toList()[index].color ??
                                  Colors.grey[400],
                          child:
                              product.selected!.values.toList()[index].color ==
                                      null
                                  ? Text(
                                      product.selected!.values
                                          .toList()[index]
                                          .label[0]
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
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: kUIDarkText,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          bag.increaseQuantity(product);
                          if (mounted) setState(() {});
                        },
                        child: Padding(
                          padding: screenSize.all(10),
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).backgroundColor,
                            size: 20,
                          ),
                        ),
                      ),
                      Text(
                        bag.getQuantity(product).toString(),
                        style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontSize: screenSize.height(18),
                            fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (bag.getQuantity(product) > 1) {
                            bag.decreaseQuantity(product);
                          }
                          setState(() {});
                        },
                        child: Padding(
                          padding: screenSize.all(10),
                          child: Icon(Icons.remove,
                              color: Theme.of(context).backgroundColor,
                              size: 20),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
