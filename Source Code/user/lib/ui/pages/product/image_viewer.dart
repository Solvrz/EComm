import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '/config/constant.dart';
import '/ui/widgets/custom_app_bar.dart';

// ignore: must_be_immutable
class ImagePage extends StatefulWidget {
  final String title;
  final List<dynamic> images;

  int currentIndex;

  ImagePage({
    super.key,
    required this.title,
    required this.images,
    required this.currentIndex,
  });

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  late PageController _pageController;

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
          context: context,
          title: widget.title,
          color: Colors.grey[900],
          textColor: theme.colorScheme.background,
        ),
        body: Stack(
          children: [
            PhotoViewGallery.builder(
              backgroundDecoration: BoxDecoration(color: Colors.grey[900]),
              scrollPhysics: const ClampingScrollPhysics(),
              builder: (context, index) {
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
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
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
                child: Icon(
                  Icons.arrow_left,
                  size: 30,
                  color: theme.colorScheme.background,
                ),
              ),
            if (widget.currentIndex < widget.images.length - 1)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Icon(
                  Icons.arrow_right,
                  size: 30,
                  color: theme.colorScheme.background,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
