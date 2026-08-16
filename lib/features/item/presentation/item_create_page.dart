import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// On successful creation, navigates to [ItemQrSharePage] for the new item.
class ItemCreatePage extends StatelessWidget {
  static const path = '/items/new';

  const ItemCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(AppLocalizations.of(context)!.itemCreateTitle)),
    );
  }
}
