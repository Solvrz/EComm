import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '/config/constant.dart';
import '/models/product.dart';
import '/tools/extensions.dart';
import '/ui/pages/category/category.dart';
import '/ui/pages/category/widgets/product_list.dart';
import '/ui/pages/product/export.dart';
import '/ui/widgets/information_sheet.dart';
import '/ui/widgets/marquee.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = "";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: query == "",
      onPopInvoked: (noQuery) async {
        if (!noQuery) {
          if (context.mounted) {
            setState(() {
              query = "";
              controller.clear();
            });
          }
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
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                      fontFamily: "sans-serif-condensed",
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 2),
                    GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (_) => const InformationSheet(),
                        );
                        if (context.mounted) setState(() {});
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              (MediaQuery.of(context).size.width - 24) / 2.1,
                        ),
                        child: Text(
                          selectedInfo != null
                              ? selectedInfo!["address"]
                              : "Not Selected",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onPrimary,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.bold,
                            fontFamily: "sans-serif-condensed",
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                  ],
                ),
              ],
            ),
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
                  padding: screenSize.all(8),
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/images/Bag.png",
                        height: 30,
                        width: 30,
                      ),
                      Positioned(
                        left: 11,
                        top: 7,
                        child: Text(
                          BAG.products.length.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: query == ""
              ? GestureDetector(
                  onTap: () async {
                    final String _contact = CONTACT.split(" ").join();

                    if (await canLaunchUrlString("tel://$_contact")) {
                      await launchUrlString("tel://$_contact");
                    }
                  },
                  child: Container(
                    padding: screenSize.symmetric(vertical: 4, horizontal: 24),
                    color: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.8),
                    height: screenSize.height(75),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call,
                            size: screenSize.height(52),
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 15),
                          Column(
                            children: [
                              Text(
                                "Call or Whatsapp",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: screenSize.height(20),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                CONTACT,
                                style: TextStyle(
                                  fontSize: screenSize.height(20),
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 15),
                          Icon(
                            Icons.call,
                            size: screenSize.height(52),
                            color: Colors.transparent,
                          ),
                        ],
                      ),
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
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[600]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
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
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height(25),
                    ),
                    if (query != "")
                      StreamBuilder<QuerySnapshot>(
                        stream: FIRESTORE.collection("products").snapshots(),
                        builder: (context, future) {
                          if (future.hasData) {
                            final List<QueryDocumentSnapshot> docs =
                                future.data!.docs.where((element) {
                              final String name =
                                  element.get("name").toLowerCase();

                              int count = 0;

                              query.split(" ").forEach((element) {
                                if (name.contains(element)) count++;
                              });

                              return count > 0;
                            }).toList();

                            docs.sort(
                              (doc1, doc2) {
                                final String name1 =
                                    doc1.get("name").toLowerCase();
                                final String name2 =
                                    doc2.get("name").toLowerCase();

                                int count1 = 0;
                                int count2 = 0;

                                query.split(" ").forEach((element) {
                                  if (name1.contains(element)) count1++;
                                  if (name2.contains(element)) count2++;
                                });

                                return count1.compareTo(count2);
                              },
                            );

                            final List<Product> products = List.generate(
                              docs.length,
                              (index) =>
                                  Product.fromJson(docs[index].data()! as Map),
                            );

                            return products.isNotEmpty
                                ? ProductList(products: products)
                                : Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
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
                        },
                      )
                    else
                      Column(
                        children: [
                          Padding(
                            padding: screenSize.symmetric(horizontal: 6),
                            child: Column(
                              children: [
                                Text(
                                  "Categories",
                                  style: TextStyle(
                                    fontSize: screenSize.height(30),
                                    letterSpacing: 0.2,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                SizedBox(
                                  height: screenSize.height(14),
                                ),
                                FutureBuilder<QuerySnapshot>(
                                  future: FIRESTORE
                                      .collection("categories")
                                      .orderBy("uId")
                                      .get(),
                                  builder: (context, future) {
                                    if (future.hasData) {
                                      final List<QueryDocumentSnapshot>
                                          categories = future.data!.docs;

                                      return SizedBox(
                                        height: screenSize.height(125),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: categories.length,
                                          itemBuilder: (context, index) {
                                            final QueryDocumentSnapshot
                                                category = categories[index];

                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();

                                                Navigator.pushNamed(
                                                  context,
                                                  "/category",
                                                  arguments: CategoryArguments(
                                                    category.get("title"),
                                                    category.reference,
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4,
                                                margin:
                                                    screenSize.only(right: 12),
                                                padding: screenSize.all(8),
                                                decoration: BoxDecoration(
                                                  color: Color(
                                                    "0xff${category.get("color")}"
                                                        .toInt(),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.network(
                                                      category.get("image"),
                                                      height:
                                                          screenSize.height(50),
                                                      width: 50,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      category.get("title"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "sans-serif-condensed",
                                                        fontSize: screenSize
                                                            .height(16),
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
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
                          children: [
                            Text(
                              "Featured Products",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.8),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FutureBuilder<QuerySnapshot>(
                              future: FIRESTORE
                                  .collection("products")
                                  .where("featured", isEqualTo: true)
                                  .limit(10)
                                  .get(),
                              builder: (context, future) {
                                if (future.hasData) {
                                  final List<Product> products = future
                                      .data!.docs
                                      .map<Product>(
                                        (e) =>
                                            Product.fromJson(e.data()! as Map),
                                      )
                                      .toList();

                                  return products.isNotEmpty
                                      ? Column(
                                          children: List.generate(
                                            products.length,
                                            (index) => _buildItem(
                                              context,
                                              products[index],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: screenSize.height(275),
                                          alignment: Alignment.center,
                                          margin: screenSize.only(top: 45),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Featured Products Incoming! \nPlease Wait",
                                                maxLines: 3,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize:
                                                      screenSize.height(28),
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ],
                                          ),
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
        if (context.mounted) setState(() {});
      },
      child: Container(
        padding: screenSize.only(right: 8),
        margin: screenSize.symmetric(vertical: 8),
        height: screenSize.height(110),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: screenSize.symmetric(horizontal: 24, vertical: 18),
                child: Row(
                  children: [
                    if (product.images.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: product.images[0],
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Theme.of(context).highlightColor,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.grey),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    else
                      const Text(
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
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: screenSize.height(22),
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "$CURRENCY ${product.price}",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: screenSize.height(21),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-condensed",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "$CURRENCY ${product.mrp}"
                                      .replaceAll("", "\u{200B}"),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(0.7),
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: screenSize.height(18),
                                    fontWeight: FontWeight.w800,
                                    fontFamily: "sans-serif-condensed",
                                  ),
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
