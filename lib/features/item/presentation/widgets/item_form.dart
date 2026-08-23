import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/data/repository.dart';
import 'package:inventory_app/shared/di/locator.dart';
import 'package:inventory_app/shared/models/bundle.dart';
import 'package:inventory_app/shared/models/company.dart';
import 'package:inventory_app/shared/models/currency.dart';
import 'package:inventory_app/shared/models/dimension.dart';
import 'package:inventory_app/shared/models/item.dart';
import 'package:inventory_app/shared/models/price.dart';
import 'package:inventory_app/shared/utils/thousands_input_formatter.dart';
import 'package:inventory_app/shared/widgets/cta_button.dart';
import 'item_form_options.dart';

final _hexColorPattern = RegExp(r'^#?[0-9A-Fa-f]{6}$');

/// Pinned to `en` so the grouping separator is always the comma
/// [ThousandsInputFormatter.parse] strips, whatever the app locale is.
final _prefillFormat = NumberFormat('#,##0.##', 'en');

/// The item create/edit form, shared by both pages so the two never drift.
///
/// Pass [initialItem] to edit an existing item — every field is prefilled from
/// it, and the [Item] handed to [onSubmit] carries the same [Item.id], so the
/// record keeps its identity (and its printed QR code) while its properties
/// change. Pass `null` to create, in which case the id is empty and PocketBase
/// assigns the real one.
class ItemForm extends StatefulWidget {
  const ItemForm({
    super.key,
    this.initialItem,
    required this.submitLabel,
    required this.onSubmit,
  });

  final Item? initialItem;
  final String submitLabel;

  /// Called with the form's item once it validates. It owns the whole
  /// outcome — persisting, reporting failure, navigating on success — so it
  /// must not let errors escape; the form only drives the loading state.
  final Future<void> Function(Item item) onSubmit;

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _fixedHeightController = TextEditingController();
  final _fixedWidthController = TextEditingController();
  final _buyAmountController = TextEditingController();
  final _sellAmountController = TextEditingController();

  bool _loading = true;
  bool _loadError = false;
  bool _submitting = false;

  List<CompanyOption> _companies = [];
  List<BundleOption> _allBundles = [];
  List<CurrencyOption> _currencies = [];

  CompanyOption? _selectedCompany;
  BundleOption? _selectedBundle;
  CurrencyOption? _buyCurrency;
  CurrencyOption? _sellCurrency;
  DimensionKind _dimensionKind = DimensionKind.width;

  List<BundleOption> get _bundlesForSelectedCompany {
    final companyId = _selectedCompany?.company.id;
    if (companyId == null) return const [];
    return _allBundles.where((b) => b.bundle.companyId == companyId).toList();
  }

  @override
  void initState() {
    super.initState();
    _prefillFromItem();
    _loadOptions();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _fixedHeightController.dispose();
    _fixedWidthController.dispose();
    _buyAmountController.dispose();
    _sellAmountController.dispose();
    super.dispose();
  }

  /// Fills the text fields that don't depend on the loaded dropdown options.
  /// The dropdown selections are resolved in [_loadOptions], once the lists
  /// they must match against exist.
  void _prefillFromItem() {
    final item = widget.initialItem;
    if (item == null) return;

    _nameController.text = item.name;
    _colorController.text = item.colorCode ?? '';
    _buyAmountController.text = _formatAmount(item.buyPrice.amount);
    _sellAmountController.text = _formatAmount(item.sellPrice.amount);
    _dimensionKind = item.size.kind;

    switch (item.size) {
      case WidthDimension(:final fixedHeight):
        if (fixedHeight != null) {
          _fixedHeightController.text = _formatAmount(fixedHeight);
        }
      case HeightDimension(:final fixedWidth):
        if (fixedWidth != null) {
          _fixedWidthController.text = _formatAmount(fixedWidth);
        }
      case AreaDimension():
        break;
    }
  }

  /// Prefills a number the same way [ThousandsInputFormatter] would render it
  /// while typing — comma-grouped, so the field looks untouched and
  /// [ThousandsInputFormatter.parse] reads it back.
  String _formatAmount(double value) => _prefillFormat.format(value);

