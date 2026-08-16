import 'package:flutter/material.dart';

/// Toast-style feedback via [SnackBar] — identical on every platform Flutter
/// targets (native + web), no extra package needed.
class AppToast {
  const AppToast._();

  static void show(BuildContext context, String message) =>
      _show(context, message, isError: false);

  static void error(BuildContext context, String message) =>
      _show(context, message, isError: true);

  static void _show(BuildContext context, String message, {required bool isError}) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? colorScheme.error : colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
  }
}
