import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:inventory_app/features/order/models/draft_line.dart';

/// App-wide order draft, held in memory only — it is intentionally lost on
/// app restart, since a draft is a scratch pad, not a placed order.
///
/// Registered as a singleton in the DI container, so the floating draft
/// button, the item details page and the draft page all read and mutate the
/// same list and rebuild together off [ChangeNotifier].
///
/// The same item may appear on more than one line: two cuts of the same
/// fabric are two order lines, not one line with a summed value.
class DraftOrderService extends ChangeNotifier {
  final List<DraftLine> _lines = [];

  /// Every line currently in the draft, in the order they were added.
  UnmodifiableListView<DraftLine> get lines => UnmodifiableListView(_lines);

  /// Number of lines in the draft — what the floating button badges.
  int get count => _lines.length;

  bool get isEmpty => _lines.isEmpty;

  /// The draft's grand total in Rial.
  double get totalInRial =>
      _lines.fold(0, (sum, line) => sum + line.totalInRial);

  void add(DraftLine line) {
    _lines.add(line);
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _lines.length) return;
    _lines.removeAt(index);
    notifyListeners();
  }

  void clear() {
    if (_lines.isEmpty) return;
    _lines.clear();
    notifyListeners();
  }
}
