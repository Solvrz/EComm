import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:suneel_printer/components/alert_button.dart';
import 'package:suneel_printer/components/rounded_alert_dialog.dart';
import 'package:suneel_printer/constant.dart';
import 'package:suneel_printer/models/product.dart';
import 'package:suneel_printer/screens/product.dart';

bool editMode = false;

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    CategoryArguments args = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kUIColor,
        resizeToAvoidBottomInset: false,
        floatingActionButton: admin
            ? Builder(
                builder: (BuildContext context) => FloatingActionButton(
                      elevation: 10,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.add, color: kUIAccent, size: 30),
                      onPressed: () async {
                        final TextEditingController name =
                            TextEditingController();
                        final TextEditingController price =
                            TextEditingController();

                        await showDialog(
                          context: context,
                          builder: (_) => RoundedAlertDialog(
                              titleSize: 22,
                              title: "Add Product",
                              centerTitle: true,
                              isExpanded: false,
                              otherWidgets: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextField(
                                    maxLines: 2,
                                    minLines: 1,
                                    controller: name,
                                    decoration: kInputDialogDecoration.copyWith(
                                        hintText: "Name"),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextField(
                                    maxLines: 1,
                                    minLines: 1,
                                    keyboardType: TextInputType.number,
                                    controller: price,
                                    decoration: kInputDialogDecoration.copyWith(
                                        hintText: "Price"),
                                  ),
                                ),
                              ],
                              buttonsList: [
                                AlertButton(
                                    title: "Add Image",
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();

                                      String fName = name.text;
                                      String fPrice = price.text;

                                      name.clear();
                                      price.clear();

                                      if (fName != "" && fPrice != "") {
                                        Navigator.pop(context);

                                        List<String> urls = [];
                                        FilePickerResult result =
                                            await FilePicker.platform.pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: [
                                                  "png",
                                                  "jpg"
                                                ],
                                                allowMultiple: true);

                                        List<File> compFiles = [];

                                        for (String path in result.paths) {
                                          File file = File(path);
                                          List<String> splits =
                                              file.absolute.path.split("/");

                                          compFiles.add(
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
                                          ));
                                        }

                                        for (File file in compFiles) {
                                          String ext = file.path
                                              .split("/")
                                              .last
                                              .split(".")
                                              .last;

                                          if (!["png", "jpg" "jpeg"]
                                              .contains(ext)) {
                                            Scaffold.of(context)
                                                .removeCurrentSnackBar();
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                elevation: 10,
                                                backgroundColor: kUIAccent,
                                                content: Text(
                                                  "This image couldn't be uploaded",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );

                                            return;
                                          }

                                          Scaffold.of(context)
                                              .removeCurrentSnackBar();
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            elevation: 10,
                                            backgroundColor: kUIAccent,
                                            content: Text(
                                              "Uploading...",
                                              textAlign: TextAlign.center,
                                            ),
                                          ));

                                          final StorageReference
                                              storageReference =
                                              FirebaseStorage.instance.ref().child(
                                                  "Products/${args.title}/${args.tabsData[_currentTab]["name"].split("\\n").join(" ")}/file-${Timestamp.now().toDate()}.pdf");
                                          final StorageTaskSnapshot snapshot =
                                              await storageReference
                                                  .putFile(file)
                                                  .onComplete;

                                          if (snapshot.error == null) {
                                            final String url = await snapshot
                                                .ref
                                                .getDownloadURL();

                                            urls.add(url);
                                            file.delete();

                                            QuerySnapshot query = await args
                                                .tabs[_currentTab]
                                                .collection("products")
                                                .get();

                                            int maxId = 0;

                                            query.docs.forEach((element) {
                                              int currId = int.parse(element
                                                  .data()["uId"]
                                                  .split("/")
                                                  .last);
                                              if (currId > maxId)
                                                maxId = currId;
                                            });

                                            await args.tabs[_currentTab]
                                                .collection("products")
                                                .add({
                                              "uId": "1/1/${maxId + 1}",
                                              "imgs": urls,
                                              "price": double.parse(fPrice),
                                              "name": fName
                                            });

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
                                      } else {
                                        FocusScope.of(context).unfocus();
                                        Navigator.pop(context);

                                        Scaffold.of(context)
                                            .removeCurrentSnackBar();
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            elevation: 10,
                                            backgroundColor: kUIAccent,
                                            content: Text(
                                              "Enter a Name & Price",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }
                                    })
                              ]),
                        );
                      },
                    ))
            : null,
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back_ios,
                        color: kUIDarkText, size: 26),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(args.title,
                        style: TextStyle(
                            fontSize: 24,
                            color: kUIDarkText,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                GestureDetector(
                  onTap: admin
                      ? () => setState(() => editMode = !editMode)
                      : () => Navigator.pushNamed(context, "/cart"),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                        admin
                            ? Icons.edit_outlined
                            : Icons.shopping_cart_outlined,
                        size: 26),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: kUIColor,
                border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.grey[400], width: 1))),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(args.tabs.length, (int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: () {
                          if (index == _currentTab) return;
                          setState(() {
                            _currentTab = index;
                          });
                        },
                        child: AnimatedDefaultTextStyle(
                          child: Text(
                            args.tabsData[index]["name"]
                                .split("\\n")
                                .join("\n"),
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(milliseconds: 150),
                          style: TextStyle(
                              fontSize: index == _currentTab ? 16 : 14,
                              fontWeight: index == _currentTab
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: index == _currentTab
                                  ? kUIDarkText
                                  : Colors.grey[600]),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: args.tabs[_currentTab].collection("products").snapshots(),
            builder: (context, future) {
              if (future.hasData) {
                if (future.data.docs.isNotEmpty) {
                  return Expanded(
                      child: ProductList(
                          products: future.data.docs
                              .map<Product>((DocumentSnapshot e) =>
                                  Product.fromJson(e.data()))
                              .toList()));
                } else {
                  return Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: EmptyListWidget(
                        title: "No Product",
                        subTitle: "No Product Available Yet",
                      ),
                    ),
                  );
                }
              } else {
                return Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Center(child: Text("Loading...")));
              }
            },
          ),
        ]),
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  ProductList({@required this.products});

  final List<Product> products;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 0.8,
      children: List.generate(widget.products.length,
          (index) => ProductCard(widget.products[index])),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  ProductCard(this.product);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 2;
    final double height = width / 0.8;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/product",
            arguments: ProductArguments(widget.product));
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(12, 24, 12, 0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400], width: 0.5)),
          child: Column(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (admin)
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () {},
                          child: AnimatedIcon(
                            icon: AnimatedIcons.menu_close,
                            progress: AlwaysStoppedAnimation<double>(0),
                          ))),