  Future<void> _loadOptions() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final results = await Future.wait([
        getIt<Repository<Company>>().getAll(),
        getIt<Repository<Bundle>>().getAll(),
        getIt<Repository<Currency>>().getAll(),
      ]);
      if (!mounted) return;
      final companies = (results[0] as List<Company>).map(CompanyOption.new).toList();
      final bundles = (results[1] as List<Bundle>).map(BundleOption.new).toList();
      final currencies = (results[2] as List<Currency>).map(CurrencyOption.new).toList();
      final item = widget.initialItem;
      setState(() {
        _companies = companies;
        _allBundles = bundles;
        _currencies = currencies;
        if (item != null) {
          _selectedCompany = _firstWhereOrNull(
            companies,
            (o) => o.company.id == item.companyId,
          );
          _selectedBundle = item.bundleId == null
              ? null
              : _firstWhereOrNull(bundles, (o) => o.bundle.id == item.bundleId);
          _buyCurrency = _firstWhereOrNull(
            currencies,
            (o) => o.currency.code == item.buyPrice.currencyCode,
          );
          _sellCurrency = _firstWhereOrNull(
            currencies,
            (o) => o.currency.code == item.sellPrice.currencyCode,
          );
        }
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

  static T? _firstWhereOrNull<T>(List<T> items, bool Function(T) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  Dimension _buildDimension() {
    return switch (_dimensionKind) {
      DimensionKind.width => WidthDimension(
          fixedHeight: ThousandsInputFormatter.parse(_fixedHeightController.text),
        ),
      DimensionKind.height => HeightDimension(
          fixedWidth: ThousandsInputFormatter.parse(_fixedWidthController.text),
        ),
      DimensionKind.area => const AreaDimension(),
    };
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    try {
      final rawColor = _colorController.text.trim().toUpperCase();
      final colorCode = rawColor.startsWith('#') ? rawColor : '#$rawColor';

      final item = Item(
        // Empty when creating — Item.toJson() drops it and PocketBase assigns
        // the real id. When editing, the existing id is carried through so the
        // record is updated in place rather than replaced.
        id: widget.initialItem?.id ?? '',
        name: _nameController.text.trim(),
        bundleId: _selectedBundle!.bundle.id,
        companyId: _selectedCompany!.company.id,
        size: _buildDimension(),
        colorCode: colorCode,
        buyPrice: Price(
          amount: ThousandsInputFormatter.parse(_buyAmountController.text)!,
          currencyCode: _buyCurrency!.currency.code,
        ),
        sellPrice: Price(
          amount: ThousandsInputFormatter.parse(_sellAmountController.text)!,
          currencyCode: _sellCurrency!.currency.code,
        ),
      );

      await widget.onSubmit(item);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  CustomDropdownDecoration _dropdownDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(18);
    return CustomDropdownDecoration(
      closedFillColor: colorScheme.surface,
      expandedFillColor: colorScheme.surface,
      closedBorder: Border.all(color: colorScheme.outline),
      closedBorderRadius: radius,
      expandedBorder: Border.all(color: colorScheme.primary, width: 1.5),
      expandedBorderRadius: radius,
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      headerStyle: TextStyle(color: colorScheme.onSurface),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              Text(l10n.itemFormLoadError, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _loadOptions,
                child: Text(l10n.itemFormRetryCta),
              ),
            ],
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FormSection(
              title: l10n.itemFormSectionBasics,
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: l10n.itemFormNameLabel),
                  validator: (v) => _requiredValidator(v, l10n),
                ),
                _fieldLabel(context, l10n.itemFormCompanyLabel),
                DropdownFlutter<CompanyOption>.search(
                  items: _companies,
                  initialItem: _selectedCompany,
                  hintText: l10n.itemFormCompanyHint,
                  searchHintText: l10n.itemFormCompanySearchHint,
                  noResultFoundText: l10n.itemFormNoResultFound,
                  decoration: _dropdownDecoration(context),
                  validateOnChange: true,
                  validator: (v) => v == null ? l10n.itemFormRequiredField : null,
                  onChanged: (v) => setState(() {
                    _selectedCompany = v;
                    _selectedBundle = null;
                  }),
                ),
                _fieldLabel(context, l10n.itemFormBundleLabel),
                DropdownFlutter<BundleOption>.search(
                  key: ValueKey(_selectedCompany?.company.id),
                  items: _bundlesForSelectedCompany,
                  initialItem: _selectedBundle,
                  enabled: _selectedCompany != null,
                  hintText: _selectedCompany == null
                      ? l10n.itemFormBundleHintNoCompany
                      : l10n.itemFormBundleHint,
                  searchHintText: l10n.itemFormBundleSearchHint,
                  noResultFoundText: l10n.itemFormNoResultFound,
                  decoration: _dropdownDecoration(context),
                  validateOnChange: true,
                  validator: (v) => v == null ? l10n.itemFormRequiredField : null,
                  onChanged: (v) => setState(() => _selectedBundle = v),
                ),
                TextFormField(
                  controller: _colorController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: l10n.itemFormColorLabel,
                    hintText: l10n.itemFormColorHint,
                  ),
                  validator: (v) => _colorValidator(v, l10n),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _FormSection(
              title: l10n.itemFormSectionSize,
              children: [
                SegmentedButton<DimensionKind>(
                  segments: [
                    ButtonSegment(
                      value: DimensionKind.width,
                      label: Text(l10n.itemFormSizeTypeWidth),
                    ),
                    ButtonSegment(
                      value: DimensionKind.height,
                      label: Text(l10n.itemFormSizeTypeHeight),
                    ),
                    ButtonSegment(
                      value: DimensionKind.area,
                      label: Text(l10n.itemFormSizeTypeArea),
                    ),
                  ],
                  selected: {_dimensionKind},
                  onSelectionChanged: (selection) =>
                      setState(() => _dimensionKind = selection.first),
                ),
                const SizedBox(height: 16),
                // Only the axis the item is *not* sold by is fixed on the item
                // itself; the other one is entered per order. Area items have
                // no fixed axis at all.
                switch (_dimensionKind) {
                  DimensionKind.width => TextFormField(
                      controller: _fixedHeightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [ThousandsInputFormatter()],
                      decoration: InputDecoration(labelText: l10n.itemFormFixedHeightLabel),
                      validator: (v) => _optionalNumberValidator(v, l10n),
                    ),
                  DimensionKind.height => TextFormField(
                      controller: _fixedWidthController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [ThousandsInputFormatter()],
                      decoration: InputDecoration(labelText: l10n.itemFormFixedWidthLabel),
                      validator: (v) => _optionalNumberValidator(v, l10n),
                    ),
                  DimensionKind.area => Text(
                      l10n.itemFormAreaHint,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                },
              ],
            ),
            const SizedBox(height: 20),
            _FormSection(
              title: l10n.itemFormSectionPricing,
              children: [
                Text(
                  l10n.itemFormBuyPriceSubtitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _buyAmountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [ThousandsInputFormatter()],
                  decoration: InputDecoration(
                    labelText: l10n.itemFormAmountLabel,
                    prefixText: _buyCurrency != null ? '${_buyCurrency!.currency.code}  ' : null,
                  ),
                  validator: (v) => _numberValidator(v, l10n),
                ),
                _fieldLabel(context, l10n.itemFormCurrencyLabel),
                DropdownFlutter<CurrencyOption>.search(
                  items: _currencies,
                  initialItem: _buyCurrency,
                  hintText: l10n.itemFormCurrencyHint,
                  searchHintText: l10n.itemFormCurrencySearchHint,
                  noResultFoundText: l10n.itemFormNoResultFound,
                  decoration: _dropdownDecoration(context),
                  validateOnChange: true,
                  validator: (v) => v == null ? l10n.itemFormRequiredField : null,
                  onChanged: (v) => setState(() => _buyCurrency = v),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                Text(
                  l10n.itemFormSellPriceSubtitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _sellAmountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [ThousandsInputFormatter()],
                  decoration: InputDecoration(
                    labelText: l10n.itemFormAmountLabel,
                    prefixText:
                        _sellCurrency != null ? '${_sellCurrency!.currency.code}  ' : null,
                  ),
                  validator: (v) => _numberValidator(v, l10n),
                ),
                _fieldLabel(context, l10n.itemFormCurrencyLabel),
                DropdownFlutter<CurrencyOption>.search(
                  items: _currencies,
                  initialItem: _sellCurrency,
                  hintText: l10n.itemFormCurrencyHint,
                  searchHintText: l10n.itemFormCurrencySearchHint,
                  noResultFoundText: l10n.itemFormNoResultFound,
                  decoration: _dropdownDecoration(context),
                  validateOnChange: true,
                  validator: (v) => v == null ? l10n.itemFormRequiredField : null,
                  onChanged: (v) => setState(() => _sellCurrency = v),
                ),
              ],
            ),
            const SizedBox(height: 28),
            CtaButton(
              label: widget.submitLabel,
              loading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

String? _requiredValidator(String? value, AppLocalizations l10n) =>
    (value == null || value.trim().isEmpty) ? l10n.itemFormRequiredField : null;

String? _numberValidator(String? value, AppLocalizations l10n) {
  if (value == null || value.trim().isEmpty) return l10n.itemFormRequiredField;
  final parsed = ThousandsInputFormatter.parse(value);
  if (parsed == null || parsed <= 0) return l10n.itemFormInvalidNumber;
  return null;
}

/// Like [_numberValidator], but an empty value is allowed — used for the fixed
/// counterpart axis, which not every item has.
String? _optionalNumberValidator(String? value, AppLocalizations l10n) {
  if (value == null || value.trim().isEmpty) return null;
  final parsed = ThousandsInputFormatter.parse(value);
  if (parsed == null || parsed <= 0) return l10n.itemFormInvalidNumber;
  return null;
}

String? _colorValidator(String? value, AppLocalizations l10n) {
  if (value == null || value.trim().isEmpty) return l10n.itemFormRequiredField;
  if (!_hexColorPattern.hasMatch(value.trim())) return l10n.itemFormInvalidColor;
  return null;
}

Widget _fieldLabel(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
  child: Text(text, style: Theme.of(context).textTheme.labelLarge),
);

/// A titled card grouping related fields, so the form reads as a short list
/// of reviewable sections rather than one long column of fields.
class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            for (final child in children) ...[child, const SizedBox(height: 16)],
          ],
        ),
      ),
    );
  }
}
