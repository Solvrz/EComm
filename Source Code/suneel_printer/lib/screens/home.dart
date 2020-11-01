import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:suneel_printer/components/alert_button.dart';
import 'package:suneel_printer/components/home.dart';
import 'package:suneel_printer/components/rounded_alert_dialog.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/screens/category.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
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
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kUIColor,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Text(
                                  "Deliver To",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
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
                                      await showMaterialModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (_, __) => InformationSheet(
                                            parentContext: context),
                                      );
                                      setState(() {});
                                    },
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  24) /
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
                                              fontFamily:
                                                  "sans-serif-condensed")),
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down,
                                      color: Colors.grey[600])
                                ],
                              )
                            ]),
                        Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    // TODO: Past Orders Screen
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Image.asset(
                                        "assets/images/YourOrders.png",
                                        width: 30,
                                        height: 30),
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () =>
                                      Navigator.pushNamed(context, "/bag"),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Image.asset(
                                        "assets/images/ShoppingBag.png",
                                        width: 30,
                                        height: 30),
                                  ),
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: EdgeInsets.symmetric(vertical: 24),
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
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ]),
                  ),
                  FutureBuilder<QuerySnapshot>(
                    future: database.collection("carouselImages").get(),
                    builder: (context, future) {
                      List carouselImages = [
                        "https://img.freepik.com/free-photo/abstract-surface-textures-white-concrete-stone-wall_74190-8184.jpg?size=626&ext=jpg"
                      ];

                      if (future.hasData) {
                        carouselImages =
                            future.data.docs.map((e) => e.get("url")).toList();
                      }

                      return Column(children: [
                        CarouselSlider.builder(
                          itemCount: carouselImages.length,
                          itemBuilder: (context, index) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                image: DecorationImage(
                                    image: NetworkImage(carouselImages[index]),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                              autoPlay:
                                  carouselImages.length > 1 ? true : false,
                              enlargeCenterPage: true,
                              aspectRatio: 2,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              }),
                        ),
                        SizedBox(height: 12),
                        if (carouselImages.length > 1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              carouselImages.length,
                              (int index) => AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                width: _current == index ? 16.0 : 8.0,
                                height: _current == index ? 6.0 : 8.0,
                                margin: EdgeInsets.symmetric(horizontal: 3.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: _current == index
                                      ? Color.fromRGBO(0, 0, 0, 0.9)
                                      : Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                              ),
                            ),
                          ),
                      ]);
                    },
                  ),
                  SizedBox(height: 18),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Categories",
                            style: TextStyle(
                                fontFamily: "sans-serif-condensed",
                                fontSize: 32,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.bold,
                                color: kUIDarkText),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 22),
                            child: GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.9,
                              children:
                                  List.generate(categories.length, (int index) {
                                Map<String, dynamic> data = categories[index];
                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () async {
                                    Navigator.pushNamed(
                                      context,
                                      "/category",
                                      arguments: CategoryArguments(
                                        data,
                                        await database
                                            .collection("categories")
                                            .where("uId",
                                                isEqualTo: data["uId"])
                                            .get(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Color(0xffFFEBEB),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(data["image"],
                                            height: 50, width: 50),
                                        SizedBox(height: 8),
                                        Text(
                                          data["name"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: kUIDarkText,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ]),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
