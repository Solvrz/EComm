import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';
import '../../screens/payment/payment.dart';
import '../../widgets/information_sheet.dart';

class RequestScreen extends StatefulWidget {
  final String title;
  final List tabsData;

  const RequestScreen({
    Key? key,
    required this.title,
    required this.tabsData,
  }) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  late String value;

  @override
  void initState() {
    super.initState();
    value = "Choose a Service";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: screenSize.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).highlightColor,
              ),
              height: screenSize.height(100),
              width: MediaQuery.of(context).size.width / 1.3,
              child: Padding(
                padding: screenSize.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Service: ",
                        style: TextStyle(
                          color: kUIDarkText,
                          fontSize: screenSize.height(25),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<String>(
                        hint: Text(value),
                        onChanged: (val) {
                          if (mounted) {
                            setState(() {
                              value = val!;
                            });
                          }
                        },
                        items: List.generate(widget.tabsData.length,
                                (index) => widget.tabsData[index]["name"])
                            .map<DropdownMenuItem<String>>(
                              (var val) => DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                  style: TextStyle(
                                      fontSize: screenSize.height(18),
                                      color: Colors.grey[900],
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "sans-serif-condensed"),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    ]),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).highlightColor,
              ),
              height: screenSize.height(200),
              width: MediaQuery.of(context).size.width / 1.3,
              child: Padding(
                padding: screenSize.all(15),
                child: selectedInfo == null
                    ? Center(
                        child: GestureDetector(
                          onTap: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (_) => Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: const InformationSheet(),
                              ),
                            );

                            if (mounted) setState(() {});
                          },
                          child: Text(
                            "Click Here \nSelect Information",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kUIDarkText,
                              fontSize: screenSize.height(20),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Name: ",
                                      style: TextStyle(
                                        color: kUIDarkText,
                                        fontSize: screenSize.height(20),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      selectedInfo!['name']
                                          .toString()
                                          .capitalize(),
                                      style: TextStyle(
                                        fontSize: screenSize.height(18),
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (_) => Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: const InformationSheet(),
                                      ),
                                    );

                                    if (mounted) setState(() {});
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    size: 25,
                                    color: kUIDarkText.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Phone: ",
                                  style: TextStyle(
                                    color: kUIDarkText,
                                    fontSize: screenSize.height(20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${selectedInfo!['phone']}",
                                  style: TextStyle(
                                    fontSize: screenSize.height(18),
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Email: ",
                                  style: TextStyle(
                                    color: kUIDarkText,
                                    fontSize: screenSize.height(20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${selectedInfo!['email']}",
                                  style: TextStyle(
                                    fontSize: screenSize.height(18),
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Address: ",
                                  style: TextStyle(
                                    color: kUIDarkText,
                                    fontSize: screenSize.height(20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${selectedInfo!['address'].toString().capitalize()}, ${selectedInfo!['pincode']}"
                                        .replaceAll("", "\u{200B}"),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: screenSize.height(18),
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
              ),
            )
          ]),
          Padding(
            padding: screenSize.all(8),
            child: MaterialButton(
              onPressed: value != "Choose a Service" && selectedInfo != null
                  ? () async {
                      await Navigator.popAndPushNamed(
                        context,
                        "/payment",
                        arguments: PaymentArguments(
                            success: true,
                            msg:
                                "You will soon receive a confirmation mail from us.",
                            process: () async {
                              await http.post(
                                Uri.http("192.168.100.45:5050", "request", {
                                  "name": selectedInfo!["name"],
                                  "phone": selectedInfo!["phone"],
                                  "address": selectedInfo!["address"],
                                  "email": selectedInfo!["email"],
                                  "order_list": value
                                }),
                              );
                            }),
                      );
                    }
                  : null,
              disabledColor: kUIDarkText.withOpacity(0.5),
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: screenSize.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Theme.of(context).highlightColor),
                  const SizedBox(width: 8),
                  Text(
                    "Place Order",
                    style: TextStyle(
                        fontSize: screenSize.height(16),
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).highlightColor),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
