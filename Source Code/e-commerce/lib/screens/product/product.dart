import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import './image_viewer.dart';
import './widgets/variation_button.dart';
import '../../config/constant.dart';
import '../../models/product.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/marquee.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _currentImage = 0;

  @override
  Widget build(BuildContext context) {
    ProductArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductArguments;

    Product product = Product.fromJson(
      args.product.toJson(),
    );

    List<VariationButton> variations = List.generate(
      args.product.variations.length,
      (index) => VariationButton(
        onChanged: (option) {
          product.select(args.product.variations[index].name, option);
          if (mounted) setState(() {});
        },
        variation: args.product.variations[index],
        currIndex: args.product.variations[index].options
            .indexOf(product.selected![args.product.variations[index].name]),
      ),
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          context: context,
          title: "",
          trailing: [
            GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, "/bag");
                if (mounted) setState(() {});
              },
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
                        style: const TextStyle(color: kUIDarkText),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SizedBox(
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
                        style: const TextStyle(
                            color: kUIDarkText,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            fontFamily: "sans-serif-condensed"),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: screenSize.fromLTRB(8, 16, 8, 8),
                              child: product.images.isNotEmpty
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
                                                    builder: (context) =>
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
                                                      .colorScheme
                                                      .secondary,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                      color: Colors.grey),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
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
                                            if (mounted) {
                                              setState(() {
                                                _currentImage = index;
                                              });
                                            }
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
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  width: _currentImage == index ? 16 : 8,
                                  height: _currentImage == index ? 6 : 8,
                                  margin: screenSize.symmetric(
                                      vertical: 10, horizontal: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: _currentImage == index
                                        ? const Color.fromRGBO(0, 0, 0, 0.9)
                                        : const Color.fromRGBO(0, 0, 0, 0.4),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              const Divider(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: screenSize.symmetric(horizontal: 16, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...variations,
                        if (variations.isNotEmpty) const Divider(height: 2),
                        Padding(
                          padding: screenSize.symmetric(
                              vertical: variations.isNotEmpty ? 15 : 0,
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
                              const SizedBox(width: 12),
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
                    const VerticalDivider(),
                    Expanded(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: bag.containsProduct(product)
                            ? Colors.grey[600]
                            : Theme.of(context).primaryColor.withOpacity(0.9),
                        padding: screenSize.symmetric(vertical: 16),
                        child: Text(
                          bag.containsProduct(product)
                              ? "IN BAG"
                              : "ADD TO BAG",
                          style: TextStyle(
                              fontSize: screenSize.height(20),
                              color: Theme.of(context).backgroundColor,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (!bag.containsProduct(product)) {
                            bag.addProduct(product);

                            await showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) =>
                                  AddProductSheet(product: product),
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
