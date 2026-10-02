import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

  /// The application title.
  ///
  /// In fa, this message translates to:
  /// **'انبارداری'**
  String get appTitle;

  /// Label of the email field on the login page.
  ///
  /// In fa, this message translates to:
  /// **'ایمیل'**
  String get loginEmailLabel;

  /// Label of the password field on the login page.
  ///
  /// In fa, this message translates to:
  /// **'رمز عبور'**
  String get loginPasswordLabel;

  /// Label of the login page's submit button.
  ///
  /// In fa, this message translates to:
  /// **'ورود'**
  String get loginCta;

  /// Shown when login fails.
  ///
  /// In fa, this message translates to:
  /// **'ایمیل یا رمز عبور نادرست است.'**
  String get loginError;

  /// Title of the home page.
  ///
  /// In fa, this message translates to:
  /// **'خانه'**
  String get homeTitle;

  /// Label of the home page's scan-item action.
  ///
  /// In fa, this message translates to:
  /// **'اسکن کالا'**
  String get homeScanCta;

  /// Label of the home page's create-item action.
  ///
  /// In fa, this message translates to:
  /// **'افزودن کالا'**
  String get homeCreateCta;

  /// Title of the QR/barcode scan page.
  ///
  /// In fa, this message translates to:
  /// **'اسکن'**
  String get scanTitle;

  /// Title shown on the scan page when camera permission is denied.
  ///
  /// In fa, this message translates to:
  /// **'دسترسی به دوربین مسدود است'**
  String get scanPermissionDenied;

  /// Guide shown on the scan page (native app) telling the user how to re-enable camera access.
  ///
  /// In fa, this message translates to:
  /// **'در تنظیمات گوشی، دسترسی دوربین را برای این برنامه مجاز کنید، سپس برگردید و «تلاش مجدد» را بزنید.'**
  String get scanPermissionStepsApp;

  /// Guide shown on the scan page (web) telling the user how to re-enable camera access in the browser.
  ///
  /// In fa, this message translates to:
  /// **'دسترسی دوربین را برای این سایت در مرورگر مجاز کنید، سپس «تلاش مجدد» را بزنید.\n\nسافاری آیفون: تنظیمات ← Safari ← Camera ← Ask یا Allow (یا روی آیکون aA در نوار آدرس بزنید ← Website Settings ← Camera).\nکروم / اندروید: روی آیکون قفل کنار آدرس بزنید ← Permissions ← Camera ← Allow.'**
  String get scanPermissionStepsWeb;

  /// Button on the scan page that opens the OS app settings.
  ///
  /// In fa, this message translates to:
  /// **'باز کردن تنظیمات'**
  String get scanOpenSettingsCta;

  /// Shown on the scan page when the camera fails to start.
  ///
  /// In fa, this message translates to:
  /// **'راه‌اندازی دوربین ناموفق بود.'**
  String get scanCameraError;

  /// Toast shown when a scanned QR code isn't an item code.
  ///
  /// In fa, this message translates to:
  /// **'این کد QR مربوط به کالا نیست.'**
  String get scanInvalidCode;

  /// Title of the item-creation form page.
  ///
  /// In fa, this message translates to:
  /// **'افزودن کالا'**
  String get itemCreateTitle;

  /// Title of the item details page.
  ///
  /// In fa, this message translates to:
  /// **'کالا {itemId}'**
  String itemDetailsTitle(String itemId);

  /// Label of the share button on the item QR page.
  ///
  /// In fa, this message translates to:
  /// **'اشتراک‌گذاری'**
  String get itemQrShareCta;

  /// Label of the print button on the item QR page.
  ///
  /// In fa, this message translates to:
  /// **'چاپ'**
  String get itemQrPrintCta;

  /// Shown when sharing the item QR fails.
  ///
  /// In fa, this message translates to:
  /// **'اشتراک‌گذاری QR ناموفق بود.'**
  String get itemQrShareError;

  /// Shown when printing the item QR fails.
  ///
  /// In fa, this message translates to:
  /// **'چاپ QR ناموفق بود.'**
  String get itemQrPrintError;

  /// Title of the basic-details section of the item form.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات پایه'**
  String get itemFormSectionBasics;

  /// Label of the item name field.
  ///
  /// In fa, this message translates to:
  /// **'نام'**
  String get itemFormNameLabel;

  /// Label of the company field.
  ///
  /// In fa, this message translates to:
  /// **'شرکت'**
  String get itemFormCompanyLabel;

  /// Placeholder of the company dropdown before a selection is made.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب شرکت'**
  String get itemFormCompanyHint;

  /// Placeholder of the company dropdown's search field.
  ///
  /// In fa, this message translates to:
  /// **'جستجوی شرکت'**
  String get itemFormCompanySearchHint;

  /// Label of the bundle field.
  ///
  /// In fa, this message translates to:
  /// **'بسته'**
  String get itemFormBundleLabel;

  /// Placeholder of the bundle dropdown before a selection is made.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب بسته'**
  String get itemFormBundleHint;

  /// Placeholder of the bundle dropdown while no company is selected yet.
  ///
  /// In fa, this message translates to:
  /// **'ابتدا شرکت را انتخاب کنید'**
  String get itemFormBundleHintNoCompany;

  /// Placeholder of the bundle dropdown's search field.
  ///
  /// In fa, this message translates to:
  /// **'جستجوی بسته'**
  String get itemFormBundleSearchHint;

  /// Label of the color code field.
  ///
  /// In fa, this message translates to:
  /// **'کد رنگ'**
  String get itemFormColorLabel;

  /// Placeholder showing an example color code (free text).
  ///
  /// In fa, this message translates to:
  /// **'مثلاً 1024'**
  String get itemFormColorHint;

  /// Title of the images section of the item form.
  ///
  /// In fa, this message translates to:
  /// **'تصاویر'**
  String get itemFormSectionImages;

  /// Button that opens the photo picker to add item images.
  ///
  /// In fa, this message translates to:
  /// **'افزودن تصویر'**
  String get itemFormAddImagesCta;

  /// Toast shown when the item saved but uploading its images failed.
  ///
  /// In fa, this message translates to:
  /// **'کالا ذخیره شد، اما بارگذاری تصاویر ناموفق بود.'**
  String get itemFormImagesUploadError;

  /// Title of the size/dimension section of the item form.
  ///
  /// In fa, this message translates to:
  /// **'ابعاد'**
  String get itemFormSectionSize;

  /// Segmented option for entering size as width and height.
  ///
  /// In fa, this message translates to:
  /// **'عرض × ارتفاع'**
  String get itemFormSizeTypeSize;

  /// Segmented option for entering size as an area.
  ///
  /// In fa, this message translates to:
  /// **'مساحت'**
  String get itemFormSizeTypeArea;

  /// Label of the width field.
  ///
  /// In fa, this message translates to:
  /// **'عرض'**
  String get itemFormWidthLabel;

  /// Label of the height field.
  ///
  /// In fa, this message translates to:
  /// **'ارتفاع'**
  String get itemFormHeightLabel;

  /// Label of the area field.
  ///
  /// In fa, this message translates to:
  /// **'مساحت (متر مربع)'**
  String get itemFormAreaLabel;

  /// Title of the pricing section of the item form.
  ///
  /// In fa, this message translates to:
  /// **'قیمت‌گذاری'**
  String get itemFormSectionPricing;

  /// Subtitle above the buy-price amount/currency fields.
  ///
  /// In fa, this message translates to:
  /// **'قیمت خرید'**
  String get itemFormBuyPriceSubtitle;

  /// Subtitle above the sell-price amount/currency fields.
  ///
  /// In fa, this message translates to:
  /// **'قیمت فروش'**
  String get itemFormSellPriceSubtitle;

  /// Label of a price amount field.
  ///
  /// In fa, this message translates to:
  /// **'مبلغ'**
  String get itemFormAmountLabel;

  /// Label of a currency field.
  ///
  /// In fa, this message translates to:
  /// **'ارز'**
  String get itemFormCurrencyLabel;

  /// Placeholder of a currency dropdown before a selection is made.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب ارز'**
  String get itemFormCurrencyHint;

  /// Placeholder of a currency dropdown's search field.
  ///
  /// In fa, this message translates to:
  /// **'جستجوی ارز'**
  String get itemFormCurrencySearchHint;

  /// Label of the item form's submit button.
  ///
  /// In fa, this message translates to:
  /// **'ثبت کالا'**
  String get itemFormSubmitCta;

  /// Validation message for an empty required field.
  ///
  /// In fa, this message translates to:
  /// **'این فیلد الزامی است.'**
  String get itemFormRequiredField;

  /// Validation message for a numeric field with an invalid value.
  ///
  /// In fa, this message translates to:
  /// **'عدد معتبر وارد کنید.'**
  String get itemFormInvalidNumber;

  /// Shown when the item form fails to load its dropdown data.
  ///
  /// In fa, this message translates to:
  /// **'بارگذاری اطلاعات فرم ناموفق بود.'**
  String get itemFormLoadError;

  /// Shown when creating the item fails.
  ///
  /// In fa, this message translates to:
  /// **'ثبت کالا ناموفق بود.'**
  String get itemFormCreateError;

  /// Shown in a dropdown's search list when no items match.
  ///
  /// In fa, this message translates to:
  /// **'نتیجه‌ای یافت نشد.'**
  String get itemFormNoResultFound;

  /// Label of the retry button shown after a load error.
  ///
  /// In fa, this message translates to:
  /// **'تلاش مجدد'**
  String get itemFormRetryCta;

  /// Title of the price section on the item details page.
  ///
  /// In fa, this message translates to:
  /// **'قیمت'**
  String get itemDetailsSectionPrice;

  /// Label for the item's sell price, in its original currency.
  ///
  /// In fa, this message translates to:
  /// **'قیمت فروش'**
  String get itemDetailsSellPriceLabel;

  /// Label for the sell price converted to Rial.
  ///
  /// In fa, this message translates to:
  /// **'قیمت نهایی'**
  String get itemDetailsFinalPriceLabel;

  /// Unit suffix shown after a Rial amount.
  ///
  /// In fa, this message translates to:
  /// **'ریال'**
  String get itemDetailsRialSuffix;

  /// Label for the item's buy price, shown in the admin-only reveal drawer.
  ///
  /// In fa, this message translates to:
  /// **'قیمت خرید'**
  String get itemDetailsBuyPriceLabel;

  /// Hint shown to admins under the price card, explaining the hold-to-reveal gesture.
  ///
  /// In fa, this message translates to:
  /// **'ادمین: برای نمایش قیمت خرید ۵ ثانیه لمس نگه دارید'**
  String get itemDetailsHoldHint;

  /// Title of the key-value details section on the item details page.
  ///
  /// In fa, this message translates to:
  /// **'جزئیات'**
  String get itemDetailsSectionDetails;

  /// Unit name for meters, shown after a width/height value.
  ///
  /// In fa, this message translates to:
  /// **'متر'**
  String get itemDetailsUnitMeter;

  /// Label of the size unit selector / row (cm, m, m²).
  ///
  /// In fa, this message translates to:
  /// **'واحد'**
  String get itemFormUnitLabel;

  /// Unit suffix shown after a width/height value.
  ///
  /// In fa, this message translates to:
  /// **'سانتی‌متر'**
  String get itemDetailsUnitCm;

  /// Shown when the item details page fails to load its data.
  ///
  /// In fa, this message translates to:
  /// **'بارگذاری جزئیات کالا ناموفق بود.'**
  String get itemDetailsLoadError;

  /// Title of the item-edit form page.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش کالا'**
  String get itemEditTitle;

  /// Label of the width option in the item form's dimension-kind selector.
  ///
  /// In fa, this message translates to:
  /// **'عرض'**
  String get itemFormSizeTypeWidth;

  /// Label of the height option in the item form's dimension-kind selector.
  ///
  /// In fa, this message translates to:
  /// **'ارتفاع'**
  String get itemFormSizeTypeHeight;

  /// Label of the fixed-height field, shown for items sold by width.
  ///
  /// In fa, this message translates to:
  /// **'ارتفاع ثابت'**
  String get itemFormFixedHeightLabel;

  /// Label of the fixed-width field, shown for items sold by height.
  ///
  /// In fa, this message translates to:
  /// **'عرض ثابت'**
  String get itemFormFixedWidthLabel;

  /// Explains why the size section has no fields for area items.
  ///
  /// In fa, this message translates to:
  /// **'کالاهای مساحتی هنگام سفارش بر حسب متر مربع وارد می‌شوند؛ اینجا مقداری لازم نیست.'**
  String get itemFormAreaHint;

  /// Label of the item-edit form's submit button.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره تغییرات'**
  String get itemFormSaveCta;

  /// Shown when updating an item fails.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش کالا ناموفق بود.'**
  String get itemFormUpdateError;

  /// Shown when an item is updated successfully.
  ///
  /// In fa, this message translates to:
  /// **'کالا ویرایش شد.'**
  String get itemFormUpdateSuccess;

  /// Label of the admin-only edit action on the item details page.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش'**
  String get itemDetailsEditCta;

  /// Label of the row naming which axis the item is sold by.
  ///
  /// In fa, this message translates to:
  /// **'فروش بر اساس'**
  String get itemDetailsDimensionLabel;

  /// Unit suffix shown after an area value.
  ///
  /// In fa, this message translates to:
  /// **'متر مربع'**
  String get itemDetailsUnitSquareMeter;

  /// Title of the add-to-draft section on the item details page.
  ///
  /// In fa, this message translates to:
  /// **'افزودن به پیش‌نویس سفارش'**
  String get itemDetailsAddToDraftTitle;

  /// Label of the add-to-draft button on the item details page.
  ///
  /// In fa, this message translates to:
  /// **'افزودن به پیش‌نویس'**
  String get itemDetailsAddToDraftCta;

  /// Shown after an item is added to the order draft.
  ///
  /// In fa, this message translates to:
  /// **'به پیش‌نویس اضافه شد.'**
  String get itemDetailsAddedToDraft;

  /// Label of the ordered-value field for items sold by width.
  ///
  /// In fa, this message translates to:
  /// **'عرض سفارش'**
  String get draftValueLabelWidth;

  /// Label of the ordered-value field for items sold by height.
  ///
  /// In fa, this message translates to:
  /// **'ارتفاع سفارش'**
  String get draftValueLabelHeight;

  /// Label of the ordered-value field for items sold by area.
  ///
  /// In fa, this message translates to:
  /// **'مساحت سفارش'**
  String get draftValueLabelArea;

  /// Title of the order draft page.
  ///
  /// In fa, this message translates to:
  /// **'پیش‌نویس سفارش'**
  String get draftTitle;

  /// Tooltip of the floating order-draft button.
  ///
  /// In fa, this message translates to:
  /// **'پیش‌نویس سفارش'**
  String get draftFabTooltip;

  /// Shown when the order draft has no lines.
  ///
  /// In fa, this message translates to:
  /// **'پیش‌نویس سفارش خالی است.'**
  String get draftEmpty;

  /// Label of a draft line's unit price.
  ///
  /// In fa, this message translates to:
  /// **'قیمت واحد'**
  String get draftUnitPriceLabel;

  /// Label of a draft line's total price.
  ///
  /// In fa, this message translates to:
  /// **'جمع ردیف'**
  String get draftLineTotalLabel;

  /// Label of the order draft's grand total.
  ///
  /// In fa, this message translates to:
  /// **'جمع کل'**
  String get draftTotalLabel;

  /// Title of the confirmation alert shown before removing a draft line.
  ///
  /// In fa, this message translates to:
  /// **'حذف ردیف؟'**
  String get draftRemoveTitle;

  /// Body of the confirmation alert shown before removing a draft line.
  ///
  /// In fa, this message translates to:
  /// **'این ردیف از پیش‌نویس سفارش حذف می‌شود.'**
  String get draftRemoveMessage;

  /// Label of the confirm action in the remove-line alert.
  ///
  /// In fa, this message translates to:
  /// **'حذف'**
  String get draftRemoveConfirmCta;

  /// Label of the clear-draft action on the order draft page.
  ///
  /// In fa, this message translates to:
  /// **'خالی کردن پیش‌نویس'**
  String get draftClearCta;

  /// Title of the confirmation alert shown before clearing the draft.
  ///
  /// In fa, this message translates to:
  /// **'خالی کردن پیش‌نویس؟'**
  String get draftClearTitle;

  /// Body of the confirmation alert shown before clearing the draft.
  ///
  /// In fa, this message translates to:
  /// **'همه ردیف‌های پیش‌نویس حذف می‌شوند.'**
  String get draftClearMessage;

  /// Label of the dismiss action in the draft confirmation alerts.
  ///
  /// In fa, this message translates to:
  /// **'انصراف'**
  String get draftCancelCta;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
