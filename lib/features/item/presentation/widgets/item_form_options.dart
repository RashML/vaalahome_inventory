import 'package:dropdown_flutter/custom_dropdown.dart';

import 'package:inventory_app/shared/models/bundle.dart';
import 'package:inventory_app/shared/models/company.dart';
import 'package:inventory_app/shared/models/currency.dart';

/// Adapts a [Company] into a [DropdownFlutter] item: searchable by name,
/// labeled by name.
class CompanyOption with CustomDropdownListFilter {
  CompanyOption(this.company);

  final Company company;

  @override
  bool filter(String query) =>
      company.name.toLowerCase().contains(query.toLowerCase());

  @override
  String toString() => company.name;

  @override
  bool operator ==(Object other) =>
      other is CompanyOption && other.company.id == company.id;

  @override
  int get hashCode => company.id.hashCode;
}

/// Adapts a [Bundle] into a [DropdownFlutter] item: searchable by name,
/// labeled by name.
class BundleOption with CustomDropdownListFilter {
  BundleOption(this.bundle);

  final Bundle bundle;

  @override
  bool filter(String query) =>
      bundle.name.toLowerCase().contains(query.toLowerCase());

  @override
  String toString() => bundle.name;

  @override
  bool operator ==(Object other) =>
      other is BundleOption && other.bundle.id == bundle.id;

  @override
  int get hashCode => bundle.id.hashCode;
}

/// Adapts a [Currency] into a [DropdownFlutter] item: searchable by code or
/// display name, labeled as "CODE — display name" (e.g. "USD — US Dollar").
class CurrencyOption with CustomDropdownListFilter {
  CurrencyOption(this.currency);

  final Currency currency;

  @override
  bool filter(String query) {
    final normalized = query.toLowerCase();
    return currency.code.toLowerCase().contains(normalized) ||
        currency.displayUnit.toLowerCase().contains(normalized);
  }

  @override
  String toString() => '${currency.code} — ${currency.displayUnit}';

  @override
  bool operator ==(Object other) =>
      other is CurrencyOption && other.currency.code == currency.code;

  @override
  int get hashCode => currency.code.hashCode;
}
