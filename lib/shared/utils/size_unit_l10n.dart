import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/models/size_unit.dart';

extension SizeUnitL10n on SizeUnit {
  /// The unit's localized display name (e.g. "cm" / "سانتی‌متر").
  String label(AppLocalizations l10n) => switch (this) {
        SizeUnit.cm => l10n.itemDetailsUnitCm,
        SizeUnit.m => l10n.itemDetailsUnitMeter,
        SizeUnit.m2 => l10n.itemDetailsUnitSquareMeter,
      };
}
