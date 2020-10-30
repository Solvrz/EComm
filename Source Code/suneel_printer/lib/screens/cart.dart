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
                          color: kUIDarkText),
                    )
                  ],
                ),
              ),
              MaterialButton(
                color:
                    cart.hasProducts ? kUIAccent : kUIDarkText.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
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
                        child: CheckoutSheet(price),
                      ),
                    );
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
                      child: Text(
                        "My Cart",
                        style: TextStyle(
                            fontSize: 24,
                            color: kUIDarkText,
                            fontWeight: FontWeight.bold),
                      ),
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
            if (cart.changeLog.isNotEmpty)
              GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => WillPopScope(
                      onWillPop: () async {
                        setState(() => cart.changeLog.clear());
                        return true;
                      },
                      child: RoundedAlertDialog(title: "Alerts", otherWidgets: [
                        Container(
                          height: 220,
                          width: 300,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cart.changeLog.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Text(
                                    cart.changeLog[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
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
                        "Alerts for items in your cart",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: "sans-serif-condensed"),
                      ),
                      Text("Tap to view",
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontFamily: "sans-serif-condensed"))
                    ],
                  ),
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
          onTap: () => Navigator.pushNamed(
            context,
            "/product",
            arguments: ProductArguments(cart.products[index].product),
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
                                          fontSize: 13,
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
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                      Text(
                        cart.getQuantity(product).toString(),
                        style: TextStyle(
                            color: kUIColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
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

//ignore: must_be_immutable
class CheckoutSheet extends StatefulWidget {
  final double price;

  CheckoutSheet(this.price);

  @override
  _CheckoutSheetState createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  Map<String, InformationTextField> fields = {
    "name": InformationTextField(
        title: "Name",
        placeholder: "Your Name",
        errorMessage: "Please enter a valid name"),
    "phone": InformationTextField(
      title: "Phone Number",
      placeholder: "Your Phone Number",
      errorMessage: "Please enter a valid phone number",
      inputType: TextInputType.phone,
    ),
    "email": InformationTextField(
        title: "Email Address",
        placeholder: "Your Email Address",
        errorMessage: "Please enter a valid email address"),
    "address": InformationTextField(
        title: "Shipping Address",
        placeholder: "Your Address",
        errorMessage: "Please enter a valid address"),
    "pincode": InformationTextField(
      title: "Pincode",
      placeholder: "Your Pincode",
      errorMessage: "Please enter a valid pincode",
      inputType: TextInputType.number,
    )
  };

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
                Text(
                  "Check Out",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...fields.values.toList(),
                  Text(
                    "${cart.products.length} Items",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Total:",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "₹ ",
                        style: TextStyle(
                          fontFamily: "sans-serif-condensed",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.price - widget.price.toInt() == 0
                            ? widget.price.toInt().toString()
                            : widget.price.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: "sans-serif-condensed",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Center(
                    child: MaterialButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      onPressed: () async {
                        String name = fields["name"].value;
                        String phone = fields["phone"].value;
                        String address = fields["address"].value;
                        String email = fields["email"].value;
                        String pincode = fields["pincode"].value;

                        FocusScope.of(context).unfocus();

                        // TODO FIXME Need to hot refresh to see error on fields

                        if (name.trim() == "")
                          fields["name"].error = true;
                        else
                          fields["name"].error = false;

                        if (!(phone.trim().length == 10) &&
                            !(phone.trim().length > 10 &&
                                phone.startsWith("+")))
                          fields["phone"].error = true;
                        else
                          fields["phone"].error = false;

                        if (address.trim() == "")
                          fields["address"].error = true;
                        else
                          fields["address"].error = false;

                        if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                            .hasMatch(email))
                          fields["email"].error = true;
                        else
                          fields["email"].error = false;

                        http.Response result = await http.get(
                            "https://api.postalpincode.in/pincode/$pincode");

                        if (jsonDecode(result.body)[0]["Status"] == "Error")
                          fields["pincode"].error = true;
                        else
                          fields["pincode"].error = false;

                        setState(() {});

                        if (!fields.values
                            .toList()
                            .map((e) => e.error)
                            .contains(true)) {
                          Timer(Duration(milliseconds: 500), () {
                            showDialog(
                              context: context,
                              builder: (_) => RoundedAlertDialog(
                                title: "Your Order was placed!",
                                buttonsList: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);

                                      //FIXME: UNCOMMENTING THIS GIVES THE LEGENDARY 'WHITE SCREEN OF DEATH'
//                                      Navigator.popUntil(context,
//                                          ModalRoute.withName("/home"));
                                    },
                                    child: Text("Okay"),
                                  )
                                ],
                              ),
                            );
                          });

                          payment.startPayment();

                          await http.post(
                            "https://suneel-printers.herokuapp.com/order_request",
                            headers: <String, String>{
                              "Content-Type": "application/json; charset=UTF-8",
                            },
                            body: jsonEncode(<String, String>{
                              "name": name,
                              "phone": phone,
                              "address": address,
                              "email": email,
                              "payment_mode": "COD",
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

                          List<String> pastOrders =
                              preferences.getStringList("orders") ?? [];

                          pastOrders.add(jsonEncode(
                              cart.products.map((e) => e.toString()).toList()));

                          preferences.setStringList("orders", pastOrders);

                          database.collection("orders").add({
                            "name": name,
                            "phone": phone,
                            "address": address,
                            "products": cart.products.map((e) {
                              return {
                                "product": e.product.toJson(),
                                "quantity": e.quantity
                              };
                            }).toList()
                          });

                          cart.clear();
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: kUIAccent,
                      child: Text(
                        "Proceed To Buy",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "sans-serif-condensed",
                            fontWeight: FontWeight.w600,
                            color: kUILightText),
                      ),
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

// ignore: must_be_immutable
class InformationTextField extends StatefulWidget {
  String title;
  String placeholder;
  String errorMessage;
  TextInputType inputType;

  InformationTextField(
      {this.title,
      this.placeholder,
      this.errorMessage,
      this.inputType = TextInputType.name});

  bool error = false;
  TextEditingController controller = TextEditingController();

  String get value => controller.text;

  @override
  _InformationTextFieldState createState() => _InformationTextFieldState();
}

class _InformationTextFieldState extends State<InformationTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      TextField(
        decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: widget.placeholder),
        controller: widget.controller,
        keyboardType: widget.inputType,
        style: TextStyle(
            fontSize: 17, color: Colors.grey[600], fontWeight: FontWeight.w500),
      ),
      if (widget.error) ...[
        Text(
          widget.errorMessage,
          style: TextStyle(fontSize: 15, color: Colors.redAccent),
        ),
        SizedBox(height: 8),
      ],
      Divider(
        height: 8,
        thickness: 2,
      ),
      SizedBox(height: 12),
    ]);
  }
}
