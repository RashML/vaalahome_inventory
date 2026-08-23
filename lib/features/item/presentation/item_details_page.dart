import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:inventory_app/features/auth/auth_service.dart';
import 'package:inventory_app/features/auth/models/user.dart';
import 'package:inventory_app/features/item/presentation/item_edit_page.dart';
import 'package:inventory_app/features/item/presentation/widgets/item_detail_row.dart';
import 'package:inventory_app/features/item/presentation/widgets/item_price_section.dart';
import 'package:inventory_app/features/order/presentation/widgets/add_to_draft_card.dart';
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
/// drawer for the buy price, the rest of the item's fields as key-value rows,
/// and — for every role — an add-to-draft section for ordering the item by its
/// variable dimension axis. Admins also get an edit action in the app bar.
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

  /// Opens the edit form and reloads when it reports a saved change, so the
  /// details shown are the updated ones (the item's id is unchanged).
  Future<void> _edit() async {
    final saved = await context.push<bool>(ItemEditPage.location(widget.itemId));
    if (saved == true && mounted) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAdmin = getIt<AuthService>().role == UserRole.admin;
    return Scaffold(
      appBar: AppBar(
        title: Text(_item?.name ?? ''),
        actions: [
          if (isAdmin && _item != null)
            IconButton(
              onPressed: _edit,
              icon: const Icon(Icons.edit_outlined),
              tooltip: l10n.itemDetailsEditCta,
            ),
        ],
      ),
      body: SafeArea(child: _buildBody(context, l10n, isAdmin)),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n, bool isAdmin) {
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
        AddToDraftCard(item: item, sellCurrency: _sellCurrency!),
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

  /// The axis the item is sold by, plus its fixed counterpart when it has one.
  List<Widget> _dimensionRows(AppLocalizations l10n, Dimension size) {
    final soldBy = switch (size.kind) {
      DimensionKind.width => l10n.itemFormSizeTypeWidth,
      DimensionKind.height => l10n.itemFormSizeTypeHeight,
      DimensionKind.area => l10n.itemFormSizeTypeArea,
    };

    final fixed = switch (size) {
      WidthDimension(:final fixedHeight) when fixedHeight != null => (
          l10n.itemFormHeightLabel,
          '${_trimNumber(fixedHeight)} ${l10n.itemDetailsUnitCm}',
        ),
      HeightDimension(:final fixedWidth) when fixedWidth != null => (
          l10n.itemFormWidthLabel,
          '${_trimNumber(fixedWidth)} ${l10n.itemDetailsUnitCm}',
        ),
      _ => null,
    };

    return [
      const Divider(height: 1),
      ItemDetailRow(label: l10n.itemDetailsDimensionLabel, value: soldBy),
      if (fixed != null) ...[
        const Divider(height: 1),
        ItemDetailRow(label: fixed.$1, value: fixed.$2),
      ],
    ];
  }

  String _trimNumber(double value) =>
      value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toString();
}
