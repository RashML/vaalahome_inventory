/// Price value object for use across the application.
///
/// Stored as an embedded JSON object (not its own PocketBase collection).
class Price {
  /// The amount, in [currencyCode] units.
  final double amount;

  /// The ISO code of the [Currency] this amount is denominated in.
  final String currencyCode;

  const Price({
    required this.amount,
    required this.currencyCode,
  });

  /// Maps a JSON object into a strongly-typed [Price].
  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: (json['amount'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
    );
  }

  /// Converts this [Price] back into a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'currencyCode': currencyCode,
    };
  }
}
