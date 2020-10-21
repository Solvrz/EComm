import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:suneel_printer/components/rounded_alert_dialog.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/cart.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/screens/product.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //TODO: Use cart.changelog to display a bottomsheet or dialog showing the CHANGE-LOG (not the best word to describe it tbh)
    double price = 0.0;

    cart.products.forEach((CartItem cartItem) {
      price += double.parse(cartItem.product.price) * cartItem.quantity;
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25),),),
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
                        fontSize: 16,
                        fontFamily: "sans-serif-condensed",
                      ),
                    ),
                    Text(
                        price - price.toInt() == 0
                            ? price.toInt().toString()
                            : price.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            fontFamily: "sans-serif-condensed",
                            letterSpacing: -2,
                            color: kUIDarkText),)
                  ],
                ),
              ),
              MaterialButton(
                color:
                    cart.hasProducts ? kUIAccent : kUIDarkText.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),),
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                textColor: kUILightText,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, size: 20),
                    SizedBox(width: 8),
                    Text("Checkout"),
                  ],
                ),
                onPressed: () {
                  if (cart.hasProducts)
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) => Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: CheckOutSheet(price),
                            ),);
                },
              )
            ],
          ),
        ),
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
                      child: Text("My Cart",
                          style: TextStyle(
                              fontSize: 24,
                              color: kUIDarkText,
                              fontWeight: FontWeight.bold),),
                    ),
                  ),
                  GestureDetector(
                    onTap: cart.hasProducts
                        ? () {
                            cart.clear();
                            setState(() {});
                          }
                        : () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        cart.hasProducts ? Icons.delete : null,
                        size: 26,
                        color: kUIDarkText.withOpacity(0.6),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: cart.products.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 24.0),
                      child: AnimatedList(
                        shrinkWrap: true,
                        key: _listKey,
                        initialItemCount: cart.products.length,
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
    final Product product = cart.products[index].product;

    return SizeTransition(
      sizeFactor: animation,
      child: Slidable(
        key: ObjectKey(cart.products[index]),
        actionPane: SlidableDrawerActionPane(),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, "/product",
              arguments: ProductArguments(cart.products[index].product),),
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
                              AutoSizeText(
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
                if (product.selected.length > 0)
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 12, left: 4, top: 18, bottom: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                          product.selected.length,
                          (index) => CircleAvatar(
                                radius: 12,
                                backgroundColor: product.selected.values
                                        .toList()[index]
                                        .color ??
                                    Colors.grey[400],
                                child: product.selected.values
                                            .toList()[index]
                                            .color ==
                                        null
                                    ? Text(
                                        product.selected.values
                                            .toList()[index]
                                            .label[0]
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: kUIDarkText),)
                                    : null,
                              ),),
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (cart.getQuantity(product) > 1) {
                            cart.decreaseQuantity(product);
                          }
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.remove, color: kUIColor, size: 20),
                        ),
                      ),
                      Text(cart.getQuantity(product).toString(),
                          style: TextStyle(
                              color: kUIColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),),
                      GestureDetector(
                        onTap: () async {
                          cart.increaseQuantity(product);
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.add,
                            color: kUIColor,
                            size: 20,
                          ),
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
            onTap: () {
              Timer(Duration(milliseconds: 200), () {
                cart.removeItem(product);
                setState(() {});
              });
              _listKey.currentState.removeItem(index,
                  (context, animation) => _buildItem(context, index, animation),
                  duration: Duration(milliseconds: 200),);
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

class CheckOutSheet extends StatefulWidget {
  final double price;

  CheckOutSheet(this.price);

  @override
  _CheckOutSheetState createState() => _CheckOutSheetState();
}

class _CheckOutSheetState extends State<CheckOutSheet> {
  String name = "";
  String phone = "";
  String address = "";

  Map<String, bool> error = {"name": false, "phone": false, "address": false};

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
        padding: EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.close, color: kUIDarkText),
                  ),
                ),
                Text("Check Out",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  TextField(
                    decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: name.trim() == "" ? "Your name" : null),
                    controller: TextEditingController(text: name),
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500),
                    onChanged: (String value) {
                      name = value;
                    },
                  ),
                  if (error["name"]) ...[
                    Text("Please provide a valid name",
                        style:
                            TextStyle(fontSize: 15, color: Colors.redAccent),),
                    SizedBox(height: 8)
                  ],
                  Divider(
                    height: 8,
                    thickness: 2,
                  ),
                  SizedBox(height: 12),
                  Text("Phone Number",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  TextField(
                    scrollPadding: EdgeInsets.zero,
                    decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText:
                            phone.trim() == "" ? "Your phone number" : null),
                    controller: TextEditingController(text: phone),
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500),
                    onChanged: (String value) {
                      phone = value;
                    },
                  ),
                  if (error["phone"]) ...[
                    Text("Please provide a valid phone number",
                        style:
                            TextStyle(fontSize: 15, color: Colors.redAccent),),
                    SizedBox(height: 8)
                  ],
                  Divider(
                    height: 8,
                    thickness: 2,
                  ),
                  SizedBox(height: 12),
                  Text("Shipping Address",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  TextField(
                    maxLines: 4,
                    minLines: 1,
                    decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: address.trim() == "" ? "Your address" : null),
                    controller: TextEditingController(text: address),
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500),
                    onChanged: (String value) {
                      address = value;
                    },
                  ),
                  if (error["address"]) ...[
                    Text("Please provide a valid address",
                        style:
                            TextStyle(fontSize: 15, color: Colors.redAccent),),
                    SizedBox(height: 8)
                  ],
                  Divider(
                    height: 8,
                    thickness: 2,
                  ),
                  SizedBox(height: 12),
                  Text("${cart.products.length} Items",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Total:",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.bold,
                            ),),
                      ),
                      Text("₹ ",
                          style: TextStyle(
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.bold,
                          ),),
                      Text(
                          widget.price - widget.price.toInt() == 0
                              ? widget.price.toInt().toString()
                              : widget.price.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.bold,
                          ),),
                    ],
                  ),
                  SizedBox(height: 32),
                  Center(
                    child: MaterialButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (name.trim() == "")
                          error["name"] = true;
                        else
                          error["name"] = false;
                        if (!(phone.trim().length == 10) &&
                            !(phone.trim().length > 10 &&
                                phone.startsWith("+")))
                          error["phone"] = true;
                        else
                          error["phone"] = false;
                        if (address.trim() == "")
                          error["address"] = true;
                        else
                          error["address"] = false;

                        if (!error.values.contains(true)) {
                          await showDialog(
                              context: context,
                              builder: (_) => RoundedAlertDialog(
                                    title: "Your Order was placed!",
                                    buttonsList: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Okay"),)
                                    ],
                                  ),);

                          await http.post(
                            "https://suneel-printers-mail-server.herokuapp.com/order_request",
                            headers: <String, String>{
                              "Content-Type": "application/json; charset=UTF-8",
                            },
                            body: jsonEncode(<String, String>{
                              "customer": "yugthapar37@gmail.com",
                              "name": name,
                              "phone": phone,
                              "address": address,
                              "price": widget.price.toString(),
                              "product_list": cart.products
                                  .map<String>((CartItem cartItem) {
                                    Product product = cartItem.product;

                                    return '''
                <tr>
                    <td>${product.name}</td>
                    <td class="righty">${cartItem.quantity}</td>
                    <td class="righty">${(double.parse(product.price) * cartItem.quantity).toStringAsFixed(2)}</td>
                </tr>
                ''';
                                  })
                                  .toList()
                                  .join("\n"),
                            }),
                          );

                          //TODO: Save orders in SharedPreferences
                          cart.clear();
                          Navigator.popUntil(
                              context, ModalRoute.withName("/home"),);

                          //TODO: Implement Proceed To Buy Firebase
                        }
                        setState(() {});
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),),
                      color: kUIAccent,
                      child: Text("Proceed To Buy",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "sans-serif-condensed",
                              fontWeight: FontWeight.w600,
                              color: kUILightText),),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
