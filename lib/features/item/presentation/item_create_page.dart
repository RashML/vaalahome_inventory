import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/data/repository.dart';
import 'package:inventory_app/shared/di/locator.dart';
import 'package:inventory_app/shared/models/item.dart';
import 'package:inventory_app/shared/widgets/app_toast.dart';
import 'item_qr_share_page.dart';
import 'widgets/item_form.dart';

/// On successful creation, navigates to [ItemQrSharePage] for the new item.
class ItemCreatePage extends StatelessWidget {
  static const path = '/items/new';

  const ItemCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.itemCreateTitle)),
      body: SafeArea(
        child: ItemForm(
          submitLabel: l10n.itemFormSubmitCta,
          onSubmit: (item) => _create(context, item),
        ),
      ),
    );
  }

  Future<void> _create(BuildContext context, Item item) async {
    try {
      final created = await getIt<Repository<Item>>().create(item);
      if (!context.mounted) return;
      context.go(ItemQrSharePage.location(created.id));
    } catch (_) {
      if (!context.mounted) return;
      AppToast.error(context, AppLocalizations.of(context)!.itemFormCreateError);
    }
  }
}
