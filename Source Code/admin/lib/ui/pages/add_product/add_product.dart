import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '/config/constant.dart';
import '/models/product.dart';
import '/models/variation.dart';
import '/ui/widgets/alert_button.dart';
import '/ui/widgets/custom_app_bar.dart';
import '/ui/widgets/rounded_alert_dialog.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool posting = false;

  String name = "";
  String price = "";
  String mrp = "";

  bool featured = false;

  List<Color> colors = [
    const Color(0xFFF44336),
    const Color(0xFF2196F3),
    const Color(0xFF4CAF50),
    const Color(0xFFFFEB3B),
    const Color(0xFF03A9F4),
    const Color(0xFF8BC34A),
    const Color(0xFFFFC107),
    const Color(0xFFFF4081),
    const Color(0xFF9C27B0),
    const Color(0xFF000000),
    const Color(0xFF9E9E9E),
    const Color(0xFFFFFFFF),
    Colors.transparent,
  ];

  List<Image> images = [];
  List<File> imageFiles = [];
  List<Image> deletedImages = [];

  List<Variation> variations = [];

  int _currentImage = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController mrpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AddProductArguments args =
        ModalRoute.of(context)!.settings.arguments! as AddProductArguments;

    if (args.product != null && name == "") {
      name = args.product!.name;
      nameController.text = name;

      price = args.product!.price;
      priceController.text = price;

      mrp = args.product!.mrp;
      mrpController.text = mrp;

      featured = args.product!.featured;
      variations = args.product!.variations;

      images = args.product!.images
          .map((e) => Image(image: CachedNetworkImageProvider(e)))
          .toList();
    }

    return PopScope(
      canPop: !posting,
      onPopInvoked: (poped) async {
        if (!poped) {
          if (context.mounted) await _buildDiscardChangesDialog(context);
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            context: context,
            title: args.product != null ? "Edit" : "Preview",
            leading: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: posting
                  ? null
                  : () {
                      if (context.mounted) _buildDiscardChangesDialog(context);
                    },
              child: GestureDetector(
                onTap: () {
                  if (context.mounted) Navigator.pop(context);
                },
                child: Padding(
                  padding: screenSize.all(10),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: posting
                        ? Colors.grey[200]
                        : Theme.of(context).colorScheme.onPrimary,
                    size: 30,
                  ),
                ),
              ),
            ),
            trailing: [
              Builder(
                builder: (context) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: posting ? null : post(args),
                    child: Padding(
                      padding: screenSize.all(16),
                      child: Center(
                        child: Text(
                          "Post",
                          style: TextStyle(
                            color: posting
                                ? Colors.grey[200]
                                : Theme.of(context).primaryColor,
                            fontSize: screenSize.height(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: screenSize.height(800),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: screenSize.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: screenSize.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: nameController,
                                  cursorColor: Colors.grey,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    focusedBorder: const OutlineInputBorder(),
                                    errorBorder: InputBorder.none,
                                    hintText: "Product Name",
                                    hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.7),
                                      fontSize: screenSize.height(28),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "sans-serif-condensed",
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (context.mounted) {
                                      setState(() => name = value);
                                    }
                                  },
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: screenSize.height(28),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "sans-serif-condensed",
                                  ),
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  final FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ["png", "jpg"],
                                    allowMultiple: true,
                                  );

                                  final List<Image> compImages = [];
                                  final List<File> compFiles = [];

                                  for (final String? path in result!.paths) {
                                    final File file = File(path!);
                                    final List<String> splits =
                                        file.absolute.path.split("/");

                                    final XFile? compFile =
                                        await FlutterImageCompress
                                            .compressAndGetFile(
                                      file.absolute.path,
                                      "${splits.getRange(0, splits.length - 1).join("/")}/Compressed${Timestamp.now().toDate()}.jpeg",
                                    );
                                    compFiles.add(File(compFile!.path));
                                    compImages
                                        .add(Image.file(File(compFile.path)));
                                  }

                                  images.addAll(compImages);
                                  imageFiles.addAll(compFiles);

                                  if (context.mounted) {
                                    setState(() {
                                      _currentImage = 0;
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: screenSize.all(8),
                                  child: Icon(
                                    Icons.add_photo_alternate,
                                    color: Theme.of(context).primaryColor,
                                    size: 34,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width,
                          child: images.isNotEmpty
                              ? Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          padding: screenSize.all(8),
                                          child: CarouselSlider(
                                            items: images
                                                .map<Widget>((image) => image)
                                                .toList(),
                                            options: CarouselOptions(
                                              autoPlay: images.length > 1,
                                              enlargeCenterPage: true,
                                              aspectRatio:
                                                  screenSize.aspectRatio(2),
                                              onPageChanged: (index, reason) {
                                                if (context.mounted) {
                                                  setState(() {
                                                    _currentImage = index;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        if (images.length > 1)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                              images.length,
                                              (index) => AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 400,
                                                ),
                                                width: _currentImage == index
                                                    ? 16
                                                    : 8,
                                                height: _currentImage == index
                                                    ? 6
                                                    : 8,
                                                margin: screenSize.symmetric(
                                                  vertical: 10,
                                                  horizontal: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    15,
                                                  ),
                                                  color: _currentImage == index
                                                      ? const Color.fromRGBO(
                                                          0,
                                                          0,
                                                          0,
                                                          0.9,
                                                        )
                                                      : const Color.fromRGBO(
                                                          0,
                                                          0,
                                                          0,
                                                          0.4,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Positioned(
                                      right: 25,
                                      bottom: 10,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          final List<Widget> imageWidgets =
                                              List.generate(
                                            images.length,
                                            (index) => GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: () {
                                                setState(
                                                  () => deletedImages
                                                      .add(images[index]),
                                                );

                                                setState(
                                                  () => images.removeAt(index),
                                                );

                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: screenSize.height(100),
                                                width: 150,
                                                padding: screenSize.all(8),
                                                margin: screenSize.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20,
                                                  ),
                                                  color: Colors.grey[200],
                                                ),
                                                child: images[index],
                                              ),
                                            ),
                                          );

                                          showDialog(
                                            context: context,
                                            builder: (_) => PopScope(
                                              onPopInvoked: (_) async {
                                                setState(() {});
                                              },
                                              child: RoundedAlertDialog(
                                                title:
                                                    "Select the Images to Delete",
                                                widgets: [
                                                  Column(
                                                    children: imageWidgets,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          size: 30,
                                          color: Colors.grey[700],
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
                                      fontSize: screenSize.height(20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 2, height: 12),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: screenSize.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ...variations.map(
                              (variation) => Padding(
                                padding: screenSize.symmetric(vertical: 2),
                                child: _buildVariation(context, variation),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: screenSize.symmetric(horizontal: 8),
                    child: AlertButton(
                      title: "Add Variation",
                      onPressed: () {
                        if (context.mounted) {
                          setState(() {
                            variations.add(
                              Variation(
                                name: "",
                                options: [
                                  Option(label: "Label"),
                                ],
                              ),
                            );
                          });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: screenSize.fromLTRB(18, 20, 32, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Featured",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: screenSize.height(22),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: CupertinoSwitch(
                            value: featured,
                            onChanged: (value) {
                              setState(() {
                                featured = value;
                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: screenSize.fromLTRB(18, 0, 18, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "MRP",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: screenSize.height(22),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: mrpController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              prefixText: "$CURRENCY ",
                              hintText: "MRP",
                              hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.7),
                                fontSize: screenSize.height(20),
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.4,
                              ),
                            ),
                            onChanged: (value) {
                              if (context.mounted) {
                                setState(() => mrp = value);
                              }
                            },
                            cursorColor: Colors.grey,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: screenSize.height(20),
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: screenSize.fromLTRB(18, 0, 18, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Actual Price",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: screenSize.height(22),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: priceController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              prefixText: "$CURRENCY ",
                              hintText: "Price",
                              hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.7),
                                fontSize: screenSize.height(20),
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.4,
                              ),
                            ),
                            cursorColor: Colors.grey,
                            onChanged: (value) {
                              if (context.mounted) {
                                setState(() => price = value);
                              }
                            },
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: screenSize.height(20),
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),
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

  void Function() post(AddProductArguments args) {
    if (name == "") {
      return () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 10,
              backgroundColor: Theme.of(context).primaryColor,
              content: const Text(
                "Name can't be Empty",
                textAlign: TextAlign.center,
              ),
            ),
          );
    }
    if (price == "") {
      return () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 10,
              backgroundColor: Theme.of(context).primaryColor,
              content: const Text(
                "Actual Price can't be Empty",
                textAlign: TextAlign.center,
              ),
            ),
          );
    }
    if (mrp == "") {
      return () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 10,
              backgroundColor: Theme.of(context).primaryColor,
              content: const Text(
                "MRP can't be Empty",
                textAlign: TextAlign.center,
              ),
            ),
          );
    }
    if (double.parse(price) > double.parse(mrp)) {
      return () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 10,
              backgroundColor: Theme.of(context).primaryColor,
              content: const Text(
                "Actual Price can't be more than MRP",
                textAlign: TextAlign.center,
              ),
            ),
          );
    } else {
      return () async {
        setState(() => posting = true);

        final List<String> urls = args.product != null
            ? args.product!.images
                .map(
                  (e) => e.toString(),
                )
                .toList()
            : [];
        bool noError = true;

        for (int i = 0; i < imageFiles.length; i++) {
          final File file = imageFiles[i];

          try {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 10,
                backgroundColor: Theme.of(context).primaryColor,
                content: Text(
                  "Uploading Image (${i + 1}/${imageFiles.length})",
                  textAlign: TextAlign.center,
                ),
              ),
            );

            final TaskSnapshot task = await storage
                .ref()
                .child(
                  "Products/${args.title}/${args.tabsData[args.currentTab]["name"].split("\\n").join(" ")}/file-${Timestamp.now().toDate()}.jpeg",
                )
                .putFile(file);

            final String url = await task.ref.getDownloadURL();

            urls.add(url);
            await file.delete();
          } catch (e) {
            noError = false;
          }
        }

        if (deletedImages.isNotEmpty) {
          for (int i = 0; i < deletedImages.length; i++) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  elevation: 10,
                  backgroundColor: Theme.of(context).primaryColor,
                  content: Text(
                    "Deleting Image (${i + 1}/${deletedImages.length})",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final String url = deletedImages[i]
                .image
                .toString()
                .split("(")[1]
                .split(",")[0]
                .split('"')[1];
            await CachedNetworkImage.evictFromCache(url);

            urls.removeWhere(
              (element) => element == url,
            );

            await storage
                .ref()
                .child(
                  url
                      .replaceAll(
                        RegExp(STORAGE),
                        '',
                      )
                      .replaceAll(
                        RegExp('%2F'),
                        '/',
                      )
                      .replaceAll(
                        RegExp(
                          r'(\?alt).*',
                        ),
                        '',
                      )
                      .replaceAll(
                        RegExp('%20'),
                        ' ',
                      )
                      .replaceAll(
                        RegExp('%3A'),
                        ':',
                      ),
                )
                .delete();
          }

          Timer(
              const Duration(
                milliseconds: 200,
              ), () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 10,
                backgroundColor: Theme.of(context).primaryColor,
                content: const Text(
                  "Deleted Images",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          });
        }

        if (noError) {
          if (imageFiles.isNotEmpty) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          }
          if (imageFiles.isNotEmpty) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  elevation: 10,
                  backgroundColor: Theme.of(context).primaryColor,
                  content: const Text(
                    "Uploaded Images",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          }

          final DocumentSnapshot category =
              await args.tabs[args.currentTab].parent.parent!.get();
          final int categoryId = category.get("uId");
          final QuerySnapshot query =
              await args.tabs[args.currentTab].collection("products").get();

          int maxId = 0;

          query.docs.forEach((element) {
            final int currId = int.parse(
              (element.data()! as Map)["uId"].split("/").last,
            );

            if (currId > maxId) {
              maxId = currId;
            }
          });

          final double doubleMrp = double.parse(mrp);
          final double doublePrice = double.parse(price);

          if (args.product != null) {
            QuerySnapshot query = await args.tabs[args.currentTab]
                .collection("products")
                .where(
                  "uId",
                  isEqualTo: args.product!.uId,
                )
                .get();

            await query.docs.first.reference.update({
              "uId": args.product!.uId,
              "imgs": urls,
              "mrp": doubleMrp,
              "price": doublePrice,
              "name": name.trim(),
              "featured": featured,
              "variations": variations
                  .map(
                    (e) => e.toJson(),
                  )
                  .toList(),
            });

            query = await firestore
                .collection("products")
                .where(
                  "uId",
                  isEqualTo: args.product!.uId,
                )
                .get();

            await query.docs.first.reference.update({
              "uId": args.product!.uId,
              "imgs": urls,
              "mrp": doubleMrp,
              "price": doublePrice,
              "name": name.trim(),
              "featured": featured,
              "variations": variations
                  .map(
                    (e) => e.toJson(),
                  )
                  .toList(),
            });
          } else {
            await args.tabs[args.currentTab].collection("products").add({
              "uId":
                  "$categoryId/${args.tabsData[args.currentTab]["uId"]}/${maxId + 1}",
              "imgs": urls,
              "mrp": doubleMrp,
              "price": doublePrice,
              "name": name.trim(),
              "featured": featured,
              "variations": variations
                  .map(
                    (e) => e.toJson(),
                  )
                  .toList(),
            });

            await firestore.collection("products").add({
              "uId":
                  "$categoryId/${args.tabsData[args.currentTab]["uId"]}/${maxId + 1}",
              "imgs": urls,
              "mrp": doubleMrp,
              "price": doublePrice,
              "name": name.trim(),
              "featured": featured,
              "variations": variations
                  .map(
                    (e) => e.toJson(),
                  )
                  .toList(),
            });
          }

          if (context.mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 10,
                backgroundColor: Theme.of(context).primaryColor,
                content: Text(
                  args.product != null
                      ? "Product Updated Successfully"
                      : "Product Added Successfully",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          Timer(
            const Duration(
              milliseconds: 400,
            ),
            () => Navigator.pop(context),
          );
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 10,
                backgroundColor: Theme.of(context).primaryColor,
                content: const Text(
                  "Sorry, The product couldn't be added",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }
      };
    }
  }

  Widget _buildVariation(BuildContext context, Variation variation) {
    return Slidable(
      key: ValueKey(
        variation.toString(),
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          Flexible(
            flex: 6,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (context.mounted) {
                  setState(() {
                    variations.remove(variation);
                  });
                }
              },
              child: Container(
                margin: screenSize.only(left: 12),
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
      child: Container(
        height: screenSize.height(85),
        padding: screenSize.symmetric(vertical: 12),
        child: Row(
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
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                    fontSize: screenSize.height(22),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: screenSize.height(22),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Row(
              children: [
                ...List.generate(
                  variation.options.length,
                  (index) => Padding(
                    padding: screenSize.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            final TextEditingController labelController =
                                TextEditingController(
                              text: variation.options[index].label,
                            );

                            showDialog(
                              context: context,
                              builder: (_) => PopScope(
                                onPopInvoked: (_) async {
                                  if (context.mounted) {
                                    setState(() {
                                      if (variation.options[index].label !=
                                              labelController.text &&
                                          labelController.text != "") {
                                        variations[variations
                                                    .indexOf(variation)]
                                                .options[index]
                                                .label =
                                            labelController.text.trim();
                                      }
                                    });
                                  }
                                },
                                child: RoundedAlertDialog(
                                  title: "Edit Option",
                                  widgets: [
                                    TextField(
                                      controller: labelController,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () =>
                                              labelController.clear(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    BlockPicker(
                                      availableColors: colors,
                                      itemBuilder:
                                          (color, isCurrentColor, changeColor) {
                                        final bool notTrans =
                                            color != Colors.transparent;
                                        return Container(
                                          margin: screenSize.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: notTrans
                                                ? color
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                            boxShadow: notTrans
                                                ? [
                                                    BoxShadow(
                                                      color: color !=
                                                                  Theme.of(
                                                                    context,
                                                                  )
                                                                      .colorScheme
                                                                      .background &&
                                                              notTrans
                                                          ? color
                                                              .withOpacity(0.8)
                                                          : Colors.grey[600]!,
                                                      offset:
                                                          const Offset(1, 2),
                                                      blurRadius: 5,
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: changeColor,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Container(
                                                child: notTrans
                                                    ? AnimatedOpacity(
                                                        duration:
                                                            const Duration(
                                                          milliseconds: 210,
                                                        ),
                                                        opacity: isCurrentColor
                                                            ? 1
                                                            : 0,
                                                        child: Icon(
                                                          Icons.done,
                                                          color:
                                                              useWhiteForeground(
                                                            color,
                                                          )
                                                                  ? Theme.of(
                                                                      context,
                                                                    )
                                                                      .colorScheme
                                                                      .background
                                                                  : Colors
                                                                      .black,
                                                        ),
                                                      )
                                                    : const Icon(Icons.clear),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      pickerColor:
                                          variation.options[index].color ??
                                              Colors.redAccent,
                                      onColorChanged: (color) {
                                        if (color != Colors.transparent) {
                                          variations[
                                                  variations.indexOf(variation)]
                                              .options[index]
                                              .color = color;
                                        } else {
                                          variations[
                                                  variations.indexOf(variation)]
                                              .options[index]
                                              .color = null;
                                        }
                                      },
                                    ),
                                  ],
                                  isExpanded: false,
                                  buttonsList: [
                                    AlertButton(
                                      title: "Done",
                                      onPressed: () {
                                        Navigator.pop(context);
                                        if (context.mounted) {
                                          setState(() {
                                            if (variation
                                                    .options[index].label !=
                                                labelController.text) {
                                              variations[variations
                                                          .indexOf(variation)]
                                                      .options[index]
                                                      .label =
                                                  labelController.text.trim();
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            if (context.mounted) {
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
                            }
                          },
                          child: Container(
                            margin: screenSize.fromLTRB(2, 4, 2, 4),
                            width: 32,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: 0 == index
                                  ? Border.all(
                                      color: Colors.grey[400]!,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                    variation.options[index].color ??
                                        Colors.grey[400],
                                child: variation.options[index].color == null
                                    ? Text(
                                        variation.options[index].label[0]
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        if (variation.options[index].label != "")
                          Text(variation.options[index].label),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (context.mounted) {
                      setState(() {
                        variations[variations.indexOf(variation)].options.add(
                              Option(label: "Label"),
                            );
                      });
                    }
                  },
                  child: Padding(
                    padding: screenSize.all(8),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _buildDiscardChangesDialog(BuildContext context) async {
    FocusScope.of(context).unfocus();

    await showDialog(
      context: context,
      builder: (_) => RoundedAlertDialog(
        title: "Do you want to discard the changes?",
        buttonsList: [
          AlertButton(
            onPressed: () {
              Navigator.pop(context);
            },
            title: "No",
          ),
          AlertButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            title: "Yes",
          ),
        ],
      ),
    );
  }
}

class AddProductArguments {
  final List<Map<dynamic, dynamic>> tabsData;
  final List<DocumentReference> tabs;
  final String title;
  final int currentTab;
  Product? product;

  AddProductArguments(
    this.tabsData,
    this.tabs,
    this.title,
    this.currentTab, {
    this.product,
  });
}
