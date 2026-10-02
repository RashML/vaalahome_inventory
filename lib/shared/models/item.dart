import 'package:pocketbase/pocketbase.dart';

import 'dimension.dart';
import 'price.dart';

/// Item data model for use across the application.
class Item {
  static const String collection = 'items';

  /// The record ID.
  final String id;

  /// The item name.
  final String name;

  /// The ID of the [Bundle] this item belongs to, if any.
  final String? bundleId;

  /// The ID of the [Company] this item belongs to.
  final String companyId;

  /// The item's size.
  final Dimension size;

  /// The item's color code, if any.
  final String? colorCode;

  /// File names of the item's pictures (see `ItemImageService` for URLs).
  final List<String> imageNames;

  /// The price this item was bought for.
  final Price buyPrice;

  /// The price this item is sold for.
  final Price sellPrice;

  const Item({
    required this.id,
    required this.name,
    this.bundleId,
    required this.companyId,
    required this.size,
    this.colorCode,
    this.imageNames = const [],
    required this.buyPrice,
    required this.sellPrice,
  });

  /// Maps a PocketBase [RecordModel] into a strongly-typed [Item].
  factory Item.fromRecord(RecordModel record) {
    final bundleId = record.getStringValue('bundle');
    final colorCode = record.getStringValue('colorCode');
    return Item(
      id: record.id,
      name: record.getStringValue('name'),
      bundleId: bundleId.isEmpty ? null : bundleId,
      companyId: record.getStringValue('company'),
      size: Dimension.fromJson(
        record.data['size'] as Map<String, dynamic>,
      ),
      colorCode: colorCode.isEmpty ? null : colorCode,
      imageNames: record.getListValue<String>('images'),
      buyPrice: Price.fromJson(
        record.data['buyPrice'] as Map<String, dynamic>,
      ),
      sellPrice: Price.fromJson(
        record.data['sellPrice'] as Map<String, dynamic>,
      ),
    );
  }

  /// Converts this [Item] back into a JSON map for sending data to
  /// PocketBase.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      if (bundleId != null) 'bundle': bundleId,
      'company': companyId,
      'size': size.toJson(),
      if (colorCode != null) 'colorCode': colorCode,
      'buyPrice': buyPrice.toJson(),
      'sellPrice': sellPrice.toJson(),
    };
  }
}
