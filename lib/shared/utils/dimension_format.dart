import 'package:intl/intl.dart';

import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/models/dimension.dart';
import 'package:inventory_app/shared/utils/size_unit_l10n.dart';

/// Human-readable dimension, e.g. "ارتفاع ۱۵۰ سانتی‌متر": the type, the stored
/// value and the unit. Area items have no stored value, so they read
/// "مساحت متر مربع".
String describeDimension(AppLocalizations l10n, Dimension size, String locale) {
  final type = switch (size.kind) {
    DimensionKind.width => l10n.itemFormSizeTypeWidth,
    DimensionKind.height => l10n.itemFormSizeTypeHeight,
    DimensionKind.area => l10n.itemFormSizeTypeArea,
  };

  final double? value = switch (size) {
    WidthDimension(:final fixedHeight) => fixedHeight,
    HeightDimension(:final fixedWidth) => fixedWidth,
    AreaDimension() => null,
  };
  final number = value == null ? null : NumberFormat('#,##0.##', locale).format(value);

  return [type, ?number, size.unit.label(l10n)].join(' ');
}
