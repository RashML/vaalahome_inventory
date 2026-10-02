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
  String get homeScanCta => 'اسکن کالا';

  @override
  String get homeCreateCta => 'افزودن کالا';

  @override
  String get scanTitle => 'اسکن';

  @override
  String get scanPermissionDenied => 'دسترسی به دوربین مسدود است';

  @override
  String get scanPermissionStepsApp =>
      'در تنظیمات گوشی، دسترسی دوربین را برای این برنامه مجاز کنید، سپس برگردید و «تلاش مجدد» را بزنید.';

  @override
  String get scanPermissionStepsWeb =>
      'دسترسی دوربین را برای این سایت در مرورگر مجاز کنید، سپس «تلاش مجدد» را بزنید.\n\nسافاری آیفون: تنظیمات ← Safari ← Camera ← Ask یا Allow (یا روی آیکون aA در نوار آدرس بزنید ← Website Settings ← Camera).\nکروم / اندروید: روی آیکون قفل کنار آدرس بزنید ← Permissions ← Camera ← Allow.';

  @override
  String get scanOpenSettingsCta => 'باز کردن تنظیمات';

  @override
  String get scanCameraError => 'راه‌اندازی دوربین ناموفق بود.';

  @override
  String get scanInvalidCode => 'این کد QR مربوط به کالا نیست.';

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
  String get itemFormColorHint => 'مثلاً 1024';

  @override
  String get itemFormSectionImages => 'تصاویر';

  @override
  String get itemFormAddImagesCta => 'افزودن تصویر';

  @override
  String get itemFormImagesUploadError =>
      'کالا ذخیره شد، اما بارگذاری تصاویر ناموفق بود.';

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
  String get itemDetailsHoldHint =>
      'ادمین: برای نمایش قیمت خرید ۵ ثانیه لمس نگه دارید';

  @override
  String get itemDetailsSectionDetails => 'جزئیات';

  @override
  String get itemDetailsUnitMeter => 'متر';

  @override
  String get itemFormUnitLabel => 'واحد';

  @override
  String get itemDetailsUnitCm => 'سانتی‌متر';

  @override
  String get itemDetailsLoadError => 'بارگذاری جزئیات کالا ناموفق بود.';

  @override
  String get itemEditTitle => 'ویرایش کالا';

  @override
  String get itemFormSizeTypeWidth => 'عرض';

  @override
  String get itemFormSizeTypeHeight => 'ارتفاع';

  @override
  String get itemFormFixedHeightLabel => 'ارتفاع ثابت';

  @override
  String get itemFormFixedWidthLabel => 'عرض ثابت';

  @override
  String get itemFormAreaHint =>
      'کالاهای مساحتی هنگام سفارش بر حسب متر مربع وارد می‌شوند؛ اینجا مقداری لازم نیست.';

  @override
  String get itemFormSaveCta => 'ذخیره تغییرات';

  @override
  String get itemFormUpdateError => 'ویرایش کالا ناموفق بود.';

  @override
  String get itemFormUpdateSuccess => 'کالا ویرایش شد.';

  @override
  String get itemDetailsEditCta => 'ویرایش';

  @override
  String get itemDetailsDimensionLabel => 'فروش بر اساس';

  @override
  String get itemDetailsUnitSquareMeter => 'متر مربع';

  @override
  String get itemDetailsAddToDraftTitle => 'افزودن به پیش‌نویس سفارش';

  @override
  String get itemDetailsAddToDraftCta => 'افزودن به پیش‌نویس';

  @override
  String get itemDetailsAddedToDraft => 'به پیش‌نویس اضافه شد.';

  @override
  String get draftValueLabelWidth => 'عرض سفارش';

  @override
  String get draftValueLabelHeight => 'ارتفاع سفارش';

  @override
  String get draftValueLabelArea => 'مساحت سفارش';

  @override
  String get draftTitle => 'پیش‌نویس سفارش';

  @override
  String get draftFabTooltip => 'پیش‌نویس سفارش';

  @override
  String get draftEmpty => 'پیش‌نویس سفارش خالی است.';

  @override
  String get draftUnitPriceLabel => 'قیمت واحد';

  @override
  String get draftLineTotalLabel => 'جمع ردیف';

  @override
  String get draftTotalLabel => 'جمع کل';

  @override
  String get draftRemoveTitle => 'حذف ردیف؟';

  @override
  String get draftRemoveMessage => 'این ردیف از پیش‌نویس سفارش حذف می‌شود.';

  @override
  String get draftRemoveConfirmCta => 'حذف';

  @override
  String get draftClearCta => 'خالی کردن پیش‌نویس';

  @override
  String get draftClearTitle => 'خالی کردن پیش‌نویس؟';

  @override
  String get draftClearMessage => 'همه ردیف‌های پیش‌نویس حذف می‌شوند.';

  @override
  String get draftCancelCta => 'انصراف';
}
