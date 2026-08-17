import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Live-formats a price amount field with thousands separators as the user
/// types (e.g. `12345` -> `12,345`), keeping at most 2 decimal digits.
class ThousandsInputFormatter extends TextInputFormatter {
  static final _groupFormat = NumberFormat.decimalPattern();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsAndDot = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');
    if (digitsAndDot.isEmpty) {
      return const TextEditingValue();
    }

    final parts = digitsAndDot.split('.');
    final integerPart = parts.first.isEmpty ? '0' : parts.first;
    final hasDot = digitsAndDot.contains('.');
    final decimalPart = parts.length > 1
        ? parts[1].substring(0, parts[1].length > 2 ? 2 : parts[1].length)
        : '';

    final grouped = _groupFormat.format(int.parse(integerPart));
    final formatted = hasDot ? '$grouped.$decimalPart' : grouped;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Parses a formatted value like `12,345.5` back into a [double].
  static double? parse(String formatted) =>
      double.tryParse(formatted.replaceAll(',', ''));
}
