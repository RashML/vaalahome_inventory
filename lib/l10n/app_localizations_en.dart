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
  String get itemQrShareCta => 'Share';

  @override
  String get itemQrPrintCta => 'Print';

  @override
  String get itemQrShareError => 'Couldn\'t share the QR code.';

  @override
  String get itemQrPrintError => 'Couldn\'t print the QR code.';

  @override
  String get itemFormSectionBasics => 'Basic details';

  @override
  String get itemFormNameLabel => 'Name';

  @override
  String get itemFormCompanyLabel => 'Company';

  @override
  String get itemFormCompanyHint => 'Select company';

  @override
  String get itemFormCompanySearchHint => 'Search companies';

  @override
  String get itemFormBundleLabel => 'Bundle';

  @override
  String get itemFormBundleHint => 'Select bundle';

  @override
  String get itemFormBundleHintNoCompany => 'Select a company first';

  @override
  String get itemFormBundleSearchHint => 'Search bundles';

  @override
  String get itemFormColorLabel => 'Color code';

  @override
  String get itemFormColorHint => '#FF8800';

  @override
  String get itemFormSectionSize => 'Size';

  @override
  String get itemFormSizeTypeSize => 'Width × height';

  @override
  String get itemFormSizeTypeArea => 'Area';

  @override
  String get itemFormWidthLabel => 'Width';

  @override
  String get itemFormHeightLabel => 'Height';

  @override
  String get itemFormAreaLabel => 'Area (m²)';

  @override
  String get itemFormSectionPricing => 'Pricing';

  @override
  String get itemFormBuyPriceSubtitle => 'Buy price';

  @override
  String get itemFormSellPriceSubtitle => 'Sell price';

  @override
  String get itemFormAmountLabel => 'Amount';

  @override
  String get itemFormCurrencyLabel => 'Currency';

  @override
  String get itemFormCurrencyHint => 'Select currency';

  @override
  String get itemFormCurrencySearchHint => 'Search currencies';

  @override
  String get itemFormSubmitCta => 'Create item';

  @override
  String get itemFormRequiredField => 'This field is required.';

  @override
  String get itemFormInvalidNumber => 'Enter a valid number.';

  @override
  String get itemFormInvalidColor => 'Enter a valid hex color, e.g. #FF8800.';

  @override
  String get itemFormLoadError => 'Couldn\'t load form data.';

  @override
  String get itemFormCreateError => 'Couldn\'t create item.';

  @override
  String get itemFormNoResultFound => 'No results found.';

  @override
  String get itemFormRetryCta => 'Retry';

  @override
  String get itemDetailsSectionPrice => 'Price';

  @override
  String get itemDetailsSellPriceLabel => 'Sell price';

  @override
  String get itemDetailsFinalPriceLabel => 'Final price';

  @override
  String get itemDetailsRialSuffix => 'Rial';

  @override
  String get itemDetailsBuyPriceLabel => 'Buy price';

  @override
  String get itemDetailsHoldHint => 'Admin: hold for 5 seconds to reveal the buy price';

  @override
  String get itemDetailsSectionDetails => 'Details';

  @override
  String get itemDetailsUnitCm => 'cm';

  @override
  String get itemDetailsLoadError => 'Couldn\'t load item details.';

  @override
  String get itemEditTitle => 'Edit item';

  @override
  String get itemFormSizeTypeWidth => 'Width';

  @override
  String get itemFormSizeTypeHeight => 'Height';

  @override
  String get itemFormFixedHeightLabel => 'Fixed height (cm)';

  @override
  String get itemFormFixedWidthLabel => 'Fixed width (cm)';

  @override
  String get itemFormAreaHint => 'Area items are entered in m² when ordered — nothing to set here.';

  @override
  String get itemFormSaveCta => 'Save changes';

  @override
  String get itemFormUpdateError => 'Couldn\'t update item.';

  @override
  String get itemFormUpdateSuccess => 'Item updated.';

  @override
  String get itemDetailsEditCta => 'Edit';

  @override
  String get itemDetailsDimensionLabel => 'Sold by';

  @override
  String get itemDetailsUnitSquareMeter => 'm²';

  @override
  String get itemDetailsAddToDraftTitle => 'Add to order draft';

  @override
  String get itemDetailsAddToDraftCta => 'Add to draft';

  @override
  String get itemDetailsAddedToDraft => 'Added to the draft.';

  @override
  String get draftValueLabelWidth => 'Width to order';

  @override
  String get draftValueLabelHeight => 'Height to order';

  @override
  String get draftValueLabelArea => 'Area to order (m²)';

  @override
  String get draftTitle => 'Order draft';

  @override
  String get draftFabTooltip => 'Order draft';

  @override
  String get draftEmpty => 'The order draft is empty.';

  @override
  String get draftUnitPriceLabel => 'Unit price';

  @override
  String get draftLineTotalLabel => 'Line total';

  @override
  String get draftTotalLabel => 'Total';

  @override
  String get draftRemoveTitle => 'Remove line?';

  @override
  String get draftRemoveMessage => 'This line will be removed from the order draft.';

  @override
  String get draftRemoveConfirmCta => 'Remove';

  @override
  String get draftClearCta => 'Clear draft';

  @override
  String get draftClearTitle => 'Clear draft?';

  @override
  String get draftClearMessage => 'Every line will be removed from the draft.';

  @override
  String get draftCancelCta => 'Cancel';
}
