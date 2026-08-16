/// Dimension data model for use across the application.
///
/// Stored as an embedded JSON object (not its own PocketBase collection),
/// discriminated by a `type` field.
sealed class Dimension {
  const Dimension();

  /// Maps a JSON object into a strongly-typed [Dimension].
  factory Dimension.fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      'size' => SizeDimension(
          width: (json['width'] as num?)?.toDouble(),
          height: (json['height'] as num?)?.toDouble(),
        ),
      'area' => AreaDimension((json['squareMeters'] as num).toDouble()),
      _ => throw ArgumentError('Unknown dimension type: ${json['type']}'),
    };
  }

  /// Converts this [Dimension] back into a JSON map.
  Map<String, dynamic> toJson();
}

class SizeDimension extends Dimension {
  final double? width;
  final double? height;

  const SizeDimension({
    this.width,
    this.height,
  });

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'size',
      if (width != null) 'width': width,
      if (height != null) 'height': height,
    };
  }
}

class AreaDimension extends Dimension {
  final double squareMeters;

  const AreaDimension(this.squareMeters);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'area',
      'squareMeters': squareMeters,
    };
  }
}
