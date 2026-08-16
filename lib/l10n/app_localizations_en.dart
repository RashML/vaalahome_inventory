// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Inventory App';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginCta => 'Login';

  @override
  String get loginError => 'Incorrect email or password.';

  @override
  String get homeTitle => 'Home';

  @override
  String get scanTitle => 'Scan';

  @override
  String get itemCreateTitle => 'Create item';

  @override
  String itemDetailsTitle(String itemId) {
    return 'Item $itemId';
  }

  @override
  String itemQrShareTitle(String itemId) {
    return 'Share QR for $itemId';
  }
}
