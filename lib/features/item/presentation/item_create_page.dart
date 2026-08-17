import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
import 'package:inventory_app/shared/widgets/app_toast.dart';
import 'package:inventory_app/shared/widgets/cta_button.dart';
import 'item_qr_share_page.dart';
import 'widgets/item_form_options.dart';

enum _DimensionKind { size, area }

final _hexColorPattern = RegExp(r'^#?[0-9A-Fa-f]{6}$');

/// On successful creation, navigates to [ItemQrSharePage] for the new item.
class ItemCreatePage extends StatefulWidget {
  static const path = '/items/new';

  const ItemCreatePage({super.key});

  @override
  State<ItemCreatePage> createState() => _ItemCreatePageState();
}

class _ItemCreatePageState extends State<ItemCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _areaController = TextEditingController();
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
  _DimensionKind _dimensionKind = _DimensionKind.size;

  List<BundleOption> get _bundlesForSelectedCompany {
    final companyId = _selectedCompany?.company.id;
    if (companyId == null) return const [];
    return _allBundles.where((b) => b.bundle.companyId == companyId).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _areaController.dispose();
    _buyAmountController.dispose();
    _sellAmountController.dispose();
    super.dispose();
  }

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
      setState(() {
        _companies = (results[0] as List<Company>).map(CompanyOption.new).toList();
        _allBundles = (results[1] as List<Bundle>).map(BundleOption.new).toList();
        _currencies = (results[2] as List<Currency>).map(CurrencyOption.new).toList();
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

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    try {
      final dimension = _dimensionKind == _DimensionKind.size
          ? SizeDimension(
              width: ThousandsInputFormatter.parse(_widthController.text),
              height: ThousandsInputFormatter.parse(_heightController.text),
            )
          : AreaDimension(ThousandsInputFormatter.parse(_areaController.text)!);

      final rawColor = _colorController.text.trim().toUpperCase();
      final colorCode = rawColor.startsWith('#') ? rawColor : '#$rawColor';

      final item = Item(
        id: '', // discarded by Item.toJson(); PocketBase assigns the real id.
        name: _nameController.text.trim(),
        bundleId: _selectedBundle!.bundle.id,
        companyId: _selectedCompany!.company.id,
        size: dimension,
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

      final created = await getIt<Repository<Item>>().create(item);
      if (!mounted) return;
      context.go(ItemQrSharePage.location(created.id));
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, AppLocalizations.of(context)!.itemFormCreateError);
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
    return Scaffold(
      appBar: AppBar(title: Text(l10n.itemCreateTitle)),
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
                SegmentedButton<_DimensionKind>(
                  segments: [
                    ButtonSegment(
                      value: _DimensionKind.size,
                      label: Text(l10n.itemFormSizeTypeSize),
                    ),
                    ButtonSegment(
                      value: _DimensionKind.area,
                      label: Text(l10n.itemFormSizeTypeArea),
                    ),
                  ],
                  selected: {_dimensionKind},
                  onSelectionChanged: (selection) =>
                      setState(() => _dimensionKind = selection.first),
                ),
                const SizedBox(height: 16),
                if (_dimensionKind == _DimensionKind.size)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _widthController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ThousandsInputFormatter()],
                          decoration: InputDecoration(labelText: l10n.itemFormWidthLabel),
                          validator: (v) => _numberValidator(v, l10n),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ThousandsInputFormatter()],
                          decoration: InputDecoration(labelText: l10n.itemFormHeightLabel),
                          validator: (v) => _numberValidator(v, l10n),
                        ),
                      ),
                    ],
                  )
                else
                  TextFormField(
                    controller: _areaController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [ThousandsInputFormatter()],
                    decoration: InputDecoration(labelText: l10n.itemFormAreaLabel),
                    validator: (v) => _numberValidator(v, l10n),
                  ),
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
              label: l10n.itemFormSubmitCta,
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
