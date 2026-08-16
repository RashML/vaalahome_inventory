import 'package:flutter/material.dart';

/// Shown while [AuthService] resolves the initial auth state.
class SplashPage extends StatelessWidget {
  static const path = '/splash';

  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
