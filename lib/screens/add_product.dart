import 'package:flutter/material.dart';
import 'package:suneel_printer/components/product_components.dart';
import 'package:suneel_printer/constant.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<OptionRadioTile> variations = [];
  String name = "";
  String price = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(top: 12),
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: kUIColor)),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(left: 16),
                      child: Icon(Icons.arrow_back_ios, color: kUIDarkText),
                    ),
                  ),
                  SizedBox(width: 24),
                  Text("Preview",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: "sans-serif-condensed"))
                ],
              ),
            ),
            Divider(thickness: 2, height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 44, bottom: 36),
                    child: TextField(
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Product Name",
                            hintStyle: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                fontFamily: "sans-serif-condensed")),
                        onChanged: (value) => name = value,
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            fontFamily: "sans-serif-condensed")),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.grey[400]),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.325,
//                          child: Image(
//                            image: args.product.imgs[0],
//                            fit: BoxFit.fill,
//                          ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
                    ],
                  ),
                ],
              ),
            ),
            Divider(thickness: 2, height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(children: [
                    ...variations,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("Price",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "sans-serif-condensed",
                                    letterSpacing: 0.2)),
                          ),
                          Container(
                            width: 80,
                            child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixText: "₹ ",
                                    hintText: "Price",
                                    hintStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "sans-serif-condensed",
                                        letterSpacing: -0.4)),
                                cursorColor: Colors.grey,
                                onChanged: (value) => price = value,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "sans-serif-condensed",
                                    letterSpacing: -0.4)),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
