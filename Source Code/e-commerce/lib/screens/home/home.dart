import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../config/constant.dart';
import '../../models/product.dart';
import '../../screens/category/widgets/product_list.dart';
import '../../widgets/alert_button.dart';
import '../../widgets/information_sheet.dart';
import '../../widgets/marquee.dart';
import '../../widgets/rounded_alert_dialog.dart';
import '../category/export.dart';
import '../product/export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = "";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (query != "") {
          if (mounted) {
            setState(() {
              query = "";
              controller.clear();
            });
          }
          return false;
        } else {
          await showDialog(
            context: context,
            builder: (_) => RoundedAlertDialog(
              title: "Do you want to quit the app?",
              buttonsList: [
                AlertButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    title: "No"),
                AlertButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    title: "Yes")
              ],
            ),
          );
          return false;
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: screenSize.only(left: 4),
                      child: Text(
                        "Deliver To",
                        style: TextStyle(
                            fontSize: screenSize.height(18),
                            color: kUIDarkText,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                            fontFamily: "sans-serif-condensed"),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: kUIDarkText, size: 20),
                        const SizedBox(width: 2),
                        GestureDetector(
                          onTap: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (_) => const InformationSheet(),
                            );
                            if (mounted) setState(() {});
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    (MediaQuery.of(context).size.width - 24) /
                                        2.1),
                            child: Text(
                              selectedInfo != null
                                  ? selectedInfo!["address"]
                                  : "Not Selected",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: kUIDarkText,
                                  letterSpacing: 0.2,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-condensed"),
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.grey[600])
                      ],
                    )
                  ]),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/orders");
                  },
                  child: Padding(
                    padding: screenSize.all(8),
                    child: Image.asset(
                      "assets/images/Orders.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/bag"),
                  child: Padding(
                    padding: screenSize.all(14),
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/ShoppingBag.png",
                          height: 30,
                          width: 30,
                        ),
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
              ]),
          bottomNavigationBar: query == ""
              ? GestureDetector(
                  onTap: () async => await canLaunchUrlString("tel://$contact")
                      ? launchUrlString("tel://$contact")
                      : null,
                  child: Container(
                    padding: screenSize.symmetric(vertical: 4, horizontal: 24),
                    color: Theme.of(context).backgroundColor.withOpacity(0.8),
                    height: screenSize.height(62),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.call,
                                size: screenSize.height(52),
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 15),
                            Column(children: [
                              Text(
                                "Call or Whatsapp",
                                style: TextStyle(
                                    color: kUIDarkText,
                                    fontSize: screenSize.height(20),
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                contact,
                                style: TextStyle(
                                    fontSize: screenSize.height(22),
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ]),
                            const SizedBox(width: 15),
                            Icon(Icons.call,
                                size: screenSize.height(52),
                                color: Colors.transparent),
                          ]),
                    ),
                  ),
                )
              : null,
          body: Column(
            children: [
              Padding(
                padding: screenSize.all(16),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: screenSize.height(50),
                      padding: screenSize.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Icon(Icons.search, color: Colors.grey[600]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search for Products",
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: controller,
                            onChanged: (value) {
                              setState(() => query = value);
                            },
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (query != "")
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                FocusScope.of(context).requestFocus(
                                  FocusNode(),
                                );
                                query = "";
                                controller.clear();
                              });
                            },
                            child: Icon(Icons.clear, color: Colors.grey[600]),
                          )
                      ]),
                    ),
                    SizedBox(
                      height: screenSize.height(25),
                    ),
                    if (query != "")
                      StreamBuilder<QuerySnapshot>(
                          stream: database.collection("products").snapshots(),
                          builder: (context, future) {
                            if (future.hasData) {
                              List docs = future.data!.docs.where((element) {
                                String name = element.get("name").toLowerCase();

                                int count = 0;

                                query.split(" ").forEach((element) {
                                  if (name.contains(element)) count++;
                                });

                                return count > 0;
                              }).toList();

                              docs.sort(
                                (doc1, doc2) {
                                  String name1 =
                                      doc1.data()["name"].toLowerCase();
                                  String name2 =
                                      doc2.data()["name"].toLowerCase();

                                  int count1 = 0;
                                  int count2 = 0;

                                  query.split(" ").forEach((element) {
                                    if (name1.contains(element)) count1++;
                                    if (name2.contains(element)) count2++;
                                  });

                                  return count1.compareTo(count2);
                                },
                              );

                              List<Product> products = List.generate(
                                docs.length,
                                (index) => Product.fromJson(
                                  docs[index].data(),
                                ),
                              );

                              return products.isNotEmpty
                                  ? ProductList(products: products)
                                  : Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.25,
                                        child: EmptyWidget(
                                          packageImage: PackageImage.Image_1,
                                          title: "No Results",
                                          subTitle:
                                              "No results found for your search",
                                        ),
                                      ),
                                    );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          })
                    else
                      Column(
                        children: [
                          Padding(
                            padding: screenSize.symmetric(horizontal: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Categories",
                                  style: TextStyle(
                                      fontSize: screenSize.height(30),
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.bold,
                                      color: kUIDarkText),
                                ),
                                SizedBox(
                                  height: screenSize.height(14),
                                ),
                                SizedBox(
                                  height: screenSize.height(125),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categories.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> data =
                                          categories[index];
                                      return GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();

                                          Navigator.pushNamed(
                                            context,
                                            "/category",
                                            arguments: CategoryArguments(
                                              data,
                                              data["uId"],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          margin: screenSize.only(right: 12),
                                          padding: screenSize.all(8),
                                          decoration: BoxDecoration(
                                            color: data["color"],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(data["image"],
                                                  height: screenSize.height(50),
                                                  width: 50),
                                              const SizedBox(height: 8),
                                              Text(
                                                data["name"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      "sans-serif-condensed",
                                                  fontSize:
                                                      screenSize.height(16),
                                                  color: kUIDarkText,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (query == "") ...[
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    padding: screenSize.symmetric(horizontal: 4, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xffa5c4f2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: screenSize.symmetric(horizontal: 12),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Trending Products",
                              style: TextStyle(
                                color: kUIDarkText.withOpacity(0.8),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FutureBuilder<QuerySnapshot>(
                              future: database
                                  .collection("products")
                                  .where("trending", isEqualTo: true)
                                  .limit(10)
                                  .get(),
                              builder: (context, future) {
                                if (future.hasData) {
                                  List<Product> products = future.data!.docs
                                      .map<Product>(
                                        (e) => Product.fromJson(
                                          e.data() as Map,
                                        ),
                                      )
                                      .toList();

                                  return products.isNotEmpty
                                      ? Column(
                                          children: List.generate(
                                            products.length,
                                            (index) => _buildItem(
                                                context, products[index]),
                                          ),
                                        )
                                      : Container(
                                          height: screenSize.height(275),
                                          alignment: Alignment.center,
                                          margin: screenSize.only(top: 45),
                                          child: Column(children: [
                                            Text(
                                              "Trending Products Incoming! \nPlease Wait",
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: screenSize.height(28),
                                                fontWeight: FontWeight.bold,
                                                color: kUILightText
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                            const SizedBox(height: 25),
                                            const CircularProgressIndicator(),
                                          ]),
                                        );
                                }

                                return Container();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          "/product",
          arguments: ProductArguments(product),
        );
        if (mounted) setState(() {});
      },
      child: Container(
        padding: screenSize.only(right: 8),
        margin: screenSize.symmetric(vertical: 8),
        height: screenSize.height(110),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).backgroundColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: screenSize.symmetric(horizontal: 24, vertical: 18),
                child: Row(
                  children: [
                    product.images.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.images[0],
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Theme.of(context).highlightColor,
                              highlightColor: Colors.grey[100]!,
                              child: Container(color: Colors.grey),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : const Text(
                            "No Image",
                            style: TextStyle(fontSize: 18),
                          ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Marquee(
                            child: Text(
                              product.name,
                              style: TextStyle(
                                  color: kUIDarkText,
                                  fontSize: screenSize.height(22),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.4),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "₹ ${product.price}",
                                style: TextStyle(
                                    color: kUIDarkText,
                                    fontSize: screenSize.height(21),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "sans-serif-condensed"),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "₹ ${product.mrp}".replaceAll("", "\u{200B}"),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: kUIDarkText.withOpacity(0.7),
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: screenSize.height(18),
                                      fontWeight: FontWeight.w800,
                                      fontFamily: "sans-serif-condensed"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
