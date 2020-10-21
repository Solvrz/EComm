import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:suneel_printer/components/alert_button.dart';
import 'package:suneel_printer/components/rounded_alert_dialog.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/models/variation.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String name = "";
  String price = "";

  List<Image> images = [];
  List<File> imageFiles = [];

  List<Variation> variations = [];

  int _currentImage = 0;
  FocusNode _priceNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final AddProductArguments args = ModalRoute.of(context).settings.arguments;

    if (args.product != null) {
      name = args.product.name;
      price = args.product.price;
      if (args.product.images != null)
        images = args.product.images.map((e) => Image(image: e)).toList();
      variations = args.product.variations;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Builder(
                  builder: (BuildContext context) => Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: kUIColor)),
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.arrow_back_ios,
                                color: kUIDarkText, size: 26),
                          ),
                        ),
                        Text(
                          args.product != null ? "Edit" : "Preview",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sans-serif-condensed"),
                        ),
                        GestureDetector(
                          onTap: name != "" && price != ""
                              ? () async {
                                  Navigator.pop(context);

                                  List<String> urls = args.product != null
                                      ? args.product.images.map((e) => e.url)
                                      : [];
                                  bool noError = true;

                                  for (File file in imageFiles) {
                                    final StorageReference storageReference =
                                        FirebaseStorage.instance.ref().child(
                                            "Products/${args.title}/${args.tabsData[args.currentTab]["name"].split("\\n").join(" ")}/file-${Timestamp.now().toDate()}.pdf");
                                    final StorageTaskSnapshot snapshot =
                                        await storageReference
                                            .putFile(file)
                                            .onComplete;

                                    if (snapshot.error != null) {
                                      noError = false;
                                    } else {
                                      final String url =
                                          await snapshot.ref.getDownloadURL();

                                      urls.add(url);
                                      file.delete();
                                    }
                                  }

                                  if (noError) {
                                    QuerySnapshot query = await args
                                        .tabs[args.currentTab]
                                        .collection("products")
                                        .get();

                                    int maxId = 0;

                                    query.docs.forEach((element) {
                                      int currId = int.parse(element
                                          .data()["uId"]
                                          .split("/")
                                          .last);
                                      if (currId > maxId) maxId = currId;
                                    });

                                    if (args.product != null) {
                                      QuerySnapshot query = await args
                                          .tabs[args.currentTab]
                                          .collection("products")
                                          .where("uId",
                                              isEqualTo: args.product.uId)
                                          .get();
                                      query.docs.first.reference.update({
                                        "uId": "1/1/${maxId + 1}",
                                        "imgs": urls,
                                        "price": double.parse(price),
                                        "name": name,
                                        "variations": variations
                                            .map((e) => e.toJson())
                                            .toList()
                                      });
                                    } else {
                                      await args.tabs[args.currentTab]
                                          .collection("products")
                                          .add({
                                        "uId": "1/1/${maxId + 1}",
                                        "imgs": urls,
                                        "price": double.parse(price),
                                        "name": name,
                                        "variations": variations
                                            .map((e) => e.toJson())
                                            .toList()
                                      });
                                    }

                                    Scaffold.of(context)
                                        .removeCurrentSnackBar();
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        elevation: 10,
                                        backgroundColor: kUIAccent,
                                        content: Text(
                                          "Product added successfully",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Scaffold.of(context)
                                        .removeCurrentSnackBar();
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        elevation: 10,
                                        backgroundColor: kUIAccent,
                                        content: Text(
                                          "Sorry, The product couldn't be added",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: kUIColor)),
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.arrow_forward_ios,
                                color: name != "" && price != ""
                                    ? kUIDarkText
                                    : Colors.grey[400],
                                size: 26),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(thickness: 2, height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 44, bottom: 36),
                        child: TextField(
                            controller: TextEditingController(text: name),
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Product Name",
                                hintStyle: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "sans-serif-condensed")),
                            onChanged: (value) => name = value,
                            onSubmitted: (_) =>
                                FocusScope.of(context).autofocus(_priceNode),
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                fontFamily: "sans-serif-condensed")),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                                child: CarouselSlider(
                                  items: [
                                    ...images
                                        .map<Widget>((Image image) => image)
                                        .toList(),
                                    GestureDetector(
                                      onTap: () async {
                                        FilePickerResult result =
                                            await FilePicker.platform.pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: [
                                                  "png",
                                                  "jpg"
                                                ],
                                                allowMultiple: true);

                                        List<Image> compImages = [];
                                        List<File> compFiles = [];

                                        for (String path in result.paths) {
                                          File file = File(path);
                                          List<String> splits =
                                              file.absolute.path.split("/");

                                          File compFile =
                                              await FlutterImageCompress
                                                  .compressAndGetFile(
                                            file.absolute.path,
                                            splits
                                                    .getRange(
                                                        0, splits.length - 1)
                                                    .join("/") +
                                                "/Compressed" +
                                                Timestamp.now()
                                                    .toDate()
                                                    .toString() +
                                                ".jpeg",
                                            format: CompressFormat.jpeg,
                                          );
                                          compFiles.add(compFile);
                                          compImages.add(Image.file(compFile));
                                        }

                                        images.addAll(compImages);
                                        imageFiles.addAll(compFiles);
                                        setState(() {
                                          _currentImage = 0;
                                        });
                                      },
                                      child: Container(
                                        width: 120,
                                        margin: EdgeInsets.all(24),
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white70,
                                        ),
                                        child: Icon(Icons.post_add,
                                            color: kUIAccent, size: 32),
                                      ),
                                    ),
                                  ],
                                  options: CarouselOptions(
                                      autoPlay: images.length > 0,
                                      enlargeCenterPage: true,
                                      aspectRatio: 2.0,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _currentImage = index;
                                        });
                                      }),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      images.length + 1,
                                      (int index) => AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 400),
                                            width: _currentImage == index
                                                ? 16.0
                                                : 8.0,
                                            height: _currentImage == index
                                                ? 6.0
                                                : 8.0,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 3.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: _currentImage == index
                                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                                  : Color.fromRGBO(
                                                      0, 0, 0, 0.4),
                                            ),
                                          ))),
                            ]),
                      )
                    ],
                  ),
                ),
                Divider(thickness: 2, height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ...variations.map((Variation variation) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Slidable(
                                    key: ValueKey(variation.toString()),
                                    actionPane: SlidableDrawerActionPane(),
                                    secondaryActions: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            variations.remove(variation);
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 12),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              6,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: kUIAccent),
                                          child: Icon(Icons.delete,
                                              color: kUILightText, size: 32),
                                        ),
                                      )
                                    ],
                                    child: Container(
                                      height: 76,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TextField(
                                                onChanged: (value) =>
                                                    variations[variations
                                                            .indexOf(variation)]
                                                        .name = value,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "Name",
                                                    hintStyle: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            "sans-serif-condensed",
                                                        letterSpacing: 0.2)),
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                        "sans-serif-condensed",
                                                    letterSpacing: 0.2)),
                                          ),
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ...List.generate(
                                                    variation.options.length,
                                                    (index) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      3.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  final TextEditingController
                                                                      labelController =
                                                                      TextEditingController(
                                                                          text: variation
                                                                              .options[index]
                                                                              .label);
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (_) =>
                                                                              WillPopScope(
                                                                                onWillPop: () async {
                                                                                  setState(() {
                                                                                    if (variation.options[index].label != labelController.text && labelController.text != "") {
                                                                                      variations[variations.indexOf(variation)].options[index].label = labelController.text;
                                                                                    }
                                                                                  });
                                                                                  return true;
                                                                                },
                                                                                child: RoundedAlertDialog(
                                                                                  title: "Edit Option",
                                                                                  otherWidgets: [
                                                                                    TextField(
                                                                                      controller: labelController,
                                                                                      decoration: kInputDialogDecoration.copyWith(
                                                                                        suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: () => labelController.clear()),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 12),
                                                                                    BlockPicker(
                                                                                        availableColors: [
                                                                                          Color(0xFFF44336),
                                                                                          Color(0xFF2196F3),
                                                                                          Color(0xFF4CAF50),
                                                                                          Color(0xFFFFEB3B),
                                                                                          Color(0xFF03A9F4),
                                                                                          Color(0xFF8BC34A),
                                                                                          Color(0xFFFFC107),
                                                                                          Color(0xFFFF4081),
                                                                                          Color(0xFF9C27B0),
                                                                                          Color(0xFF000000),
                                                                                          Color(0xFF9E9E9E),
                                                                                          Color(0xFFFFFFFF),
                                                                                          Colors.transparent
                                                                                        ],
                                                                                        itemBuilder: (color, isCurrentColor, changeColor) {
                                                                                          final bool notTrans = color != Colors.transparent;
                                                                                          return Container(
                                                                                            margin: EdgeInsets.all(5.0),
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(50.0),
                                                                                              color: notTrans ? color : Colors.white,
                                                                                              boxShadow: notTrans
                                                                                                  ? [
                                                                                                      BoxShadow(
                                                                                                        color: color != Colors.white && notTrans ? color.withOpacity(0.8) : Colors.grey[600],
                                                                                                        offset: Offset(1.0, 2.0),
                                                                                                        blurRadius: 5.0,
                                                                                                      ),
                                                                                                    ]
                                                                                                  : null,
                                                                                            ),
                                                                                            child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: InkWell(
                                                                                                onTap: changeColor,
                                                                                                borderRadius: BorderRadius.circular(50.0),
                                                                                                child: notTrans
                                                                                                    ? AnimatedOpacity(
                                                                                                        duration: const Duration(milliseconds: 210),
                                                                                                        opacity: isCurrentColor ? 1.0 : 0.0,
                                                                                                        child: Icon(
                                                                                                          Icons.done,
                                                                                                          color: useWhiteForeground(color) ? Colors.white : Colors.black,
                                                                                                        ),
                                                                                                      )
                                                                                                    : Icon(Icons.clear),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                        pickerColor: variation.options[index].color ?? Colors.redAccent,
                                                                                        onColorChanged: (color) {
                                                                                          if (color != Colors.transparent)
                                                                                            variations[variations.indexOf(variation)].options[index].color = color;
                                                                                          else
                                                                                            variations[variations.indexOf(variation)].options[index].color = null;
                                                                                        })
                                                                                  ],
                                                                                  isExpanded: false,
                                                                                  buttonsList: [
                                                                                    AlertButton(
                                                                                        title: "Done",
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                          setState(() {
                                                                                            if (variation.options[index].label != labelController.text) {
                                                                                              variations[variations.indexOf(variation)].options[index].label = labelController.text;
                                                                                            }
                                                                                          });
                                                                                        })
                                                                                  ],
                                                                                ),
                                                                              ));
                                                                },
                                                                onLongPress:
                                                                    () {
                                                                  setState(() {
                                                                    variations[variations.indexOf(variation)].options.length >
                                                                            1
                                                                        ? variations[variations.indexOf(variation)]
                                                                            .options
                                                                            .removeAt(
                                                                                index)
                                                                        : variations
                                                                            .remove(variation);
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                          2,
                                                                          0,
                                                                          2,
                                                                          4),
                                                                  width: 32,
                                                                  height: 32,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: 0 ==
                                                                            index
                                                                        ? Border.all(
                                                                            color:
                                                                                Colors.grey[400],
                                                                            width: 2)
                                                                        : null,
                                                                  ),
                                                                  child: Center(
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius:
                                                                          10,
                                                                      backgroundColor: variation
                                                                              .options[index]
                                                                              .color ??
                                                                          Colors.grey[400],
                                                                      child: variation.options[index].color ==
                                                                              null
                                                                          ? Text(
                                                                              variation.options[index].label[0].toUpperCase(),
                                                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kUIDarkText))
                                                                          : null,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(variation
                                                                  .options[
                                                                      index]
                                                                  .label),
                                                            ],
                                                          ),
                                                        )),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        variations[variations
                                                                .indexOf(
                                                                    variation)]
                                                            .options
                                                            .add(Option(
                                                                label:
                                                                    "Label"));
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(Icons.add),
                                                    ))
                                              ])
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: AlertButton(
                                backgroundColor: Colors.white,
                                titleColor: kUIAccent,
                                title: "Add Variation",
                                onPressed: () => setState(() {
                                  variations.add(Variation(
                                      name: "",
                                      options: [Option(label: "Label")]));
                                }),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("Price",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                fontFamily: "sans-serif-condensed",
                                letterSpacing: 0.2)),
                      ),
                      Container(
                        width: 80,
                        child: TextField(
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text: price),
                            focusNode: _priceNode,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixText: "₹ ",
                                hintText: "Price",
                                hintStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "sans-serif-condensed",
                                    letterSpacing: -0.4)),
                            cursorColor: Colors.grey,
                            onChanged: (value) => price = value,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: "sans-serif-condensed",
                                letterSpacing: -0.4)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddProductArguments {
  final List<Map> tabsData;
  final List<DocumentReference> tabs;
  final String title;
  final int currentTab;
  Product product;

  AddProductArguments(
      {this.tabsData, this.tabs, this.title, this.currentTab, this.product});
}
