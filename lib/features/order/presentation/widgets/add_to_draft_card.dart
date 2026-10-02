import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:inventory_app/features/order/data/draft_order_service.dart';
import 'package:inventory_app/features/order/models/draft_line.dart';
import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/di/locator.dart';
import 'package:inventory_app/shared/models/currency.dart';
import 'package:inventory_app/shared/models/dimension.dart';
import 'package:inventory_app/shared/models/item.dart';
import 'package:inventory_app/shared/utils/size_unit_l10n.dart';
import 'package:inventory_app/shared/utils/thousands_input_formatter.dart';
import 'package:inventory_app/shared/widgets/app_toast.dart';

/// The add-to-draft section of the item details page.
///
/// The buyer enters a value for whichever axis the item is sold by, and the
/// line's price in Rial — sell price × exchange rate × the entered value —
/// updates as they type. Adding pushes the line onto [DraftOrderService],
/// which the floating draft button and the draft page read from.
class AddToDraftCard extends StatefulWidget {
  const AddToDraftCard({
    super.key,
    required this.item,
    required this.sellCurrency,
    this.companyName,
    this.bundleName,
  });

  final Item item;
  final Currency sellCurrency;

  /// Carried onto the draft line so the draft page can show them.
  final String? companyName;
  final String? bundleName;

  @override
  State<AddToDraftCard> createState() => _AddToDraftCardState();
}

class _AddToDraftCardState extends State<AddToDraftCard> {
  final _valueController = TextEditingController();

  double? get _value {
    final parsed = ThousandsInputFormatter.parse(_valueController.text);
    return (parsed == null || parsed <= 0) ? null : parsed;
  }

  double get _unitPriceInRial =>
      widget.item.sellPrice.amount * widget.sellCurrency.rateInRial;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  String _valueLabel(AppLocalizations l10n) => switch (widget.item.size.kind) {
        DimensionKind.width => l10n.draftValueLabelWidth,
        DimensionKind.height => l10n.draftValueLabelHeight,
        DimensionKind.area => l10n.draftValueLabelArea,
      };

  void _add() {
    final value = _value;
    if (value == null) return;

    getIt<DraftOrderService>().add(
      DraftLine(
        item: widget.item,
        sellCurrency: widget.sellCurrency,
        value: value,
        companyName: widget.companyName,
        bundleName: widget.bundleName,
      ),
    );
    _valueController.clear();
    setState(() {});
    AppToast.show(context, AppLocalizations.of(context)!.itemDetailsAddedToDraft);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final value = _value;
    final total = value == null ? null : _unitPriceInRial * value;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.itemDetailsAddToDraftTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _valueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [ThousandsInputFormatter()],
              decoration: InputDecoration(
                labelText: _valueLabel(l10n),
                suffixText: widget.item.size.unit.label(l10n),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(l10n.draftLineTotalLabel, style: theme.textTheme.titleMedium),
                ),
                Text(
                  total == null
                      ? '—'
                      : '${NumberFormat('#,##0', locale).format(total)} ${l10n.itemDetailsRialSuffix}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: value == null ? null : _add,
              icon: const Icon(Icons.playlist_add_rounded),
              label: Text(l10n.itemDetailsAddToDraftCta),
            ),
          ],
        ),
      ),
    );
  }
}
