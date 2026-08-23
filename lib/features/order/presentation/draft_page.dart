import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:inventory_app/features/order/data/draft_order_service.dart';
import 'package:inventory_app/features/order/models/draft_line.dart';
import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/di/locator.dart';
import 'package:inventory_app/shared/models/dimension.dart';

/// The order draft: every line the user has added, with its price in Rial and
/// a running grand total.
///
/// Reached from the floating draft button, which is available on every
/// authenticated page.
class DraftPage extends StatelessWidget {
  static const path = '/draft';

  const DraftPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final draft = getIt<DraftOrderService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.draftTitle),
        actions: [
          ListenableBuilder(
            listenable: draft,
            builder: (context, _) => TextButton(
              onPressed: draft.isEmpty ? null : () => _confirmClear(context, draft, l10n),
              child: Text(l10n.draftClearCta),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: draft,
          builder: (context, _) {
            if (draft.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l10n.draftEmpty, textAlign: TextAlign.center),
                ),
              );
            }

            final lines = draft.lines;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    itemCount: lines.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _DraftLineCard(
                        line: lines[index],
                        onRemove: () => _confirmRemove(context, draft, index, l10n),
                      ),
                    ),
                  ),
                ),
                _DraftTotalBar(totalInRial: draft.totalInRial),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    DraftOrderService draft,
    int index,
    AppLocalizations l10n,
  ) async {
    final confirmed = await _confirm(
      context,
      title: l10n.draftRemoveTitle,
      message: l10n.draftRemoveMessage,
      confirmLabel: l10n.draftRemoveConfirmCta,
      cancelLabel: l10n.draftCancelCta,
    );
    if (confirmed) draft.removeAt(index);
  }

  Future<void> _confirmClear(
    BuildContext context,
    DraftOrderService draft,
    AppLocalizations l10n,
  ) async {
    final confirmed = await _confirm(
      context,
      title: l10n.draftClearTitle,
      message: l10n.draftClearMessage,
      confirmLabel: l10n.draftRemoveConfirmCta,
      cancelLabel: l10n.draftCancelCta,
    );
    if (confirmed) draft.clear();
  }

  /// A platform-native confirmation alert: Cupertino on iOS/macOS, Material
  /// everywhere else.
  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
  }) async {
    final result = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _DraftLineCard extends StatelessWidget {
  const _DraftLineCard({required this.line, required this.onRemove});

  final DraftLine line;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final rial = NumberFormat('#,##0', locale);
    final amount = NumberFormat('#,##0.##', locale);

    final axisLabel = switch (line.item.size.kind) {
      DimensionKind.width => l10n.itemFormSizeTypeWidth,
      DimensionKind.height => l10n.itemFormSizeTypeHeight,
      DimensionKind.area => l10n.itemFormSizeTypeArea,
    };
    final valueSuffix = line.item.size.kind == DimensionKind.area
        ? ' ${l10n.itemDetailsUnitSquareMeter}'
        : '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.item.name,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _LineRow(
                    label: axisLabel,
                    value: '${amount.format(line.value)}$valueSuffix',
                  ),
                  _LineRow(
                    label: l10n.draftUnitPriceLabel,
                    value: '${rial.format(line.unitPriceInRial)} ${l10n.itemDetailsRialSuffix}',
                  ),
                  const SizedBox(height: 4),
                  _LineRow(
                    label: l10n.draftLineTotalLabel,
                    value: '${rial.format(line.totalInRial)} ${l10n.itemDetailsRialSuffix}',
                    emphasized: true,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded),
              color: theme.colorScheme.error,
              tooltip: l10n.draftRemoveConfirmCta,
            ),
          ],
        ),
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueStyle = emphasized
        ? theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          )
        : theme.textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}

class _DraftTotalBar extends StatelessWidget {
  const _DraftTotalBar({required this.totalInRial});

  final double totalInRial;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Row(
          children: [
            Expanded(child: Text(l10n.draftTotalLabel, style: theme.textTheme.titleMedium)),
            Text(
              '${NumberFormat('#,##0', locale).format(totalInRial)} ${l10n.itemDetailsRialSuffix}',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
