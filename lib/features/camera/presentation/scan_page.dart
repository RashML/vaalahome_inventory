import 'package:flutter/material.dart';

import 'package:inventory_app/l10n/app_localizations.dart';

/// On a detected QR/barcode, navigates to [ItemDetailsPage].
class ScanPage extends StatelessWidget {
  static const path = '/scan';

  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(AppLocalizations.of(context)!.scanTitle)),
    );
  }
}
