import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:inventory_app/features/item/data/item_image_service.dart';
import 'package:inventory_app/shared/di/locator.dart';

/// Horizontal strip of an item's pictures; tapping one opens a full-screen
/// gallery at that picture, where you swipe between pictures and pinch to
/// zoom.
class ItemImageStrip extends StatelessWidget {
  const ItemImageStrip({super.key, required this.itemId, required this.imageNames});

  final String itemId;
  final List<String> imageNames;

  @override
  Widget build(BuildContext context) {
    final images = getIt<ItemImageService>();
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageNames.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => ItemImageGallery.show(
              context,
              itemId: itemId,
              imageNames: imageNames,
              initialIndex: index,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  images.url(itemId, imageNames[index], thumb: '300x300').toString(),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Full-screen, swipeable, zoomable gallery of an item's pictures.
class ItemImageGallery extends StatefulWidget {
  const ItemImageGallery({
    super.key,
    required this.itemId,
    required this.imageNames,
    this.initialIndex = 0,
  });

  final String itemId;
  final List<String> imageNames;
  final int initialIndex;

  static Future<void> show(
    BuildContext context, {
    required String itemId,
    required List<String> imageNames,
    int initialIndex = 0,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => ItemImageGallery(
          itemId: itemId,
          imageNames: imageNames,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  State<ItemImageGallery> createState() => _ItemImageGalleryState();
}

class _ItemImageGalleryState extends State<ItemImageGallery> {
  late final PageController _controller = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = getIt<ItemImageService>();
    final count = widget.imageNames.length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_index + 1} / $count'),
      ),
      body: PhotoViewGallery.builder(
        pageController: _controller,
        itemCount: count,
        onPageChanged: (i) => setState(() => _index = i),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        loadingBuilder: (_, _) => const Center(child: CircularProgressIndicator()),
        builder: (context, index) => PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(
            images.url(widget.itemId, widget.imageNames[index]).toString(),
          ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 4,
          errorBuilder: (_, _, _) => const Center(
            child: Icon(Icons.broken_image_outlined, color: Colors.white, size: 48),
          ),
        ),
      ),
    );
  }
}
