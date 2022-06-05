import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../config/constant.dart';
import '../../widgets/alert_button.dart';
import '../../widgets/rounded_alert_dialog.dart';
import '../category/export.dart';
import '../order/widgets/order.dart';

bool hasShown = false;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      "high_importance_channel",
      "High Importance Notifications",
      importance: Importance.max,
    );

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      ),
      onSelectNotification: (_) async =>
          await Navigator.pushNamed(context, "/orders"),
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (notification != null && android != null)
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              groupKey: "com.solvrz.e_commerce_admin",
            ),
          ),
        );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
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
        await showDialog(
          context: context,
          builder: (_) => RoundedAlertDialog(
            title: "Do you want to quit the app?",
            buttonsList: [
              AlertButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                titleColor: Theme.of(context).backgroundColor,
                title: "No",
              ),
              AlertButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                titleColor: Theme.of(context).backgroundColor,
                title: "Yes",
              )
            ],
          ),
        );

        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(children: [
            Container(
              height: screenSize.height(360),
              decoration: const BoxDecoration(
                color: Color(0xffa5c4f2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: screenSize.symmetric(horizontal: 14, vertical: 16),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Undelivered Orders",
                        style: TextStyle(
                          fontSize: screenSize.height(32),
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.bold,
                          color: kUIDarkText.withOpacity(0.8),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pushNamed(context, "/orders");
                        },
                        child: Container(
                          child: Padding(
                            padding: screenSize.all(4),
                            child: Image.asset(
                              "assets/images/Orders.png",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: screenSize.height(275),
                    child: StreamBuilder(
                      stream: database
                          .collection("orders")
                          .orderBy("time", descending: true)
                          .snapshots(),
                      // ignore: avoid_types_on_closure_parameters
                      builder: (context, AsyncSnapshot<QuerySnapshot> future) {
                        if (future.hasData) {
                          if (future.data!.docs.isNotEmpty) {
                            List<Map> orders = [];
                            List<String> orderIds = [];

                            future.data!.docs.forEach((element) {
                              if (element.data() != null) {
                                if (!(element.data() as Map)["status"]) {
                                  orders.add(
                                    element.data() as Map,
                                  );
                                  orderIds.add(element.id);
                                }
                              }
                            });

                            return orders.isEmpty
                                ? Container(
                                    height: screenSize.height(275),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No Undelivered Orders Available",
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: screenSize.height(28),
                                        fontWeight: FontWeight.bold,
                                        color: kUILightText.withOpacity(0.8),
                                      ),
                                    ),
                                  )
                                : Container(
                                    child: Scrollbar(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Column(
                                              children: List.generate(
                                                orders.length,
                                                (index) => _buildItem(
                                                  context,
                                                  orderIds[index],
                                                  orders[index],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                          } else {
                            return Container(
                              height: screenSize.height(275),
                              alignment: Alignment.center,
                              child: Text(
                                "No Undelivered Orders Availble",
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenSize.height(28),
                                  fontWeight: FontWeight.bold,
                                  color: kUILightText.withOpacity(0.8),
                                ),
                              ),
                            );
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: screenSize.symmetric(horizontal: 14, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                        fontSize: screenSize.height(32),
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.bold,
                        color: kUIDarkText),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: screenSize.height(12),
                      childAspectRatio: screenSize.aspectRatio(1.2),
                      children: List.generate(
                        categories.length,
                        (index) {
                          Map<String, dynamic> data = categories[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
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
                              width: MediaQuery.of(context).size.width / 4,
                              padding: screenSize.all(8),
                              decoration: BoxDecoration(
                                color: data["color"],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    data["image"],
                                    height: screenSize.height(65),
                                    width: screenSize.height(65),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    data["name"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "sans-serif-condensed",
                                      fontSize: screenSize.height(18),
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
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

Widget _buildItem(BuildContext context, String id, Map order) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () async {
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: OrderSheet(order),
        ),
      );
    },
    child: Container(
      child: Padding(
        padding: screenSize.symmetric(horizontal: 12),
        child: Slidable(
          key: ValueKey(order["time"]),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.25,
            children: [
              Flexible(
                flex: 6,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => database
                      .collection("orders")
                      .doc(id)
                      .update({"status": !order["status"]}),
                  child: Container(
                    margin: screenSize.only(left: 12),
                    height: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: !order["status"]
                            ? Theme.of(context).primaryColor
                            : Colors.greenAccent),
                    child: Icon(
                        !order["status"] ? Icons.local_shipping : Icons.home,
                        color: kUILightText,
                        size: 32),
                  ),
                ),
              ),
            ],
          ),
          child: Container(
            margin: screenSize.symmetric(vertical: 8),
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200]),
            child: Padding(
              padding: screenSize.all(12),
              child: InfoWidget(order: order, large: false),
            ),
          ),
        ),
      ),
    ),
  );
}
