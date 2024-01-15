import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../category/export.dart';
import '../order/widgets/order.dart';
import '/config/constant.dart';

bool hasShown = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      "high_importance_channel",
      "High Importance Notifications",
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      ),
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((message) {
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification!.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              groupKey: "com.solvrz.ecomm_admin",
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Navigator.pushNamed(
        context,
        "/orders",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Undelivered Orders",
                          style: TextStyle(
                            fontSize: screenSize.height(28),
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.8),
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.pushNamed(context, "/orders");
                          },
                          child: Padding(
                            padding: screenSize.all(4),
                            child: Image.asset(
                              "assets/images/Orders.png",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: screenSize.height(265),
                      child: StreamBuilder(
                        stream: database
                            .collection("orders")
                            .orderBy("time", descending: true)
                            .snapshots(),
                        builder: (context, future) {
                          if (future.hasData) {
                            if (future.data!.docs.isNotEmpty) {
                              final List<Map<dynamic, dynamic>> orders = [];
                              final List<String> orderIds = [];

                              future.data!.docs.forEach((element) {
                                if (!(element.data() as Map)["status"]) {
                                  orders.add(
                                    element.data() as Map,
                                  );
                                  orderIds.add(element.id);
                                }
                              });

                              return orders.isEmpty
                                  ? Container(
                                      height: screenSize.height(275),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "No Undelivered Orders",
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: screenSize.height(28),
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                    )
                                  : Scrollbar(
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            } else {
                              return Container(
                                height: screenSize.height(275),
                                alignment: Alignment.center,
                                child: Text(
                                  "No Undelivered Orders",
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenSize.height(28),
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary
                                        .withOpacity(0.8),
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
                  ],
                ),
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
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: screenSize.height(12),
                    childAspectRatio: screenSize.aspectRatio(1.2),
                    children: List.generate(
                      categories.length,
                      (index) {
                        final Map<String, dynamic> data = categories[index];
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildItem(
  BuildContext context,
  String id,
  Map<dynamic, dynamic> order,
) {
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
                        : Colors.greenAccent,
                  ),
                  child: Icon(
                    !order["status"] ? Icons.local_shipping : Icons.home,
                    color: Theme.of(context).colorScheme.onSecondary,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
        child: Container(
          margin: screenSize.symmetric(vertical: 8),
          height: MediaQuery.of(context).size.height / 4.75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[200],
          ),
          child: Padding(
            padding: screenSize.all(12),
            child: InfoWidget(order: order, large: false),
          ),
        ),
      ),
    ),
  );
}