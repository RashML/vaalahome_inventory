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
  String get itemQrShareCta => 'اشتراک‌گذاری';

  @override
  String get itemQrPrintCta => 'چاپ';

  @override
  String get itemQrShareError => 'اشتراک‌گذاری QR ناموفق بود.';

  @override
  String get itemQrPrintError => 'چاپ QR ناموفق بود.';

  @override
  String get itemFormSectionBasics => 'اطلاعات پایه';

  @override
  String get itemFormNameLabel => 'نام';

  @override
  String get itemFormCompanyLabel => 'شرکت';

  @override
  String get itemFormCompanyHint => 'انتخاب شرکت';

  @override
  String get itemFormCompanySearchHint => 'جستجوی شرکت';

  @override
  String get itemFormBundleLabel => 'بسته';

  @override
  String get itemFormBundleHint => 'انتخاب بسته';

  @override
  String get itemFormBundleHintNoCompany => 'ابتدا شرکت را انتخاب کنید';

  @override
  String get itemFormBundleSearchHint => 'جستجوی بسته';

  @override
  String get itemFormColorLabel => 'کد رنگ';

  @override
  String get itemFormColorHint => '#FF8800';

  @override
  String get itemFormSectionSize => 'ابعاد';

  @override
  String get itemFormSizeTypeSize => 'عرض × ارتفاع';

  @override
  String get itemFormSizeTypeArea => 'مساحت';

  @override
  String get itemFormWidthLabel => 'عرض';

  @override
  String get itemFormHeightLabel => 'ارتفاع';

  @override
  String get itemFormAreaLabel => 'مساحت (متر مربع)';

  @override
  String get itemFormSectionPricing => 'قیمت‌گذاری';

  @override
  String get itemFormBuyPriceSubtitle => 'قیمت خرید';

  @override
  String get itemFormSellPriceSubtitle => 'قیمت فروش';

  @override
  String get itemFormAmountLabel => 'مبلغ';

  @override
  String get itemFormCurrencyLabel => 'ارز';

  @override
  String get itemFormCurrencyHint => 'انتخاب ارز';

  @override
  String get itemFormCurrencySearchHint => 'جستجوی ارز';

  @override
  String get itemFormSubmitCta => 'ثبت کالا';

  @override
  String get itemFormRequiredField => 'این فیلد الزامی است.';

  @override
  String get itemFormInvalidNumber => 'عدد معتبر وارد کنید.';

  @override
  String get itemFormInvalidColor => 'رنگ هگز معتبر وارد کنید، مثلاً #FF8800.';

  @override
  String get itemFormLoadError => 'بارگذاری اطلاعات فرم ناموفق بود.';

  @override
  String get itemFormCreateError => 'ثبت کالا ناموفق بود.';

  @override
  String get itemFormNoResultFound => 'نتیجه‌ای یافت نشد.';

  @override
  String get itemFormRetryCta => 'تلاش مجدد';

  @override
  String get itemDetailsSectionPrice => 'قیمت';

  @override
  String get itemDetailsSellPriceLabel => 'قیمت فروش';

  @override
  String get itemDetailsFinalPriceLabel => 'قیمت نهایی';

  @override
  String get itemDetailsRialSuffix => 'ریال';

  @override
  String get itemDetailsBuyPriceLabel => 'قیمت خرید';

  @override
  String get itemDetailsHoldHint => 'ادمین: برای نمایش قیمت خرید ۵ ثانیه لمس نگه دارید';

  @override
  String get itemDetailsSectionDetails => 'جزئیات';

  @override
  String get itemDetailsUnitCm => 'سانتی‌متر';

  @override
  String get itemDetailsLoadError => 'بارگذاری جزئیات کالا ناموفق بود.';
}
