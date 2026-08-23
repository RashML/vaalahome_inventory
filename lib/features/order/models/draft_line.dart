import 'package:inventory_app/shared/models/currency.dart';
import 'package:inventory_app/shared/models/item.dart';

/// One line of the in-progress order draft: an [item], and how much of its
/// variable dimension axis the buyer wants.
///
/// [sellCurrency] is snapshotted when the line is added, so a rate change
/// mid-draft doesn't silently reprice lines the user already reviewed.
class DraftLine {
  /// The item being ordered.
  final Item item;

  /// The currency [Item.sellPrice] is denominated in, as it was when this
  /// line was added.
  final Currency sellCurrency;

  /// The value entered for the item's variable axis
  /// (width, height, or m² — see [Item.size]).
  final double value;

  const DraftLine({
    required this.item,
    required this.sellCurrency,
    required this.value,
  });

  /// The item's sell price converted to Rial, for one unit of its axis.
  double get unitPriceInRial => item.sellPrice.amount * sellCurrency.rateInRial;

  /// The line's price in Rial: unit price × the ordered [value].
  double get totalInRial => unitPriceInRial * value;

  DraftLine copyWith({double? value}) => DraftLine(
        item: item,
        sellCurrency: sellCurrency,
        value: value ?? this.value,
      );
}
