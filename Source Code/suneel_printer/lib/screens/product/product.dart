import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suneel_printer/config/constant.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/widgets/custom_app_bar.dart';
import 'package:suneel_printer/widgets/marquee.dart';

import './image_viewer.dart';
import './widgets/variation_button.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Product product;
  List<VariationButton> variations;
  int _currentImage = 0;

  @override
  Widget build(BuildContext context) {
    ProductArguments args = ModalRoute.of(context).settings.arguments;

    if (product == null) {
      product = Product.fromJson(
        args.product.toJson(),
      );
      variations = List.generate(
        args.product.variations.length,
        (index) => VariationButton(
          onChanged: (option) {
            product.select(args.product.variations[index].name, option);
            if (mounted) setState(() {});
          },
          variation: args.product.variations[index],
          currIndex: args.product.variations[index].options
              .indexOf(product.selected[args.product.variations[index].name]),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          parent: context,
          title: "",
          trailing: [
            GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, "/bag");
                if (mounted) setState(() {});
              },
              child: Container(
                child: Padding(
                  padding: screenSize.all(18),
                  child: Stack(
                    children: [
                      Image.asset("assets/images/ShoppingBag.png",
                          width: 30, height: 30),
                      Positioned(
                        left: 11,
                        top: 10,
                        child: Text(
                          bag.products.length.toString(),
                          style: TextStyle(color: kUIDarkText),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: screenSize.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Marquee(
                      child: Text(
                        product.name,
                        style: TextStyle(
                            color: kUIDarkText,
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
                              padding: screenSize.fromLTRB(8, 16, 8, 8),
                              child: product.images.length > 0
                                  ? CarouselSlider(
                                      items: product.images
                                          .map<Widget>(
                                            (dynamic image) => GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ImageScreen(
                                                      title: product.name,
                                                      images: product.images,
                                                      currentIndex: 0,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: CachedNetworkImage(
                                                imageUrl: image.toString(),
                                                placeholder: (context, url) =>
                                                    Shimmer.fromColors(
                                                  baseColor: Theme.of(context)
                                                      .accentColor,
                                                  highlightColor:
                                                      Colors.grey[100],
                                                  child: Container(
                                                      color: Colors.grey),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      options: CarouselOptions(
                                          autoPlay: product.images.length > 1,
                                          enlargeCenterPage: true,
                                          aspectRatio:
                                              screenSize.aspectRatio(2.5),
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
                                            fontSize: screenSize.height(20),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                product.images.length,
                                (int index) => AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  width: _currentImage == index ? 16 : 8,
                                  height: _currentImage == index ? 6 : 8,
                                  margin: screenSize.symmetric(
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
              Divider(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: screenSize.symmetric(horizontal: 16, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...variations,
                        if (variations.isNotEmpty) Divider(height: 2),
                        Padding(
                          padding: screenSize.symmetric(
                              vertical: variations.length > 0 ? 15 : 0,
                              horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Price",
                                  style: TextStyle(
                                      color: kUIDarkText,
                                      fontSize: screenSize.height(22),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2),
                                ),
                              ),
                              Text(
                                "₹ ${product.price}",
                                style: TextStyle(
                                    color: kUIDarkText,
                                    fontSize: screenSize.height(22),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.4),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: screenSize.symmetric(
                              vertical: 15, horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "MRP",
                                  style: TextStyle(
                                      color: kUIDarkText,
                                      fontSize: screenSize.height(22),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2),
                                ),
                              ),
                              Text(
                                "₹ ${product.mrp}",
                                style: TextStyle(
                                    color: kUIDarkText,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: screenSize.height(22),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.4),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Save: ₹ ${product.mrp.toDouble() - product.price.toDouble()}",
                                style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: screenSize.height(22),
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
                padding: screenSize.symmetric(vertical: 18, horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        wishlist.containsProduct(product)
                            ? wishlist.removeProduct(product)
                            : wishlist.addProduct(product);

                        setState(() {});
                      },
                      child: Container(
                        padding: screenSize.all(12),
                        decoration: BoxDecoration(
                          color: wishlist.containsProduct(product)
                              ? Theme.of(context).primaryColor.withOpacity(0.9)
                              : Theme.of(context).highlightColor,
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
                            : Theme.of(context).primaryColor.withOpacity(0.9),
                        padding: screenSize.symmetric(vertical: 16),
                        child: Container(
                          child: Text(
                            bag.containsProduct(product)
                                ? "IN BAG"
                                : "ADD TO BAG",
                            style: TextStyle(
                                fontSize: screenSize.height(20),
                                color: Theme.of(context).backgroundColor,
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
