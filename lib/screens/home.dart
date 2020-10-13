import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suneel_printer/components/category_grid.dart';
import 'package:suneel_printer/components/rounded_alert_dialog.dart';
import 'package:suneel_printer/constant.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;

  final List<String> carouselImages = [
    "https://i.ytimg.com/vi/wf4vcbiweDs/maxresdefault.jpg",
    "https://i.ytimg.com/vi/wf4vcbiweDs/maxresdefault.jpg",
    "https://i.ytimg.com/vi/wf4vcbiweDs/maxresdefault.jpg",
    "https://i.ytimg.com/vi/wf4vcbiweDs/maxresdefault.jpg",
    "https://i.ytimg.com/vi/wf4vcbiweDs/maxresdefault.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (_) => RoundedAlertDialog(
            title: "Do you want to quit the app?",
            buttonsList: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style:
                      TextStyle(color: kUIAccent, fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: kUIAccent),
                ),
              )
            ],
          ),
        );
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kUIColor,
          resizeToAvoidBottomInset: false,
          floatingActionButton: admin
              ? null
              : FloatingActionButton(
                  onPressed: () => Navigator.pushNamed(context, "/cart"),
                  child: Icon(Icons.shopping_cart),
                  backgroundColor: kUIAccent),
          appBar: AppBar(
            title: Hero(
              tag: "logo",
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  child: Center(
                    child: Text(
                      "Suneel Printers",
                      style: TextStyle(
                          fontFamily: "Kalam-Bold",
                          fontSize: 25,
                          color: kUILightText),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Column(children: [
            Container(
              padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: CarouselSlider(
                items: carouselImages
                    .map<Widget>((String item) => Container(
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                child: Image.network(item,
                                    fit: BoxFit.cover, width: 1000.0)),
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    carouselImages.length,
                    (int index) => Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? Color.fromRGBO(0, 0, 0, 0.9)
                                : Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        ))),
            SizedBox(height: 16),
            Expanded(
              child: Column(children: [
                Text(
                  "Categories",
                  style: TextStyle(
                      fontFamily: "sans-serif-condensed",
                      fontSize: 25,
                      color: kUIDarkText),
                ),
                CategoryGrid(categories: [
                  {
                    "uId": "1",
                    "name": "Office\nBooks",
                    "image": "assets/images/Office.png"
                  },
                  {
                    "name": "Stationary",
                    "image": "assets/images/Stationery.png",
                  },
                  {
                    "name": "Shagun",
                    "image": "assets/images/Shagun.png",
                  },
                  {
                    "name": "Computer \nAccessories",
                    "image": "assets/images/Computer.png",
                  },
                  {
                    "name": "Printing",
                    "image": "assets/images/Printing.png",
                  },
                  {
                    "name": "Photo Copy",
                    "image": "assets/images/Copy.png",
                  },
                  {
                    "name": "Binding",
                    "image": "assets/images/Binding.png",
                  },
                ]),
              ]),
            )
          ]),
        ),
      ),
    );
  }
}
