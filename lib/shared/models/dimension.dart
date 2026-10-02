import 'size_unit.dart';

/// Dimension data model for use across the application.
///
/// Stored as an embedded JSON object (not its own PocketBase collection),
/// discriminated by a `type` field.
///
/// Every dimension also carries the [SizeUnit] its values are measured in
/// (`cm`/`m` for width and height, `m2` for area). It is stored as `unit` in
/// the JSON; records saved before units existed read as the kind's default.
///
/// A dimension declares which axis of the item is *variable* at order time —
/// the value a buyer enters and the sell price is multiplied by — and carries
/// the fixed counterpart axis, when the item has one. A roll of fabric, for
/// example, has a fixed height and is sold by width: [WidthDimension] with
/// `fixedHeight` set. Ordering "2" of it means 2 width units.
sealed class Dimension {
  const Dimension();

  /// Maps a JSON object into a strongly-typed [Dimension].
  ///
  /// The legacy `size` type (which stored both axes without saying which one
  /// was orderable) is read as a [WidthDimension] whose fixed counterpart is
  /// the stored height.
  factory Dimension.fromJson(Map<String, dynamic> json) {
    final unit = SizeUnit.fromValue(json['unit']);
    return switch (json['type']) {
      'width' => WidthDimension(
          fixedHeight: (json['height'] as num?)?.toDouble(),
          unit: unit ?? SizeUnit.cm,
        ),
      'height' => HeightDimension(
          fixedWidth: (json['width'] as num?)?.toDouble(),
          unit: unit ?? SizeUnit.cm,
        ),
      'area' => AreaDimension(unit: unit ?? SizeUnit.m2),
      'size' => WidthDimension(
          fixedHeight: (json['height'] as num?)?.toDouble(),
          unit: unit ?? SizeUnit.cm,
        ),
      _ => throw ArgumentError('Unknown dimension type: ${json['type']}'),
    };
  }

  /// The kind of this dimension, for use where a `switch` on the type itself
  /// would be overkill (dropdowns, segmented buttons, labels).
  DimensionKind get kind;

  /// The unit this dimension's values are measured in.
  SizeUnit get unit;

  /// Converts this [Dimension] back into a JSON map.
  Map<String, dynamic> toJson();
}

/// The variable axis of a [Dimension] — what the buyer enters at order time.
enum DimensionKind {
  width('width'),
  height('height'),
  area('area');

  const DimensionKind(this.value);

  /// The raw value stored in PocketBase's `type` discriminator.
  final String value;

  /// The units an item sold along this axis can be measured in.
  List<SizeUnit> get allowedUnits => switch (this) {
        DimensionKind.width || DimensionKind.height => const [SizeUnit.cm, SizeUnit.m],
        DimensionKind.area => const [SizeUnit.m2],
      };

  /// The unit pre-selected when none has been chosen.
  SizeUnit get defaultUnit => allowedUnits.first;
}

/// Item sold by width; [fixedHeight] (in cm) is the same for every order.
class WidthDimension extends Dimension {
  final double? fixedHeight;

  @override
  final SizeUnit unit;

  const WidthDimension({this.fixedHeight, this.unit = SizeUnit.cm});

  @override
  DimensionKind get kind => DimensionKind.width;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': DimensionKind.width.value,
      'unit': unit.value,
      if (fixedHeight != null) 'height': fixedHeight,
    };
  }
}

/// Item sold by height; [fixedWidth] (in cm) is the same for every order.
class HeightDimension extends Dimension {
  final double? fixedWidth;

  @override
  final SizeUnit unit;

  const HeightDimension({this.fixedWidth, this.unit = SizeUnit.cm});

  @override
  DimensionKind get kind => DimensionKind.height;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': DimensionKind.height.value,
      'unit': unit.value,
      if (fixedWidth != null) 'width': fixedWidth,
    };
  }
}

/// Item sold by area (m²); there is no fixed counterpart axis — the single
/// value the buyer enters is the whole quantity.
class AreaDimension extends Dimension {
  @override
  final SizeUnit unit;

  const AreaDimension({this.unit = SizeUnit.m2});

  @override
  DimensionKind get kind => DimensionKind.area;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': DimensionKind.area.value, 'unit': unit.value};
  }
}
