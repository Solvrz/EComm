import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suneel_printer/components/alert_button.dart';
import 'package:suneel_printer/components/category.dart';
import 'package:suneel_printer/components/home.dart';
import 'package:suneel_printer/components/rounded_alert_dialog.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/screens/category.dart';
import 'package:suneel_printer/screens/product.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = "";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).requestFocus(
          FocusNode(),
        );

        if (query != "") {
          if (mounted)
            setState(() {
              query = "";
              controller.clear();
            });
          return false;
        } else {
          return showDialog(
            context: context,
            builder: (_) => RoundedAlertDialog(
              title: "Do you want to quit the app?",
              buttonsList: [
                AlertButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  titleColor: kUIColor,
                  title: "No",
                ),
                AlertButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  titleColor: kUIColor,
                  title: "Yes",
                )
              ],
            ),
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kUIColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: kUIColor,
              automaticallyImplyLeading: false,
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        "Deliver To",
                        style: TextStyle(
                            fontSize: getHeight(context, 18),
                            color: kUIDarkText,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                            fontFamily: "sans-serif-condensed"),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: kUIDarkText, size: 20),
                        SizedBox(width: 2),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (_) => InformationSheet(),
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
                                  ? selectedInfo["address"]
                                  : "Not Selected",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
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
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pushNamed(context, "/orders");
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Image.asset(
                        "assets/images/YourOrders.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pushNamed(context, "/bag");
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Stack(
                        children: [
                          Image.asset(
                            "assets/images/ShoppingBag.png",
                            width: 30,
                            height: 30,
                          ),
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
              ]),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: getHeight(context, 50),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Icon(Icons.search, color: Colors.grey[600]),
                        SizedBox(width: 12),
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
                            behavior: HitTestBehavior.translucent,
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
                      height: getHeight(context, 25),
                    ),
                    if (query != "")
                      StreamBuilder<QuerySnapshot>(
                          stream: database.collection("products").snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> future) {
                            if (future.hasData) {
                              List docs = future.data.docs.where((element) {
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

                              return products.length > 0
                                  ? ProductList(products: products)
                                  : Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.25,
                                        child: EmptyListWidget(
                                          packageImage: PackageImage.Image_1,
                                          title: "No Results",
                                          subTitle:
                                              "No results found for your search",
                                        ),
                                      ),
                                    );
                            } else {
                              return Center(
                                child: indicator,
                              );
                            }
                          })
                    else
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Categories",
                                  style: TextStyle(
                                      fontSize: getHeight(context, 30),
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.bold,
                                      color: kUIDarkText),
                                ),
                                SizedBox(
                                  height: getHeight(context, 14),
                                ),
                                Container(
                                  height: getHeight(context, 125),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categories.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Map<String, dynamic> data =
                                          categories[index];
                                      return GestureDetector(
                                        behavior: HitTestBehavior.translucent,
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
                                          margin: EdgeInsets.only(right: 12),
                                          padding: EdgeInsets.all(8),
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
                                                  height:
                                                      getHeight(context, 50),
                                                  width: 50),
                                              SizedBox(height: 8),
                                              Text(
                                                data["name"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      "sans-serif-condensed",
                                                  fontSize:
                                                      getHeight(context, 16),
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
                SizedBox(height: 16),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xffa5c4f2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Scrollbar(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
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
                              SizedBox(height: 8),
                              FutureBuilder<QuerySnapshot>(
                                future: database
                                    .collection("products")
                                    .where("trending", isEqualTo: true)
                                    .limit(10)
                                    .get(),
                                builder: (BuildContext context, future) {
                                  if (future.hasData) {
                                    List<Product> products = future.data.docs
                                        .map<Product>((DocumentSnapshot e) =>
                                            Product.fromJson(e.data()))
                                        .toList();

                                    if (products.isNotEmpty) {
                                      products.add(products.first);
                                      products.add(products.first);
                                      products.add(products.first);
                                    }

                                    return products.isNotEmpty
                                        ? Column(
                                            children: List.generate(
                                              products.length,
                                              (int index) {
                                                Product product =
                                                    products[index];
                                                return GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  onTap: () async {
                                                    await Navigator.pushNamed(
                                                      context,
                                                      "/product",
                                                      arguments:
                                                          ProductArguments(
                                                              products[index]),
                                                    );
                                                    if (mounted)
                                                      setState(() {});
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        right: 8),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    height:
                                                        getHeight(context, 110),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: kUIColor),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        24,
                                                                    vertical:
                                                                        18),
                                                            child: Row(
                                                              children: [
                                                                product.images
                                                                            .length >
                                                                        0
                                                                    ? Image(
                                                                        image: product
                                                                            .images[0])
                                                                    : Text(
                                                                        "No Image",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18),
                                                                      ),
                                                                SizedBox(
                                                                    width: 24),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          product.name.replaceAll(
                                                                              "",
                                                                              "\u{200B}"),
                                                                          maxLines:
                                                                              3,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              color: kUIDarkText,
                                                                              fontSize: getHeight(context, 22),
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
                                                                                fontSize: getHeight(context, 21),
                                                                                fontWeight: FontWeight.bold,
                                                                                fontFamily: "sans-serif-condensed"),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 12),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              "₹ ${product.mrp}".replaceAll("", "\u{200B}"),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(color: kUIDarkText.withOpacity(0.7), decoration: TextDecoration.lineThrough, fontSize: getHeight(context, 18), fontWeight: FontWeight.w800, fontFamily: "sans-serif-condensed"),
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
                                                        if (product.selected
                                                                .length >
                                                            0)
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 12,
                                                                    left: 4,
                                                                    top: 18,
                                                                    bottom: 18),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children:
                                                                  List.generate(
                                                                product.selected
                                                                    .length,
                                                                (index) =>
                                                                    CircleAvatar(
                                                                  radius: 12,
                                                                  backgroundColor: product
                                                                          .selected
                                                                          .values
                                                                          .toList()[
                                                                              index]
                                                                          .color ??
                                                                      Colors.grey[
                                                                          400],
                                                                  child: product
                                                                              .selected
                                                                              .values
                                                                              .toList()[index]
                                                                              .color ==
                                                                          null
                                                                      ? Text(
                                                                          product
                                                                              .selected
                                                                              .values
                                                                              .toList()[index]
                                                                              .label[0]
                                                                              .toUpperCase(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                getHeight(
                                                                              context,
                                                                              13,
                                                                            ),
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                kUIDarkText,
                                                                          ),
                                                                        )
                                                                      : null,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : Container(
                                            height: getHeight(context, 275),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No Trending Products available right now",
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize:
                                                    getHeight(context, 28),
                                                fontWeight: FontWeight.bold,
                                                color: kUILightText
                                                    .withOpacity(0.8),
                                              ),
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
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// TODO: Decide on Call or WhatsApp
// Align(
//   alignment: Alignment.bottomCenter,
//   child: GestureDetector(
//     behavior: HitTestBehavior.translucent,
//     onTap: () async {
//       if (await canLaunch("tel://$contact"),)
//         launch("tel://$contact");

//       // if (await canLaunch("whatsapp://send?phone=$contact"),)
//       //   launch("whatsapp://send?phone=$contact");
//     },
//     child: Container(
//       padding: EdgeInsets.symmetric(
//           vertical: 4, horizontal: 24),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//       ),
//       height: getHeight(context, 62),
//       width: MediaQuery.of(context).size.width,
//       child: Center(
//         child: Row(
//             mainAxisAlignment:
//                 MainAxisAlignment.center,
//             children: [
//               Icon(Icons.call,
//                   size: getHeight(context, 52),
//                   color: kUIAccent),
//               SizedBox(width: 15),
//               Column(
//                 children: [
//                   Text(
//                     "Call or Whatsapp",
//                     style: TextStyle(
//                         fontSize:
//                             getHeight(context, 20),
//                         fontWeight:
//                             FontWeight.w400),
//                   ),
//                   Text(
//                     "$contact",
//                     style: TextStyle(
//                         fontSize:
//                             getHeight(context, 22),
//                         fontWeight: FontWeight.bold,
//                         color: kUIAccent),
//                   ),
//                 ],
//               ),
//             ]),
//       ),
//     ),
//   ),
// )

// TODO: Decide on Carousel
//FutureBuilder<QuerySnapshot>(
//     future: database
//         .collection("carouselImages")
//         .orderBy("sequence")
//         .get(),
//     builder: (BuildContext context, AsyncSnapshot future) {
//       List carouselImages = [
//         "https://img.freepik.com/free-photo/abstract-surface-textures-white-concrete-stone-wall_74190-8184.jpg?size=626&ext=jpg"
//       ];

//       if (future.hasData) {
//         carouselImages = future.data.docs
//             .map(
//               (e) => e.get("url"),
//             )
//             .toList();
//       }

//       return Column(children: [
//         Container(
//           height: getHeight(context, 180),
//           width: MediaQuery.of(context).size.width,
//           child: CarouselSlider.builder(
//             itemCount: carouselImages.length,
//             itemBuilder: (BuildContext context, int index) =>
//                 ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   image: DecorationImage(
//                       image: NetworkImage(carouselImages[index]),
//                       fit: BoxFit.cover),
//                 ),
//               ),
//             ),
//             options: CarouselOptions(
//                 autoPlay:
//                     carouselImages.length > 1 ? true : false,
//                 enlargeCenterPage: true,
//                 aspectRatio: 2,
//                 onPageChanged: (index, reason) {
//                   setState(() {
//                     _current = index;
//                   });
//                 }),
//           ),
//         ),
//         SizedBox(height: 12),
//         if (carouselImages.length > 1)
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               carouselImages.length,
//               (int index) => AnimatedContainer(
//                 duration: Duration(milliseconds: 400),
//                 width: _current == index ? 16 : 8,
//                 height: _current == index ? 6 : 8,
//                 margin: EdgeInsets.symmetric(horizontal: 3),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: _current == index
//                       ? Color.fromRGBO(0, 0, 0, 0.9)
//                       : Color.fromRGBO(0, 0, 0, 0.4),
//                 ),
//               ),
//             ),
//           ),
//         SizedBox(height: getHeight(context, 14),),
//       ]);
//     }),
