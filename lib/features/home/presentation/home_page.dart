import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/features/camera/presentation/scan_page.dart';
import 'package:inventory_app/features/item/presentation/item_create_page.dart';
import 'package:inventory_app/shared/widgets/cta_button.dart';

class HomePage extends StatelessWidget {
  static const path = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CtaButton(
                label: l10n.homeScanCta,
                onPressed: () => context.go(ScanPage.path),
              ),
              const SizedBox(height: 16),
              CtaButton(
                label: l10n.homeCreateCta,
                onPressed: () => context.go(ItemCreatePage.path),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
