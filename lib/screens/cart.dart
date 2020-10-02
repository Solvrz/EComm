import 'package:flutter/material.dart';
import 'package:suneel_printer/components/rounded_alert_dialog.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/product.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> products = [
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
    {
      "name": "Parker",
      "img":
          "https://images-na.ssl-images-amazon.com/images/I/51OCvyegJcL._SX466_.jpg",
      "price": "99"
    },
  ];

  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController adderess = TextEditingController();

  int price = 0;

  @override
  Widget build(BuildContext context) {
    products.forEach((element) {
      price += int.parse(element["price"].toString());
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Cart",
            style: TextStyle(color: kUILightText),
          ),
        ),
        body: products.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Scrollbar(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: products.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, "/product",
                                    arguments: ProductArguments(
                                        products[index]["name"],
                                        products[index]["img"],
                                        products[index]["price"])),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18.0)),
                                        child: Image.network(
                                            products[index]["img"]),
                                      ),
                                      trailing: Text(
                                        "₹ ${products[index]["price"]}",
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 15),
                                      ),
                                      title: Text(products[index]["name"])),
                                ),
                              );
                            }),
                      ),
                    ),
                    Divider(height: 20, thickness: 1),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Subtotal : ",
                              style: TextStyle(
                                  fontSize: 28,
                                  // color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            " ₹ $price",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22),
                    Container(
                      height: 60,
                      width: 300,
                      child: Builder(
                        builder: (BuildContext context) => FlatButton(
                            onPressed: () => showBottomSheet(
                                context: context,
                                builder: (_) => WillPopScope(
                                      onWillPop: () async {
                                        Navigator.pop(context);
                                        return true;
                                      },
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height -
                                                300,
                                        margin: EdgeInsets.only(top: 50),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[600],
                                                blurRadius: 12,
                                                offset: Offset(0, -2))
                                          ],
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(25),
                                            topLeft: Radius.circular(25),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: TextField(
                                                    controller: name,
                                                    maxLines: 3,
                                                    minLines: 1,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    decoration: InputDecoration(
                                                      hintText: "Name *",
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: TextField(
                                                    controller: phone,
                                                    maxLines: 3,
                                                    minLines: 1,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    decoration: InputDecoration(
                                                      hintText: "Phone *",
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: TextField(
                                                    controller: adderess,
                                                    maxLines: 3,
                                                    minLines: 1,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    decoration: InputDecoration(
                                                      hintText: "Adderess *",
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 100),
                                                Container(
                                                  height: 60,
                                                  width: 300,
                                                  child: FlatButton(
                                                      color: kUIAccent,
                                                      textColor: kUILightText,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(Icons.store),
                                                          SizedBox(width: 8),
                                                          Text("Place Order"),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        print(name.text != "");
                                                        if (name.text != "" ||
                                                            phone.text != "" ||
                                                            adderess.text !=
                                                                "") {
                                                          name.clear();
                                                          phone.clear();
                                                          adderess.clear();

                                                          Navigator.pop(
                                                              context);

                                                          showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                RoundedAlertDialog(
                                                              title:
                                                                  "You'r Order has been placed.",
                                                              buttonsList: [
                                                                FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    "Ok",
                                                                    style: TextStyle(
                                                                        color:
                                                                            kUIAccent,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        } else {
                                                          name.clear();
                                                          phone.clear();
                                                          adderess.clear();

                                                          Navigator.pop(
                                                              context);
                                                          FocusScope.of(context)
                                                              .unfocus();

                                                          Scaffold.of(context)
                                                              .removeCurrentSnackBar();
                                                          Scaffold.of(context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "Details can't be empty",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              backgroundColor:
                                                                  kUIAccent,
                                                            ),
                                                          );
                                                        }
                                                      }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                            color: kUIAccent,
                            textColor: kUILightText,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.store),
                                SizedBox(width: 8),
                                Text("Place Order"),
                              ],
                            )),
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: Text("The cart is empty \nAdd products",
                    textAlign: TextAlign.center),
              ),
      ),
    );
  }
}
