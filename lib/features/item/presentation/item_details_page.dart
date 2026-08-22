import 'package:flutter/material.dart';

import 'package:inventory_app/features/auth/auth_service.dart';
import 'package:inventory_app/features/auth/models/user.dart';
import 'package:inventory_app/features/item/presentation/widgets/item_detail_row.dart';
import 'package:inventory_app/features/item/presentation/widgets/item_price_section.dart';
import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/data/repository.dart';
import 'package:inventory_app/shared/di/locator.dart';
import 'package:inventory_app/shared/models/bundle.dart';
import 'package:inventory_app/shared/models/company.dart';
import 'package:inventory_app/shared/models/currency.dart';
import 'package:inventory_app/shared/models/dimension.dart';
import 'package:inventory_app/shared/models/item.dart';

/// Reached from [ScanPage] on a detected QR/barcode, or from any item list.
///
/// Shows the item's price (converted to Rial) with an admin-only hold-to-reveal
/// drawer for the buy price, followed by the rest of the item's fields as
/// key-value rows.
class ItemDetailsPage extends StatefulWidget {
  static const path = '/items/:id';

  static String location(String itemId) => '/items/$itemId';

  final String itemId;

  const ItemDetailsPage({super.key, required this.itemId});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  bool _loading = true;
  bool _loadError = false;

  Item? _item;
  Company? _company;
  Bundle? _bundle;
  Currency? _sellCurrency;
  Currency? _buyCurrency;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final item = await getIt<Repository<Item>>().getById(widget.itemId);
      final results = await Future.wait([
        getIt<Repository<Company>>().getById(item.companyId),
        getIt<Repository<Currency>>().getById(item.sellPrice.currencyCode),
        getIt<Repository<Currency>>().getById(item.buyPrice.currencyCode),
        if (item.bundleId != null) getIt<Repository<Bundle>>().getById(item.bundleId!),
      ]);
      if (!mounted) return;
      setState(() {
        _item = item;
        _company = results[0] as Company;
        _sellCurrency = results[1] as Currency;
        _buyCurrency = results[2] as Currency;
        _bundle = item.bundleId != null ? results[3] as Bundle : null;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(_item?.name ?? '')),
      body: SafeArea(child: _buildBody(context, l10n)),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.itemDetailsLoadError, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: _load, child: Text(l10n.itemFormRetryCta)),
            ],
          ),
        ),
      );
    }

    final item = _item!;
    final isAdmin = getIt<AuthService>().role == UserRole.admin;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        ItemPriceSection(
          sellPrice: item.sellPrice,
          sellCurrency: _sellCurrency!,
          buyPrice: item.buyPrice,
          buyCurrency: _buyCurrency!,
          isAdmin: isAdmin,
        ),
        const SizedBox(height: 24),
        Text(l10n.itemDetailsSectionDetails, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ItemDetailRow(label: l10n.itemFormCompanyLabel, value: _company!.name),
                if (_bundle != null) ...[
                  const Divider(height: 1),
                  ItemDetailRow(label: l10n.itemFormBundleLabel, value: _bundle!.name),
                ],
                if (item.colorCode != null) ...[
                  const Divider(height: 1),
                  ItemDetailRow(label: l10n.itemFormColorLabel, value: item.colorCode!),
                ],
                ..._dimensionRows(l10n, item.size),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _dimensionRows(AppLocalizations l10n, Dimension size) {
    return switch (size) {
      SizeDimension(:final width, :final height) => [
          if (width != null) ...[
            const Divider(height: 1),
            ItemDetailRow(
              label: l10n.itemFormWidthLabel,
              value: '${_trimNumber(width)} ${l10n.itemDetailsUnitCm}',
            ),
          ],
          if (height != null) ...[
            const Divider(height: 1),
            ItemDetailRow(
              label: l10n.itemFormHeightLabel,
              value: '${_trimNumber(height)} ${l10n.itemDetailsUnitCm}',
            ),
          ],
        ],
      AreaDimension(:final squareMeters) => [
          const Divider(height: 1),
          ItemDetailRow(label: l10n.itemFormAreaLabel, value: _trimNumber(squareMeters)),
        ],
    };
  }

  String _trimNumber(double value) =>
      value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toString();
}
