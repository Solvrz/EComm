import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:suneel_printer_admin/components/alert_button.dart';
import 'package:suneel_printer_admin/components/order.dart';
import 'package:suneel_printer_admin/components/rounded_alert_dialog.dart';
import 'package:suneel_printer_admin/constant.dart';
import 'package:suneel_printer_admin/screens/category.dart';

bool hasShown = false;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      ),
      onSelectNotification: (_) async =>
          await Navigator.pushNamed(context, "/orders"),
    );

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
          ),
        );
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
          body: Column(children: [
            Container(
              height: getHeight(context, 360),
              decoration: BoxDecoration(
                color: kUISecondaryAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Undelivered Orders",
                        style: TextStyle(
                          fontSize: getHeight(context, 32),
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
                            padding: EdgeInsets.all(4),
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
                  SizedBox(height: 12),
                  Container(
                    height: getHeight(context, 275),
                    child: StreamBuilder(
                      stream: database
                          .collection("orders")
                          .orderBy("time", descending: true)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot future) {
                        if (future.hasData) {
                          if (future.data.docs.isNotEmpty) {
                            List<Map> orders = [];
                            List<String> orderIds = [];

                            future.data.docs.forEach((element) {
                              if (element.data() != null) {
                                if (!element.data()["status"]) {
                                  orders.add(
                                    element.data(),
                                  );
                                  orderIds.add(element.id);
                                }
                              }
                            });

                            return orders.isEmpty
                                ? Container(
                                    height: getHeight(context, 275),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No Undelivered Orders Available",
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: getHeight(context, 28),
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
                              height: getHeight(context, 275),
                              alignment: Alignment.center,
                              child: Text(
                                "No Undelivered Orders Availble",
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: getHeight(context, 28),
                                  fontWeight: FontWeight.bold,
                                  color: kUILightText.withOpacity(0.8),
                                ),
                              ),
                            );
                          }
                        } else {
                          return Center(
                            child: indicator,
                          );
                        }
                      },
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                        fontSize: getHeight(context, 32),
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.bold,
                        color: kUIDarkText),
                  ),
                  SizedBox(height: 12),
                  Container(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: getHeight(context, 12),
                      childAspectRatio: getAspect(context, 1.2),
                      children: List.generate(
                        categories.length,
                        (int index) {
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
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: data["color"],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    data["image"],
                                    height: getHeight(context, 65),
                                    width: getHeight(context, 65),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    data["name"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "sans-serif-condensed",
                                      fontSize: getHeight(context, 18),
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
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) => Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: OrderSheet(order),
        ),
      );
    },
    child: Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Slidable(
          key: ValueKey(order["time"]),
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => database
                  .collection("orders")
                  .doc(id)
                  .update({"status": !order["status"]}),
              child: Container(
                margin: EdgeInsets.only(left: 12),
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: !order["status"] ? kUIAccent : Colors.greenAccent),
                child: Icon(
                    !order["status"] ? Icons.local_shipping : Icons.home,
                    color: kUILightText,
                    size: 32),
              ),
            )
          ],
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200]),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: InfoWidget(order: order, large: false),
            ),
          ),
        ),
      ),
    ),
  );
}
