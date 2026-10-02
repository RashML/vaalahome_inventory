import 'package:pocketbase/pocketbase.dart';
/// Currency data model for use across the application.
class Currency {
  static const String collection = 'currencies';
  /// The ISO currency code (used as ID).
  final String code;
  /// The display unit/alias for the currency (e.g., 'دلار' for USD).
  final String displayUnit;
  /// Exchange rate to Rial.
  final double rateInRial;

    const Currency({
    required this.code,
    required this.displayUnit,
    required this.rateInRial,
  });

    /// The localized name when there is one, else the ISO code — for compact
  /// places such as an input prefix.
  String get shortLabel => displayUnit.isEmpty ? code : displayUnit;

  /// Localized name plus ISO code, e.g. `درهم (AED)`; just the code when no
  /// display name is set.
  String get fullLabel => displayUnit.isEmpty ? code : '$displayUnit ($code)';

  /// Maps a PocketBase [RecordModel] into a strongly-typed [Currency].
  factory Currency.fromRecord(RecordModel record) {
    return Currency(
      code: record.id, // ISO code used as ID
      displayUnit: record.getStringValue('displayUnit'),
      rateInRial: record.getDoubleValue('rateInRial'),
    );
  }

  /// Converts this [Currency] back into a JSON map for sending data to
    /// PocketBase.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'displayUnit': displayUnit,
      'rateInRial': rateInRial,
    };
  }
}
