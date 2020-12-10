import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer/components/custom_app_bar.dart';
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
    ProductArguments args = ModalRoute
        .of(context)
        .settings
        .arguments;

    if (product == null) {
      product = Product.fromJson(
        args.product.toJson(),
      );
      variations = List.generate(
        args.product.variations.length,
            (index) =>
            OptionRadioTile(
              onChanged: (option) {
                product.select(args.product.variations[index].name, option);
                if (mounted) setState(() {});
              },
              variation: args.product.variations[index],
              currIndex: args.product.variations[index].options
                  .indexOf(
                  product.selected[args.product.variations[index].name]),
            ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          parent: context,
          title: "",
        ),
        body: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                          color: kUIDarkText,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          fontFamily: "sans-serif-condensed"),
                    ),
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.3,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                              child: product.images.length > 0
                                  ? CarouselSlider(
                                items: product.images
                                    .map<Widget>(
                                      (NetworkImage image) =>
                                      Image(image: image),
                                )
                                    .toList(),
                                options: CarouselOptions(
                                    autoPlay: product.images.length > 1,
                                    enlargeCenterPage: true,
                                    aspectRatio: getAspect(context, 2.5),
                                    onPageChanged: (index, reason) {
                                      if (mounted)
                                        setState(() {
                                          _currentImage = index;
                                        });
                                    }),
                              )
                                  : Center(
                                child: Text(
                                  "No Images Available",
                                  style: TextStyle(
                                      fontSize: getHeight(context, 20),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                product.images.length,
                                    (int index) =>
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 400),
                                      width: _currentImage == index ? 16 : 8,
                                      height: _currentImage == index ? 6 : 8,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 3),
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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...variations,
                        if (variations.isNotEmpty)
                          Divider(thickness: 2, height: 2),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: variations.length > 0 ? 15 : 0,
                              horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Price",
                                  style: TextStyle(
                                      color: kUIDarkText,
                                      fontSize: getHeight(context, 22),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2),
                                ),
                              ),
                              Text(
                                "₹ ${product.price}",
                                style: TextStyle(
                                    color: kUIDarkText,
                                    fontSize: getHeight(context, 22),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.4),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "MRP",
                                  style: TextStyle(
                                      color: kUIDarkText,
                                      fontSize: getHeight(context, 22),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2),
                                ),
                              ),
                              Text(
                                "₹ ${product.mrp}",
                                style: TextStyle(
                                    color: kUIDarkText,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: getHeight(context, 22),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.4),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Save: ₹ ${double.parse(product.mrp) -
                                    double.parse(product.price)}",
                                style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: getHeight(context, 22),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.4),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        wishlist.containsProduct(product)
                            ? wishlist.removeProduct(product)
                            : wishlist.addProduct(product);

                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: wishlist.containsProduct(product)
                              ? kUIAccent.withOpacity(0.9)
                              : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_outline,
                          color: wishlist.containsProduct(product)
                              ? kUILightText.withOpacity(0.8)
                              : kUIDarkText.withOpacity(0.3),
                          size: 28,
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: bag.containsProduct(product)
                            ? Colors.grey[600]
                            : kUIAccent.withOpacity(0.9),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Container(
                          child: Text(
                            bag.containsProduct(product)
                                ? "IN BAG"
                                : "ADD TO BAG",
                            style: TextStyle(
                                fontSize: getHeight(context, 20),
                                color: kUIColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () async {
                          if (!bag.containsProduct(product)) {
                            bag.addProduct(product);
                            await showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) =>
                                  AddProductSheet(product),
                            );
                          } else {
                            await Navigator.pushNamed(context, "/bag");
                          }

                          if (mounted) setState(() {});
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
