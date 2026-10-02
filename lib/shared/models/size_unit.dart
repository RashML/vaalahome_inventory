/// Unit a [Dimension]'s values are measured in.
enum SizeUnit {
  cm('cm'),
  m('m'),
  m2('m2');

  const SizeUnit(this.value);

  /// The raw value stored in the `unit` key of the item's `size` JSON.
  final String value;

  /// Resolves a raw stored value into a [SizeUnit], or `null` when empty or
  /// unknown.
  static SizeUnit? fromValue(Object? value) {
    for (final unit in SizeUnit.values) {
      if (unit.value == value) return unit;
    }
    return null;
  }
}
