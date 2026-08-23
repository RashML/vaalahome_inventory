import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/data/repository.dart';
import 'package:inventory_app/shared/di/locator.dart';
import 'package:inventory_app/shared/models/item.dart';
import 'package:inventory_app/shared/widgets/app_toast.dart';
import 'widgets/item_form.dart';

/// Admin-only editing of an existing item, reached from [ItemDetailsPage].
///
/// The record's id never changes — only its properties are updated — so an
/// already-printed QR code keeps pointing at the same item after an edit.
class ItemEditPage extends StatefulWidget {
  static const path = '/items/:id/edit';

  static String location(String itemId) => '/items/$itemId/edit';

  final String itemId;

  const ItemEditPage({super.key, required this.itemId});

  @override
  State<ItemEditPage> createState() => _ItemEditPageState();
}

class _ItemEditPageState extends State<ItemEditPage> {
  bool _loading = true;
  bool _loadError = false;
  Item? _item;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final item = await getIt<Repository<Item>>().getById(widget.itemId);
      if (!mounted) return;
      setState(() {
        _item = item;
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

  Future<void> _save(Item item) async {
    try {
      await getIt<Repository<Item>>().update(widget.itemId, item);
      if (!mounted) return;
      AppToast.show(context, AppLocalizations.of(context)!.itemFormUpdateSuccess);
      // `true` tells the details page its data is stale and to reload.
      context.pop(true);
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, AppLocalizations.of(context)!.itemFormUpdateError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.itemEditTitle)),
      body: SafeArea(child: _buildBody(l10n)),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
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
              Text(l10n.itemDetailsLoadError, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: _load, child: Text(l10n.itemFormRetryCta)),
            ],
          ),
        ),
      );
    }

    return ItemForm(
      initialItem: _item,
      submitLabel: l10n.itemFormSaveCta,
      onSubmit: _save,
    );
  }
}
