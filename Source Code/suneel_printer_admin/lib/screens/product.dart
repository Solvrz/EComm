import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:suneel_printer_admin/components/custom_app_bar.dart';
import 'package:suneel_printer_admin/components/product.dart';
import 'package:suneel_printer_admin/constant.dart';
import 'package:suneel_printer_admin/models/product.dart';

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
      product = Product.fromJson(
        args.product.toJson(),
      );
      variations = List.generate(
        args.product.variations.length,
        (index) => OptionRadioTile(
          onChanged: (_) {},
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
        appBar: CustomAppBar(
          parent: context,
          title: "",
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: kUIDarkText,
                                fontSize: getHeight(context, 28),
                                fontWeight: FontWeight.w600,
                                fontFamily: "sans-serif-condensed"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
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
                                          aspectRatio: getAspect(context, 2),
                                          onPageChanged: (index, reason) {
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
                                (int index) => AnimatedContainer(
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
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: variations,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
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
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
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
                      "Save: ₹ ${double.parse(product.mrp) - double.parse(product.price)}",
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
    );
  }
}

class ProductArguments {
  final Product product;

  ProductArguments(this.product);
}
