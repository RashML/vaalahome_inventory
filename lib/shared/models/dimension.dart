/// Dimension data model for use across the application.
///
/// Stored as an embedded JSON object (not its own PocketBase collection),
/// discriminated by a `type` field.
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
    return switch (json['type']) {
      'width' => WidthDimension(fixedHeight: (json['height'] as num?)?.toDouble()),
      'height' => HeightDimension(fixedWidth: (json['width'] as num?)?.toDouble()),
      'area' => const AreaDimension(),
      'size' => WidthDimension(fixedHeight: (json['height'] as num?)?.toDouble()),
      _ => throw ArgumentError('Unknown dimension type: ${json['type']}'),
    };
  }

  /// The kind of this dimension, for use where a `switch` on the type itself
  /// would be overkill (dropdowns, segmented buttons, labels).
  DimensionKind get kind;

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
}

/// Item sold by width; [fixedHeight] (in cm) is the same for every order.
class WidthDimension extends Dimension {
  final double? fixedHeight;

  const WidthDimension({this.fixedHeight});

  @override
  DimensionKind get kind => DimensionKind.width;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': DimensionKind.width.value,
      if (fixedHeight != null) 'height': fixedHeight,
    };
  }
}

/// Item sold by height; [fixedWidth] (in cm) is the same for every order.
class HeightDimension extends Dimension {
  final double? fixedWidth;

  const HeightDimension({this.fixedWidth});

  @override
  DimensionKind get kind => DimensionKind.height;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': DimensionKind.height.value,
      if (fixedWidth != null) 'width': fixedWidth,
    };
  }
}

/// Item sold by area (m²); there is no fixed counterpart axis — the single
/// value the buyer enters is the whole quantity.
class AreaDimension extends Dimension {
  const AreaDimension();

  @override
  DimensionKind get kind => DimensionKind.area;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': DimensionKind.area.value};
  }
}
