import 'package:flutter/material.dart';

import 'package:inventory_app/l10n/app_localizations.dart';

/// Reached from [ScanPage] on a detected QR/barcode, or from any item list.
class ItemDetailsPage extends StatelessWidget {
  static const path = '/items/:id';

  static String location(String itemId) => '/items/$itemId';

  final String itemId;

  const ItemDetailsPage({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(AppLocalizations.of(context)!.itemDetailsTitle(itemId)),
      ),
    );
  }
}
