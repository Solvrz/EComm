import 'package:flutter/material.dart';
import 'package:suneel_printer/components/product_components.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Product product;
  List<OptionRadioTile> variations;

  @override
  Widget build(BuildContext context) {
    ProductArguments args = ModalRoute.of(context).settings.arguments;

    if (product == null) {
      product = args.product;
      variations = List.generate(
        args.product.variations.length,
        (index) => OptionRadioTile(
          onChanged: (option) {
            product.select(args.product.variations[index].name, option);
            setState(() {});
          },
          variation: args.product.variations[index],
          currIndex: args.product.variations[index].options
              .indexOf(product.selected[args.product.variations[index].name]),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kUIColor),
                      ),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(left: 16, top: 16),
                      child: Icon(Icons.arrow_back_ios, color: kUIDarkText),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/cart"),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kUIColor),
                      ),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(right: 26, top: 16),
                      child: Icon(Icons.shopping_cart_outlined,
                          color: kUIDarkText),
                    ),
                  ),
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
                    child: Text(
                      args.product.name,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          fontFamily: "sans-serif-condensed"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.grey[400]),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.325,
                        child: args.product.images != null
                            ? Image(
                                image: args.product.images[0],
                                fit: BoxFit.fill,
                              )
                            : Center(
                                child: Text("No Images Provided"),
                              ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        if (wishlist.containsProduct(args.product)) {
                          wishlist.removeItem(args.product);
                        } else {
                          wishlist.addItem(args.product);
                        }
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                            wishlist.containsProduct(args.product)
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: wishlist.containsProduct(args.product)
                                ? kUIAccent
                                : kUIDarkText,
                            size: 28),
                      ),
                    ),
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
                            child: Text(
                              "Price",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "sans-serif-condensed",
                                  letterSpacing: 0.2),
                            ),
                          ),
                          Text(
                            "₹ ${args.product.price}",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: "sans-serif-condensed",
                                letterSpacing: -0.4),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: cart.containsProduct(product)
                    ? Colors.grey[600]
                    : kUIAccent,
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  cart.containsProduct(product) ? "IN CART" : "ADD TO CART",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (!cart.containsProduct(product)) {
                    cart.addItem(product);
                  } else {
                    cart.removeItem(product);
                  }
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductArguments {
  final Product product;

  ProductArguments(this.product);
}
