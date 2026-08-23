import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:inventory_app/features/order/data/draft_order_service.dart';
import 'package:inventory_app/features/order/presentation/draft_page.dart';
import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/di/locator.dart';

/// Shell around every authenticated page, adding the app-wide floating button
/// that opens the order draft and badges how many lines it holds.
///
/// The button is hidden on [DraftPage] itself — there is nothing to navigate
/// to from there.
class DraftFabScaffold extends StatelessWidget {
  const DraftFabScaffold({super.key, required this.child, required this.location});

  final Widget child;

  /// The route currently shown inside this shell.
  final String location;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final draft = getIt<DraftOrderService>();
    final onDraftPage = location == DraftPage.path;

    return Scaffold(
      body: child,
      floatingActionButton: onDraftPage
          ? null
          : ListenableBuilder(
              listenable: draft,
              builder: (context, _) {
                final button = FloatingActionButton(
                  onPressed: () => context.push(DraftPage.path),
                  tooltip: l10n.draftFabTooltip,
                  child: const Icon(Icons.receipt_long_rounded),
                );
                if (draft.count == 0) return button;
                return Badge.count(count: draft.count, child: button);
              },
            ),
    );
  }
}