//                if (admin && editMode)
//                  Align(
//                    alignment: Alignment.centerRight,
//                    child: GestureDetector(
//                      onTap: () {
//                              showDialog(
//                                context: context,
//                                builder: (_) => RoundedAlertDialog(
//                                  title: "Do you want to delete this Product?",
//                                  buttonsList: [
//                                    FlatButton(
//                                      onPressed: () => Navigator.pop(context),
//                                      textColor: kUIAccent,
//                                      child: Text("No"),
//                                    ),
//                                    FlatButton(
//                                      onPressed: () async {
//                                        Navigator.pop(context);
//
//                                        List<String> uIds =
//                                            widget.product.uId.split("/");
//
//                                        FirebaseStorage.instance
//                                            .getReferenceFromUrl(
//                                                widget.product.img.url)
//                                            .then((value) => value.delete());
//
//                                        QuerySnapshot category = await database
//                                            .collection("categories")
//                                            .where("uId",
//                                                isEqualTo: int.parse(uIds[0]))
//                                            .get();
//
//                                        QuerySnapshot tab = await category
//                                            .docs.first.reference
//                                            .collection("tabs")
//                                            .where("uId",
//                                                isEqualTo: int.parse(uIds[1]))
//                                            .get();
//
//                                        QuerySnapshot product = await tab
//                                            .docs.first.reference
//                                            .collection("products")
//                                            .where("uId",
//                                                isEqualTo: widget.product.uId)
//                                            .get();
//
//                                        product.docs.first.reference.delete();
//                                      },
//                                      textColor: kUIAccent,
//                                      child: Text("Yes"),
//                                    ),
//                                  ],
//                                ),
//                              );
//                            },
//                      child: Icon(
//                        Icons.delete,
//                        color: kUIDarkText.withOpacity(0.7),
//                      ),
//                    ),
//                  ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: widget.product.img != null
                        ? Container(
                            height: height / 1.8,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[600],
                                  blurRadius: 12,
                                  offset: Offset(2, 2))
                            ]),
                            child: Image(image: widget.product.img))
                        : Container(
                            height: height / 2,
                            child: Center(
                              child: Text("No Image Provided"),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "₹ ${widget.product.price}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "sans-serif-condensed"),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: AutoSizeText(
                    widget.product.name,
                    maxLines: 2,
                    minFontSize: 18,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        letterSpacing: 0.3, fontFamily: "sans-serif-condensed"),
                  ),
                ),
              ]),
            ],
          )),
    );
  }
}

class CategoryArguments {
  final String title;
  final List<Map> tabsData;
  final List<DocumentReference> tabs;
  final DocumentReference docRef;

  CategoryArguments(this.title, this.tabsData, this.tabs, this.docRef);
}
