import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/models/currency.dart';
import 'package:inventory_app/shared/models/price.dart';

/// Duration the buy-price drawer takes to slide in/out.
const _kDrawerAnimationDuration = Duration(milliseconds: 260);

/// How long an admin must hold the price card before the buy-price drawer
/// reveals itself.
const _kHoldToRevealDuration = Duration(seconds: 5);

/// The item's price section: sell price, and its Rial-converted final price.
///
/// For [isAdmin] users, holding the card for [_kHoldToRevealDuration] slides
/// up a drawer showing the buy price; releasing the hold slides it back out.
/// The drawer is removed from the tree entirely while hidden — not just
/// made transparent — so nothing lingers to glitch or intercept touches.
class ItemPriceSection extends StatefulWidget {
  const ItemPriceSection({
    super.key,
    required this.sellPrice,
    required this.sellCurrency,
    required this.buyPrice,
    required this.buyCurrency,
    required this.isAdmin,
  });

  final Price sellPrice;
  final Currency sellCurrency;
  final Price buyPrice;
  final Currency buyCurrency;
  final bool isAdmin;

  @override
  State<ItemPriceSection> createState() => _ItemPriceSectionState();
}

class _ItemPriceSectionState extends State<ItemPriceSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drawerController;
  late final Animation<Offset> _drawerOffset;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: _kDrawerAnimationDuration,
    );
    _drawerOffset = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _drawerController, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  void _reveal() {
    HapticFeedback.mediumImpact();
    _drawerController.forward();
  }

  void _hide() => _drawerController.reverse();

  String _formatAmount(double amount, String locale) =>
      NumberFormat('#,##0.##', locale).format(amount);

  String _formatRial(double amount, String locale) =>
      NumberFormat('#,##0', locale).format(amount);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final finalPrice = widget.sellPrice.amount * widget.sellCurrency.rateInRial;

    final card = Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.itemDetailsSectionPrice, style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(l10n.itemDetailsSellPriceLabel, style: theme.textTheme.bodyMedium),
                    ),
                    Text(
                      '${_formatAmount(widget.sellPrice.amount, locale)} ${widget.sellCurrency.code}',
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.itemDetailsFinalPriceLabel,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      '${_formatRial(finalPrice, locale)} ${l10n.itemDetailsRialSuffix}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (widget.isAdmin) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.touch_app_outlined, size: 16, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l10n.itemDetailsHoldHint,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (widget.isAdmin)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _drawerController,
                  builder: (context, child) {
                    if (_drawerController.status == AnimationStatus.dismissed) {
                      return const SizedBox.shrink();
                    }
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: SlideTransition(
                        position: _drawerOffset,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(color: theme.colorScheme.primary),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_open_rounded, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.itemDetailsBuyPriceLabel,
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                              ),
                              Text(
                                '${_formatAmount(widget.buyPrice.amount, locale)} ${widget.buyCurrency.code}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (!widget.isAdmin) return card;

    return RawGestureDetector(
      gestures: {
        LongPressGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
          () => LongPressGestureRecognizer(duration: _kHoldToRevealDuration),
          (instance) {
            instance.onLongPressStart = (_) => _reveal();
            instance.onLongPressEnd = (_) => _hide();
            instance.onLongPressCancel = _hide;
          },
        ),
      },
      child: card,
    );
  }
}
