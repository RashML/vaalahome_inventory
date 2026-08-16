import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Shows the QR generated from a newly created item's ID, with sharing
/// options. Reached from [ItemCreatePage] after a successful create.
class ItemQrSharePage extends StatelessWidget {
  static const path = '/items/:id/qr';

  static String location(String itemId) => '/items/$itemId/qr';

  final String itemId;

  const ItemQrSharePage({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(AppLocalizations.of(context)!.itemQrShareTitle(itemId)),
      ),
    );
  }
}
