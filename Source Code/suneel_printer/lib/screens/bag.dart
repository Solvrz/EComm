import 'dart:async';

import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:suneel_printer/components/bag.dart';
import 'package:suneel_printer/components/custom_app_bar.dart';
import 'package:suneel_printer/components/home.dart';
import 'package:suneel_printer/components/rounded_alert_dialog.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/bag.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/screens/product.dart';

class BagScreen extends StatefulWidget {
  @override
  _BagScreenState createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double price = 0;

    bag.products.forEach((BagItem bagItem) {
      price += double.parse(bagItem.product.price) * bagItem.quantity;
    });

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/home');
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kUIColor,
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            parent: context,
            title: "My Bag",
            leading: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, '/home'),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kUIColor),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_back_ios, color: kUIDarkText, size: 26),
              ),
            ),
            trailing: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.pushNamed(context, "/wishlist"),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Icon(
                    Icons.favorite_border,
                    color: kUIDarkText,
                    size: 28,
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
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
                          fontSize: getHeight(context, 16),
                        ),
                      ),
                      Text(
                        price - price.toInt() == 0
                            ? price.toInt().toString()
                            : price.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: getHeight(context, 34),
                            fontWeight: FontWeight.bold,
                            letterSpacing: -2,
                            color: kUIDarkText),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "(${bag.products.length} items)",
                        style: TextStyle(
                            fontSize: getHeight(context, 16),
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  color: kUIAccent,
                  disabledColor: kUIDarkText.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.grey[200]),
                      SizedBox(width: 8),
                      Text(
                        "Checkout",
                        style: TextStyle(
                            fontSize: getHeight(context, 16),
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[200]),
                      ),
                    ],
                  ),
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
                                    child: InformationSheet(popable: false),
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
                          setState(() {});
                        }
                      : null,
                )
              ],
            ),
          ),
          body: Column(
            children: [
              if (bag.changeLog.isNotEmpty)
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => WillPopScope(
                        onWillPop: () async {
                          setState(
                            () => bag.changeLog.clear(),
                          );
                          return true;
                        },
                        child: RoundedAlertDialog(title: "Alerts", widgets: [
                          Container(
                            height: getHeight(context, 280),
                            width: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: bag.changeLog.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Text(
                                      bag.changeLog[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: kUIDarkText,
                                          fontSize: getHeight(context, 16),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "sans-serif-condensed"),
                                    ),
                                    Divider(
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
                    margin: EdgeInsets.symmetric(horizontal: 8),
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
                              fontSize: getHeight(context, 20),
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
                            EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                        child: AnimatedList(
                          shrinkWrap: true,
                          key: _listKey,
                          initialItemCount: bag.products.length,
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
        actionPane: SlidableDrawerActionPane(),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            await Navigator.pushNamed(
              context,
              "/product",
              arguments: ProductArguments(bag.products[index].product),
            );
            setState(() {});
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            height: getHeight(context, 140),
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
                            : Text("No Image"),
                        SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(
                                  product.name.replaceAll("", "\u{200B}"),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: kUIDarkText,
                                      fontSize: getHeight(context, 25),
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
                                        fontSize: getHeight(context, 24),
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
                                          fontSize: getHeight(context, 20),
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
                if (product.selected.length > 0)
                  Padding(
                    padding: EdgeInsets.only(
                        right: 12, left: 4, top: 18, bottom: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        product.selected.length,
                        (index) => CircleAvatar(
                          radius: 12,
                          backgroundColor:
                              product.selected.values.toList()[index].color ??
                                  Colors.grey[400],
                          child:
                              product.selected.values.toList()[index].color ==
                                      null
                                  ? Text(
                                      product.selected.values
                                          .toList()[index]
                                          .label[0]
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
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          bag.increaseQuantity(product);
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.add,
                            color: kUIColor,
                            size: 20,
                          ),
                        ),
                      ),
                      Text(
                        bag.getQuantity(product).toString(),
                        style: TextStyle(
                            color: kUIColor,
                            fontSize: getHeight(context, 18),
                            fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          bag.getQuantity(product) > 1
                              ? bag.decreaseQuantity(product)
                              : bag.removeProduct(product);
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.remove, color: kUIColor, size: 20),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        secondaryActions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Timer(Duration(milliseconds: 200), () {
                bag.removeProduct(product);
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
