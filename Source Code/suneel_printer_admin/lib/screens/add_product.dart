import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:suneel_printer_admin/components/alert_button.dart';
import 'package:suneel_printer_admin/components/custom_app_bar.dart';
import 'package:suneel_printer_admin/components/rounded_alert_dialog.dart';
import 'package:suneel_printer_admin/constant.dart';
import 'package:suneel_printer_admin/models/product.dart';
import 'package:suneel_printer_admin/models/variation.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String name = "";
  String price = "";
  String mrp = "";

  List<Color> colors = [
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
  ];

  List<Image> images = [];
  List<String> urls = [];
  List<File> imageFiles = [];

  List<Variation> variations = [];

  int _currentImage = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController mrpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AddProductArguments args = ModalRoute.of(context).settings.arguments;

    if (args.product != null && name == "") {
      name = args.product.name;
      nameController.text = name;

      price = args.product.price;
      priceController.text = price;

      mrp = args.product.mrp;
      mrpController.text = mrp;

      if (args.product.images != null) {
        images = args.product.images
            .map(
              (e) => Image(image: e),
            )
            .toList();
        urls = args.product.images
            .map(
              (e) => e.url,
            )
            .toList();
      }

      variations = args.product.variations;
    }

    return WillPopScope(
      onWillPop: () async {
        _buildDiscardChangesDialog(context);

        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kUIColor,
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            parent: context,
            title: args.product != null ? "Edit" : "Preview",
            leading: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _buildDiscardChangesDialog(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kUIColor),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_back_ios, color: kUIDarkText, size: 26),
              ),
            ),
            trailing: [
              Builder(
                builder: (context) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: name == ""
                      ? () {
                          Scaffold.of(context).removeCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              elevation: 10,
                              backgroundColor: kUIAccent,
                              content: Text(
                                "Name can't be Empty",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      : price == ""
                          ? () {
                              Scaffold.of(context).removeCurrentSnackBar();
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  elevation: 10,
                                  backgroundColor: kUIAccent,
                                  content: Text(
                                    "Actual Price can't be Empty",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                          : mrp == ""
                              ? () {
                                  Scaffold.of(context).removeCurrentSnackBar();
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      elevation: 10,
                                      backgroundColor: kUIAccent,
                                      content: Text(
                                        "MRP can't be Empty",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                              : () {
                                  _addProduct(
                                      context,
                                      args.title,
                                      args.product,
                                      args.tabs,
                                      args.tabsData,
                                      args.currentTab);

                                  Navigator.pop(context);
                                },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: kUIColor),
                        ),
                        child: Text(
                          "Post",
                          style: TextStyle(
                            color: kUIAccent,
                            fontSize: getHeight(context, 20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              height: getHeight(context, 730),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: nameController,
                                  cursorColor: Colors.grey,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Product Name",
                                    hintStyle: TextStyle(
                                        color: kUIDarkText.withOpacity(0.7),
                                        fontSize: getHeight(context, 28),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "sans-serif-condensed"),
                                  ),
                                  onChanged: (value) {
                                    if (mounted) setState(() => name = value);
                                  },
                                  style: TextStyle(
                                      color: kUIDarkText,
                                      fontSize: getHeight(context, 28),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "sans-serif-condensed"),
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  FilePickerResult result =
                                      await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ["png", "jpg"],
                                          allowMultiple: true);

                                  List<Image> compImages = [];
                                  List<File> compFiles = [];

                                  for (String path in result.paths) {
                                    File file = File(path);
                                    List<String> splits =
                                        file.absolute.path.split("/");

                                    File compFile = await FlutterImageCompress
                                        .compressAndGetFile(
                                      file.absolute.path,
                                      splits
                                              .getRange(0, splits.length - 1)
                                              .join("/") +
                                          "/Compressed" +
                                          Timestamp.now().toDate().toString() +
                                          ".jpeg",
                                      format: CompressFormat.jpeg,
                                    );
                                    compFiles.add(compFile);
                                    compImages.add(
                                      Image.file(compFile),
                                    );
                                  }

                                  images.addAll(compImages);
                                  imageFiles.addAll(compFiles);
                                  if (mounted)
                                    setState(() {
                                      _currentImage = 0;
                                    });
                                },
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(Icons.add_photo_alternate,
                                        color: kUIAccent, size: 34),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width,
                          child: images.length > 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: CarouselSlider(
                                        items: images
                                            .map<Widget>((Image image) => image)
                                            .toList(),
                                        options: CarouselOptions(
                                            autoPlay: images.length > 1
                                                ? true
                                                : false,
                                            enlargeCenterPage: true,
                                            aspectRatio:
                                                getAspect(context, 2.5),
                                            onPageChanged: (index, reason) {
                                              if (mounted)
                                                setState(() {
                                                  _currentImage = index;
                                                });
                                            }),
                                      ),
                                    ),
                                    if (images.length > 1)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          images.length,
                                          (int index) => AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 400),
                                            width:
                                                _currentImage == index ? 16 : 8,
                                            height:
                                                _currentImage == index ? 6 : 8,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 3),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: _currentImage == index
                                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                                  : Color.fromRGBO(
                                                      0, 0, 0, 0.4),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    "No Images Added\nAdd One",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: getHeight(context, 20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                  Divider(thickness: 2, height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ...variations.map(
                                (Variation variation) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: _buildVariation(context, variation),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: AlertButton(
                        backgroundColor: kUIColor,
                        titleColor: kUIAccent,
                        title: "Add Variation",
                        onPressed: () {
                          if (mounted)
                            setState(() {
                              variations.add(
                                Variation(
                                    name: "",
                                    options: [Option(label: "Label")]),
                              );
                            });
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18, 20, 18, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "MRP",
                            style: TextStyle(
                                color: kUIDarkText,
                                fontSize: getHeight(context, 22),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2),
                          ),
                        ),
                        Container(
                          width: 80,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: mrpController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixText: "₹ ",
                              hintText: "MRP",
                              hintStyle: TextStyle(
                                  color: kUIDarkText.withOpacity(0.7),
                                  fontSize: getHeight(context, 20),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.4),
                            ),
                            onChanged: (value) {
                              if (mounted) setState(() => mrp = value);
                            },
                            cursorColor: Colors.grey,
                            style: TextStyle(
                                color: kUIDarkText,
                                fontSize: getHeight(context, 20),
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.4),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18, 0, 18, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Actual Price",
                            style: TextStyle(
                                color: kUIDarkText,
                                fontSize: getHeight(context, 22),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2),
                          ),
                        ),
                        Container(
                          width: 80,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: priceController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixText: "₹ ",
                              hintText: "Price",
                              hintStyle: TextStyle(
                                  color: kUIDarkText.withOpacity(0.7),
                                  fontSize: getHeight(context, 20),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.4),
                            ),
                            cursorColor: Colors.grey,
                            onChanged: (value) {
                              if (mounted) setState(() => price = value);
                            },
                            style: TextStyle(
                                color: kUIDarkText,
                                fontSize: getHeight(context, 20),
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.4),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVariation(BuildContext context, Variation variation) {
    return Slidable(
      key: ValueKey(
        variation.toString(),
      ),
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (mounted)
              setState(() {
                variations.remove(variation);
              });
          },
          child: Container(
            margin: EdgeInsets.only(left: 12),
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: kUIAccent),
            child: Icon(Icons.delete, color: kUILightText, size: 32),
          ),
        )
      ],
      child: Container(
        height: 76,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(text: variation.name),
                onChanged: (value) => variations[variations.indexOf(variation)]
                    .name = value.trim(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Name",
                  hintStyle: TextStyle(
                      color: kUIDarkText.withOpacity(0.7),
                      fontSize: getHeight(context, 22),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2),
                ),
                style: TextStyle(
                    color: kUIDarkText,
                    fontSize: getHeight(context, 22),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2),
              ),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ...List.generate(
                variation.options.length,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          final TextEditingController labelController =
                              TextEditingController(
                                  text: variation.options[index].label);

                          _buildVariationDialog(
                              labelController, variation, index);
                        },
                        onLongPress: () {
                          if (mounted)
                            setState(() {
                              variations[variations.indexOf(variation)]
                                          .options
                                          .length >
                                      1
                                  ? variations[variations.indexOf(variation)]
                                      .options
                                      .removeAt(index)
                                  : variations.remove(variation);
                            });
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(2, 0, 2, 4),
                          width: 32,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: 0 == index
                                ? Border.all(color: Colors.grey[400], width: 2)
                                : null,
                          ),
                          child: Center(
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: variation.options[index].color ??
                                  Colors.grey[400],
                              child: variation.options[index].color == null
                                  ? Text(
                                      variation.options[index].label[0]
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: kUIDarkText),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      Text(variation.options[index].label),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (mounted)
                    setState(() {
                      variations[variations.indexOf(variation)].options.add(
                            Option(label: "Label"),
                          );
                    });
                },
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.add),
                  ),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }

  void _addProduct(BuildContext context, String title, Product product,
      List<DocumentReference> tabs, List<Map> tabsData, int currentTab) async {
    List<String> urls =
        product != null ? product.images.map((e) => e.url).toList() : [];
    bool noError = true;

    for (File file in imageFiles) {
      try {
        TaskSnapshot task = await storage
            .ref()
            .child(
                "Products/$title/${tabsData[currentTab]["name"].split("\\n").join(" ")}/file-${Timestamp.now().toDate()}.jpeg")
            .putFile(file);

        String url = await task.ref.getDownloadURL();

        urls.add(url);
        file.delete();
      } catch (e) {
        noError = false;
      }
    }

    if (noError) {
      DocumentSnapshot category = await tabs[currentTab].parent.parent.get();
      int categoryId = category.get("uId");
      QuerySnapshot query = await tabs[currentTab].collection("products").get();

      int maxId = 0;

      query.docs.forEach((element) {
        int currId = int.parse(element.data()["uId"].split("/").last);
        if (currId > maxId) maxId = currId;
      });

      if (product != null) {
        QuerySnapshot query = await tabs[currentTab]
            .collection("products")
            .where("uId", isEqualTo: product.uId)
            .get();

        await query.docs.first.reference.update({
          "uId": "$categoryId/${tabsData[currentTab]["uId"]}/${maxId + 1}",
          "imgs": urls,
          "mrp": double.parse(mrp),
          "price": double.parse(price),
          "name": name.trim(),
          "variations": variations
              .map(
                (e) => e.toJson(),
              )
              .toList()
        });

        query = await database
            .collection("products")
            .where("uId", isEqualTo: product.uId)
            .get();

        await query.docs.first.reference.update({
          "uId": "$categoryId/${tabsData[currentTab]["uId"]}/${maxId + 1}",
          "imgs": urls,
          "mrp": double.parse(mrp),
          "price": double.parse(price),
          "name": name.trim(),
          "variations": variations
              .map(
                (e) => e.toJson(),
              )
              .toList()
        });
      } else {
        await tabs[currentTab].collection("products").add({
          "uId": "$categoryId/${tabsData[currentTab]["uId"]}/${maxId + 1}",
          "imgs": urls,
          "mrp": double.parse(mrp),
          "price": double.parse(price),
          "name": name.trim(),
          "variations": variations
              .map(
                (e) => e.toJson(),
              )
              .toList()
        });

        await database.collection("products").add({
          "uId": "$categoryId/${tabsData[currentTab]["uId"]}/${maxId + 1}",
          "imgs": urls,
          "mrp": double.parse(mrp),
          "price": double.parse(price),
          "name": name.trim(),
          "variations": variations
              .map(
                (e) => e.toJson(),
              )
              .toList()
        });
      }
    } else {
      Scaffold.of(context).removeCurrentSnackBar();
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

  void _buildVariationDialog(
      TextEditingController labelController, Variation variation, int index) {
    showDialog(
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          if (mounted)
            setState(() {
              if (variation.options[index].label != labelController.text &&
                  labelController.text != "") {
                variations[variations.indexOf(variation)].options[index].label =
                    labelController.text.trim();
              }
            });
          return true;
        },
        child: RoundedAlertDialog(
          title: "Edit Option",
          widgets: [
            TextField(
              controller: labelController,
              decoration: kInputDialogDecoration.copyWith(
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => labelController.clear(),
                ),
              ),
            ),
            SizedBox(height: 12),
            BlockPicker(
                availableColors: colors,
                itemBuilder: (color, isCurrentColor, changeColor) {
                  final bool notTrans = color != Colors.transparent;
                  return Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: notTrans ? color : kUIColor,
                      boxShadow: notTrans
                          ? [
                              BoxShadow(
                                color: color != kUIColor && notTrans
                                    ? color.withOpacity(0.8)
                                    : Colors.grey[600],
                                offset: Offset(1, 2),
                                blurRadius: 5,
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: changeColor,
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          child: notTrans
                              ? AnimatedOpacity(
                                  duration: Duration(milliseconds: 210),
                                  opacity: isCurrentColor ? 1 : 0,
                                  child: Icon(
                                    Icons.done,
                                    color: useWhiteForeground(color)
                                        ? kUIColor
                                        : Colors.black,
                                  ),
                                )
                              : Icon(Icons.clear),
                        ),
                      ),
                    ),
                  );
                },
                pickerColor: variation.options[index].color ?? Colors.redAccent,
                onColorChanged: (color) {
                  if (color != Colors.transparent)
                    variations[variations.indexOf(variation)]
                        .options[index]
                        .color = color;
                  else
                    variations[variations.indexOf(variation)]
                        .options[index]
                        .color = null;
                })
          ],
          isExpanded: false,
          buttonsList: [
            AlertButton(
                title: "Done",
                onPressed: () {
                  Navigator.pop(context);
                  if (mounted)
                    setState(() {
                      if (variation.options[index].label !=
                          labelController.text) {
                        variations[variations.indexOf(variation)]
                            .options[index]
                            .label = labelController.text.trim();
                      }
                    });
                })
          ],
        ),
      ),
    );
  }

  void _buildDiscardChangesDialog(BuildContext context) async {
    FocusScope.of(context).requestFocus(
      FocusNode(),
    );

    showDialog(
      context: context,
      builder: (_) => RoundedAlertDialog(
        title: "Do you want to discard the changes?",
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
              Navigator.pop(context);
              Navigator.pop(context);
            },
            titleColor: kUIColor,
            title: "Yes",
          )
        ],
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
