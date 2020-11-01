import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/components/product.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Product product;
  List<OptionRadioTile> variations;
  int _currentImage = 0;

  @override
  Widget build(BuildContext context) {
    ProductArguments args = ModalRoute.of(context).settings.arguments;

    if (product == null) {
      product = Product.fromJson(args.product.toJson());
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
        resizeToAvoidBottomInset: true,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                        child: Icon(Icons.arrow_back_ios,
                            color: kUIDarkText, size: 26),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(context, "/bag");
                        setState(() {});
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kUIColor),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Image.asset("assets/images/ShoppingBag.png",
                              width: 30, height: 30)),
                    )
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
                        product.name,
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            fontFamily: "sans-serif-condensed"),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                              child: CarouselSlider(
                                items: product.images
                                    .map<Widget>((NetworkImage image) =>
                                        Image(image: image))
                                    .toList(),
                                options: CarouselOptions(
                                    autoPlay: product.images.length > 1,
                                    enlargeCenterPage: true,
                                    aspectRatio: 2.0,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _currentImage = index;
                                      });
                                    }),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                product.images.length,
                                (int index) => AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  width: _currentImage == index ? 16.0 : 8.0,
                                  height: _currentImage == index ? 6.0 : 8.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 3.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: _currentImage == index
                                        ? Color.fromRGBO(0, 0, 0, 0.9)
                                        : Color.fromRGBO(0, 0, 0, 0.4),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              Divider(thickness: 2, height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: variations,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
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
                      "₹ ${product.price}",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: "sans-serif-condensed",
                          letterSpacing: -0.4),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: Row(
                  children: [
                    if (bag.containsProduct(product))
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kUIDarkText)),
                        child: IntrinsicWidth(
                          child: Column(
                            children: [
                              Icon(Icons.remove, size: 30),
                              Text(bag.getQuantity(product).toString(),
                                  style: TextStyle(
                                      fontSize: 22, color: kUIDarkText)),
                              Icon(Icons.add, size: 30),
                            ],
                          ),
                        ),
                        margin: EdgeInsets.only(right: 16),
                      ),
                    Expanded(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: bag.containsProduct(product)
                            ? Colors.grey[600]
                            : kUIAccent,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          bag.containsProduct(product)
                              ? "IN BAG"
                              : "ADD TO BAG",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (!bag.containsProduct(product)) {
                            bag.addItem(product);
                          } else {
                            Navigator.pushNamed(context, "/bag");
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductArguments {
  final Product product;

  ProductArguments(this.product);
}
