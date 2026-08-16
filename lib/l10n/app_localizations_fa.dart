// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'انبارداری';

  @override
  String get loginEmailLabel => 'ایمیل';

  @override
  String get loginPasswordLabel => 'رمز عبور';

  @override
  String get loginCta => 'ورود';

  @override
  String get loginError => 'ایمیل یا رمز عبور نادرست است.';

  @override
  String get homeTitle => 'خانه';

  @override
  String get scanTitle => 'اسکن';

  @override
  String get itemCreateTitle => 'افزودن کالا';

  @override
  String itemDetailsTitle(String itemId) {
    return 'کالا $itemId';
  }

  @override
  String itemQrShareTitle(String itemId) {
    return 'اشتراک‌گذاری QR برای $itemId';
  }
}
