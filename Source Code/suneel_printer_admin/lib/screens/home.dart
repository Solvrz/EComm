import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:suneel_printer_admin/components/alert_button.dart';
import 'package:suneel_printer_admin/components/home.dart';
import 'package:suneel_printer_admin/components/rounded_alert_dialog.dart';
import 'package:suneel_printer_admin/constant.dart';
import 'package:suneel_printer_admin/models/product.dart';
import 'package:suneel_printer_admin/screens/category.dart';

bool hasShown = false;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  String query = "";

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      "high_importance_channel",
      "High Importance Notifications",
      "This channel is used for important notifications.",
      importance: Importance.max,
    );

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher")),
        onSelectNotification: (_) async =>
        await Navigator.pushNamed(context, "/orders"));

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null)
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  groupKey: "com.solvrz.suneel_printer_admin"),
            ));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.pushNamed(
        context,
        '/orders',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).requestFocus(FocusNode());

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
            builder: (_) =>
                RoundedAlertDialog(
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
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
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
                                controller: controller,
                                onChanged: (value) {
                                  if (mounted) setState(() => query = value);
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
                                  if (mounted)
                                    setState(() {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      query = "";
                                      controller.clear();
                                    });
                                },
                                child: Container(
                                    child: Icon(Icons.clear,
                                        color: Colors.grey[600])),
                              )
                          ]),
                        ),
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pushNamed(context, "/orders");
                        },
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Image.asset("assets/images/YourOrders.png",
                                width: 30, height: 30),
                          ),
                        ),
                      )
                    ],
                  ),
                  if (query != "")
                    StreamBuilder<QuerySnapshot>(
                        stream: database.collection("products").snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> future) {
                          if (future.hasData) {
                            List docs = future.data.docs
                                .where(
                                  (element) =>
                                  element
                                      .data()["name"]
                                      .toLowerCase()
                                      .contains(
                                    query.toLowerCase().trim(),
                                  ),
                            )
                                .toList();

                            List<Product> products = List.generate(
                              docs.length,
                                  (index) =>
                                  Product.fromJson(
                                    docs[index].data(),
                                  ),
                            );

                            return products.length > 0
                                ? GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              childAspectRatio: getAspect(context, 0.725),
                              children: List.generate(
                                products.length,
                                    (index) =>
                                    SearchCard(product: products[index]),
                              ),
                            )
                                : Center(
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width /
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
                    FutureBuilder<QuerySnapshot>(
                      future: database
                          .collection("carouselImages")
                          .orderBy("sequence")
                          .get(),
                      builder: (BuildContext context, AsyncSnapshot future) {
                        List carouselImages = [
                          "https://img.freepik.com/free-photo/abstract-surface-textures-white-concrete-stone-wall_74190-8184.jpg?size=626&ext=jpg"
                        ];

                        if (future.hasData) {
                          carouselImages = future.data.docs
                              .map(
                                (e) => e.get("url"),
                          )
                              .toList();
                        }

                        return Column(children: [
                          CarouselSlider.builder(
                            itemCount: carouselImages.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      image: DecorationImage(
                                          image:
                                          NetworkImage(carouselImages[index]),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                            options: CarouselOptions(
                                autoPlay:
                                carouselImages.length > 1 ? true : false,
                                enlargeCenterPage: true,
                                aspectRatio: getAspect(context, 2),
                                onPageChanged: (index, reason) {
                                  if (mounted)
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
                                    (int index) =>
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 400),
                                      width: _current == index ? 16 : 8,
                                      height: _current == index ? 6 : 8,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: _current == index
                                            ? Color.fromRGBO(0, 0, 0, 0.9)
                                            : Color.fromRGBO(0, 0, 0, 0.4),
                                      ),
                                    ),
                              ),
                            ),
                          SizedBox(height: 18),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Categories",
                                    style: TextStyle(
                                        fontSize: getHeight(context, 32),
                                        letterSpacing: 0.2,
                                        fontWeight: FontWeight.bold,
                                        color: kUIDarkText),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 22),
                                    child: Container(
                                      height: getHeight(context, 290),
                                      child: GridView.count(
                                        shrinkWrap: true,
                                        crossAxisCount: 3,
                                        mainAxisSpacing: getHeight(context, 12),
                                        crossAxisSpacing: 12,
                                        childAspectRatio:
                                        getAspect(context, 0.9),
                                        children: List.generate(
                                            categories.length, (int index) {
                                          Map<String, dynamic> data =
                                          categories[index];
                                          return GestureDetector(
                                            behavior:
                                            HitTestBehavior.translucent,
                                            onTap: onOrder
                                                .contains(data["name"])
                                                ? () {
                                              Scaffold.of(context)
                                                  .removeCurrentSnackBar();
                                              Scaffold.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  elevation: 10,
                                                  backgroundColor:
                                                  kUIAccent,
                                                  content: Text(
                                                    "Sorry, ${data["name"]} screen is not available in Admin Mode",
                                                    textAlign:
                                                    TextAlign.center,
                                                  ),
                                                ),
                                              );
                                            }
                                                : () =>
                                                Navigator.pushNamed(
                                                  context,
                                                  "/category",
                                                  arguments:
                                                  CategoryArguments(
                                                    data,
                                                    data["uId"],
                                                  ),
                                                ),
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Color(0xffFFEBEB),
                                                borderRadius:
                                                BorderRadius.circular(15),
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
                                                      fontSize: getHeight(
                                                          context, 14),
                                                      fontFamily:
                                                      "sans-serif-condensed",
                                                      color: kUIDarkText,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ]);
                      },
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
