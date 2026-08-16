import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/di/locator.dart';
import '../../../shared/utils/validators.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/cta_button.dart';
import '../data/auth_repository.dart';

class LoginPage extends StatefulWidget {
  static const path = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TODO: replace with the real Instagram profile URL.
  static const _instagramUrl = 'https://instagram.com/REPLACE_ME';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_revalidate);
    _passwordController.addListener(_revalidate);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _revalidate() {
    final isValid =
        Validators.isEmail(_emailController.text) && _passwordController.text.isNotEmpty;
    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  Future<void> _openInstagram() {
    return launchUrl(Uri.parse(_instagramUrl), mode: LaunchMode.externalApplication);
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    try {
      await getIt<AuthRepository>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // No explicit navigation here: AuthService picks up the resulting
      // auth-state change and AppRouter's redirect sends the app to
      // HomePage on its own (see shared/navigation/app_router.dart).
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, AppLocalizations.of(context)!.loginError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.link),
            tooltip: 'Instagram',
            onPressed: _openInstagram,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: l10n.loginEmailLabel),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: l10n.loginPasswordLabel),
              ),
              const SizedBox(height: 24),
              CtaButton(
                label: l10n.loginCta,
                loading: _isLoading,
                onPressed: _isFormValid ? _submit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
