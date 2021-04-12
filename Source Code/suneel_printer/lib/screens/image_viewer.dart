import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:suneel_printer/components/custom_app_bar.dart';
import 'package:suneel_printer/constant.dart';

// ignore: must_be_immutable
class ImageScreen extends StatefulWidget {
  final String title;
  final List images;
  int currentIndex;

  ImageScreen(
      {@required this.title,
      @required this.images,
      @required this.currentIndex});

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        appBar: CustomAppBar(
            parent: context,
            title: widget.title,
            color: Colors.grey[900],
            textColor: kUIColor),
        body: Container(
          child: Stack(children: [
            PhotoViewGallery.builder(
              backgroundDecoration: BoxDecoration(color: Colors.grey[900]),
              scrollPhysics: ClampingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: 1.6,
                  imageProvider:
                      CachedNetworkImageProvider(widget.images[index]),
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                );
              },
              itemCount: widget.images.length,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes,
                  ),
                ),
              ),
              pageController: _pageController,
              onPageChanged: (page) =>
                  setState(() => widget.currentIndex = page),
            ),
            if (widget.currentIndex > 0)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Icon(Icons.arrow_left, size: 30, color: kUIColor),
              ),
            if (widget.currentIndex < widget.images.length - 1)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Icon(Icons.arrow_right, size: 30, color: kUIColor),
              ),
          ]),
        ),
      ),
    );
  }
}
