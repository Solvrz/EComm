import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';

import './widgets/checkout_sheet.dart';
import '/config/constant.dart';
import '/models/product.dart';
import '/tools/extensions.dart';
import '/ui/pages/product/export.dart';
import '/ui/widgets/custom_app_bar.dart';
import '/ui/widgets/information_sheet.dart';
import '/ui/widgets/marquee.dart';
import '/ui/widgets/rounded_alert_dialog.dart';

class BagPage extends StatefulWidget {
  const BagPage({super.key});

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double price = 0;

    for (final bagItem in BAG.products) {
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
            child: Padding(
              padding: screenSize.all(10),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
            ),
          ),
          trailing: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/wishlist"),
              child: Padding(
                padding: screenSize.all(18),
                child: Icon(
                  Icons.favorite_border,
                  color: theme.colorScheme.onPrimary,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: screenSize.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: theme.highlightColor,
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
                      "$CURRENCY ",
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
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
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "(${BAG.products.length} items)",
                      style: TextStyle(
                        fontSize: screenSize.height(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                color: theme.primaryColor,
                disabledColor: theme.colorScheme.onPrimary.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: screenSize.symmetric(horizontal: 18, vertical: 12),
                onPressed: BAG.hasProducts
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
                        if (context.mounted) setState(() {});
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: theme.highlightColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Checkout",
                      style: TextStyle(
                        fontSize: screenSize.height(16),
                        fontWeight: FontWeight.w600,
                        color: theme.highlightColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            if (BAG.changeLog.isNotEmpty)
              GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => PopScope(
                      onPopInvoked: (_) async {
                        if (context.mounted) {
                          setState(
                            () => BAG.changeLog.clear(),
                          );
                        }
                      },
                      child: RoundedAlertDialog(
                        title: "Alerts",
                        widgets: [
                          SizedBox(
                            height: screenSize.height(280),
                            width: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: BAG.changeLog.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Text(
                                      BAG.changeLog[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimary,
                                        fontSize: screenSize.height(16),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "sans-serif-condensed",
                                      ),
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
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  margin: screenSize.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.yellow[200],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Alerts for items in your bag",
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: screenSize.height(20),
                          fontWeight: FontWeight.w600,
                          fontFamily: "sans-serif-condensed",
                        ),
                      ),
                      Text(
                        "Tap to view",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontFamily: "sans-serif-condensed",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: BAG.products.isNotEmpty
                  ? Padding(
                      padding:
                          screenSize.symmetric(horizontal: 12, vertical: 24),
                      child: AnimatedList(
                        shrinkWrap: true,
                        key: _listKey,
                        initialItemCount: BAG.products.length,
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
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final Product product = BAG.products[index].product;

    return SizeTransition(
      sizeFactor: animation,
      child: Slidable(
        key: ObjectKey(BAG.products[index]),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            Flexible(
              flex: 6,
              child: GestureDetector(
                onTap: () {
                  Timer(const Duration(milliseconds: 200), () {
                    BAG.removeProduct(product);
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
          onTap: () async {
            await Navigator.pushNamed(
              context,
              "/product",
              arguments: ProductArguments(BAG.products[index].product),
            );
            if (context.mounted) setState(() {});
          },
          child: Container(
            margin: screenSize.symmetric(vertical: 8),
            height: screenSize.height(125),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
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
                          const Text(
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
                if (product.selected!.isNotEmpty)
                  Padding(
                    padding: screenSize.only(
                      right: 12,
                      left: 4,
                      top: 18,
                      bottom: 18,
                    ),
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
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    )
                                  : null,
                        ),
                      ),
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          BAG.increaseQuantity(product);
                          if (context.mounted) setState(() {});
                        },
                        child: Padding(
                          padding: screenSize.all(10),
                          child: Icon(
                            Icons.add,
                            color: theme.colorScheme.background,
                            size: 20,
                          ),
                        ),
                      ),
                      Text(
                        BAG.getQuantity(product).toString(),
                        style: TextStyle(
                          color: theme.colorScheme.background,
                          fontSize: screenSize.height(18),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (BAG.getQuantity(product) > 1) {
                            BAG.decreaseQuantity(product);
                            setState(() {});
                          } else {
                            Timer(const Duration(milliseconds: 200), () {
                              BAG.removeProduct(product);
                              if (context.mounted) setState(() {});
                            });

                            _listKey.currentState!.removeItem(
                              index,
                              (context, animation) =>
                                  _buildItem(context, index, animation),
                              duration: const Duration(milliseconds: 200),
                            );
                          }
                        },
                        child: Padding(
                          padding: screenSize.all(10),
                          child: Icon(
                            Icons.remove,
                            color: theme.colorScheme.background,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
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
