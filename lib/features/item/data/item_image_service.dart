import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import 'package:inventory_app/shared/models/item.dart';

/// A picture the user picked, not yet uploaded.
class NewItemImage {
  const NewItemImage({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;
}

/// What the user changed about an item's pictures in the form.
class ItemImageChanges {
  const ItemImageChanges({this.added = const [], this.removed = const []});

  /// Pictures to upload.
  final List<NewItemImage> added;

  /// File names of already-stored pictures to delete.
  final List<String> removed;

  bool get isEmpty => added.isEmpty && removed.isEmpty;
}

/// Builds URLs for, uploads and deletes an item's pictures.
///
/// Kept apart from `Repository<Item>`, which only deals in the item's JSON
/// fields: files need a multipart request.
class ItemImageService {
  ItemImageService(this._pb);

  final PocketBase _pb;

  /// URL of [filename] on item [itemId]; pass [thumb] (e.g. `300x300`, a size
  /// declared on the field) for a small version.
  Uri url(String itemId, String filename, {String? thumb}) {
    final record = RecordModel.fromJson({
      'id': itemId,
      'collectionName': Item.collection,
    });
    return _pb.files.getURL(record, filename, thumb: thumb);
  }

  /// Uploads [changes] to item [itemId] in a single request.
  Future<void> apply(String itemId, ItemImageChanges changes) async {
    if (changes.isEmpty) return;
    await _pb.collection(Item.collection).update(
      itemId,
      body: {if (changes.removed.isNotEmpty) 'images-': changes.removed},
      files: [
        for (final image in changes.added)
          http.MultipartFile.fromBytes('images', image.bytes, filename: image.name),
      ],
    );
  }
}
