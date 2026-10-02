import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:inventory_app/features/auth/auth_service.dart';
import 'package:inventory_app/features/auth/presentation/login_page.dart';
import 'package:inventory_app/features/camera/presentation/scan_page.dart';
import 'package:inventory_app/features/home/presentation/home_page.dart';
import 'package:inventory_app/features/item/presentation/item_create_page.dart';
import 'package:inventory_app/features/item/presentation/item_details_page.dart';
import 'package:inventory_app/features/item/presentation/item_edit_page.dart';
import 'package:inventory_app/features/item/presentation/item_qr_share_page.dart';
import 'package:inventory_app/features/order/presentation/draft_page.dart';
import 'package:inventory_app/features/order/presentation/widgets/draft_fab_scaffold.dart';
import 'splash_page.dart';

/// Top-level app navigation, gated by [AuthService.status]:
/// - [AuthStatus.unknown] -> [SplashPage]
/// - [AuthStatus.unauthenticated] -> [LoginPage]
/// - [AuthStatus.authenticated] -> any authenticated route (default [HomePage])
///
/// [AuthService] is a [ChangeNotifier], so wiring it as [GoRouter]'s
/// `refreshListenable` re-evaluates [_redirect] on every login/logout/refresh
/// (e.g. [LoginPage] needs no explicit "go to home" call on success — once
/// [AuthService.status] flips, the redirect sends it there).
///
/// Every authenticated route except [DraftPage] is wrapped in
/// [DraftFabScaffold], which puts the order-draft floating button on them.
///
/// Flow: [HomePage] -> [ScanPage] or [ItemCreatePage].
/// [ScanPage] on a detected code -> [ItemDetailsPage].
/// [ItemCreatePage] on success -> [ItemQrSharePage].
/// [ItemDetailsPage] -> [ItemEditPage] (admins) or [DraftPage] (the button).
class AppRouter {
  AppRouter(this._authService) {
    router = GoRouter(
      initialLocation: SplashPage.path,
      refreshListenable: _authService,
      redirect: _redirect,
      routes: [
        GoRoute(
          path: SplashPage.path,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: LoginPage.path,
          builder: (context, state) => const LoginPage(),
        ),
        // Outside the shell on purpose: the draft page is opened *from* the
        // shell's floating draft button, so it must not show that button.
        GoRoute(
          path: DraftPage.path,
          builder: (context, state) => const DraftPage(),
        ),
        ShellRoute(
          builder: (context, state, child) => DraftFabScaffold(child: child),
          routes: [
            GoRoute(
              path: HomePage.path,
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: ScanPage.path,
              builder: (context, state) => const ScanPage(),
            ),
            // Declared before the '/items/:id' route so the literal segment
            // wins over the path parameter.
            GoRoute(
              path: ItemCreatePage.path,
              builder: (context, state) => const ItemCreatePage(),
            ),
            GoRoute(
              path: ItemEditPage.path,
              builder: (context, state) => ItemEditPage(
                itemId: state.pathParameters['id']!,
              ),
            ),
            GoRoute(
              path: ItemDetailsPage.path,
              builder: (context, state) => ItemDetailsPage(
                itemId: state.pathParameters['id']!,
              ),
            ),
            GoRoute(
              path: ItemQrSharePage.path,
              builder: (context, state) => ItemQrSharePage(
                itemId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  final AuthService _authService;
  late final GoRouter router;

  String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;

    return switch (_authService.status) {
      AuthStatus.unknown => location == SplashPage.path ? null : SplashPage.path,
      AuthStatus.unauthenticated => location == LoginPage.path ? null : LoginPage.path,
      AuthStatus.authenticated =>
        location == SplashPage.path || location == LoginPage.path ? HomePage.path : null,
    };
  }
}
