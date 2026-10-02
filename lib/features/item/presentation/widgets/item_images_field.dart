import 'package:flutter/material.dart';

import 'package:inventory_app/features/item/data/item_image_service.dart';
import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/di/locator.dart';

/// Thumbnails of an item's pictures — stored ones (by file name) and newly
/// picked ones (bytes) — each with a remove button, plus the add button.
///
/// Stateless: the form owns the lists and decides what to do on add/remove.
class ItemImagesField extends StatelessWidget {
  const ItemImagesField({
    super.key,
    required this.itemId,
    required this.storedNames,
    required this.newImages,
    required this.canAddMore,
    required this.onAdd,
    required this.onRemoveStored,
    required this.onRemoveNew,
  });

  /// Empty when creating, so there are no stored pictures to build URLs for.
  final String itemId;
  final List<String> storedNames;
  final List<NewItemImage> newImages;
  final bool canAddMore;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemoveStored;
  final ValueChanged<NewItemImage> onRemoveNew;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final images = getIt<ItemImageService>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (storedNames.isNotEmpty || newImages.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final name in storedNames)
                _Thumb(
                  onRemove: () => onRemoveStored(name),
                  child: Image.network(
                    images.url(itemId, name, thumb: '300x300').toString(),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined),
                  ),
                ),
              for (final image in newImages)
                _Thumb(
                  onRemove: () => onRemoveNew(image),
                  child: Image.memory(image.bytes, fit: BoxFit.cover),
                ),
            ],
          ),
        if (canAddMore) ...[
          if (storedNames.isNotEmpty || newImages.isNotEmpty) const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(l10n.itemFormAddImagesCta),
          ),
        ],
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.child, required this.onRemove});

  final Widget child;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 84,
      height: 84,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(14), child: child),
          PositionedDirectional(
            top: 2,
            end: 2,
            child: InkWell(
              onTap: onRemove,
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: colorScheme.error, shape: BoxShape.circle),
                child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
