import 'package:flutter_test/flutter_test.dart';

import 'package:inventory_app/features/order/data/draft_order_service.dart';
import 'package:inventory_app/features/order/models/draft_line.dart';
import 'package:inventory_app/shared/models/currency.dart';
import 'package:inventory_app/shared/models/dimension.dart';
import 'package:inventory_app/shared/models/item.dart';
import 'package:inventory_app/shared/models/price.dart';

const _aed = Currency(code: 'AED', displayUnit: 'درهم', rateInRial: 450000);
const _try = Currency(code: 'TRY', displayUnit: 'لیر', rateInRial: 20000);
const _irr = Currency(code: 'IRR', displayUnit: 'ریال', rateInRial: 1);

Item _item({required double sellAmount, required String sellCurrency}) => Item(
      id: 'item1',
      name: 'Test fabric',
      companyId: 'company1',
      size: const AreaDimension(),
      buyPrice: Price(amount: 1, currencyCode: sellCurrency),
      sellPrice: Price(amount: sellAmount, currencyCode: sellCurrency),
    );

void main() {
  group('DraftLine rial pricing', () {
    test('unit price = sell amount x currency rate (AED)', () {
      final line = DraftLine(
        item: _item(sellAmount: 12, sellCurrency: 'AED'),
        sellCurrency: _aed,
        value: 1,
      );
      expect(line.unitPriceInRial, 5400000); // 12 * 450,000
    });

    test('unit price = sell amount x currency rate (TRY)', () {
      final line = DraftLine(
        item: _item(sellAmount: 220, sellCurrency: 'TRY'),
        sellCurrency: _try,
        value: 1,
      );
      expect(line.unitPriceInRial, 4400000); // 220 * 20,000
    });

    test('rial-denominated price is unchanged (rate 1)', () {
      final line = DraftLine(
        item: _item(sellAmount: 750000, sellCurrency: 'IRR'),
        sellCurrency: _irr,
        value: 1,
      );
      expect(line.unitPriceInRial, 750000);
    });

    test('line total = unit price x ordered value', () {
      final line = DraftLine(
        item: _item(sellAmount: 12, sellCurrency: 'AED'),
        sellCurrency: _aed,
        value: 2.5,
      );
      expect(line.totalInRial, 13500000); // 5,400,000 * 2.5
    });

    test('a changed rate gives a different price for a new line', () {
      final item = _item(sellAmount: 12, sellCurrency: 'AED');
      const newRate = Currency(code: 'AED', displayUnit: 'درهم', rateInRial: 500000);

      final before = DraftLine(item: item, sellCurrency: _aed, value: 1);
      final after = DraftLine(item: item, sellCurrency: newRate, value: 1);

      expect(before.unitPriceInRial, 5400000);
      expect(after.unitPriceInRial, 6000000); // 12 * 500,000
    });

    test('an existing line keeps the rate it was added with', () {
      final item = _item(sellAmount: 12, sellCurrency: 'AED');
      final line = DraftLine(item: item, sellCurrency: _aed, value: 1);

      // Editing the ordered value must not reprice: the currency is a snapshot.
      final edited = line.copyWith(value: 3);
      expect(edited.sellCurrency.rateInRial, 450000);
      expect(edited.totalInRial, 16200000); // 5,400,000 * 3
    });
  });

  group('DraftOrderService totals', () {
    test('sums lines in mixed currencies, in rial', () {
      final draft = DraftOrderService()
        ..add(DraftLine(
          item: _item(sellAmount: 12, sellCurrency: 'AED'),
          sellCurrency: _aed,
          value: 2,
        )) // 10,800,000
        ..add(DraftLine(
          item: _item(sellAmount: 220, sellCurrency: 'TRY'),
          sellCurrency: _try,
          value: 1.5,
        )); // 6,600,000

      expect(draft.totalInRial, 17400000);
    });

    test('total updates and listeners fire when a line is removed', () {
      final draft = DraftOrderService()
        ..add(DraftLine(
          item: _item(sellAmount: 12, sellCurrency: 'AED'),
          sellCurrency: _aed,
          value: 1,
        ))
        ..add(DraftLine(
          item: _item(sellAmount: 220, sellCurrency: 'TRY'),
          sellCurrency: _try,
          value: 1,
        ));

      var notified = 0;
      draft.addListener(() => notified++);

      draft.removeAt(0);

      expect(notified, 1);
      expect(draft.totalInRial, 4400000);
    });

    test('empty draft totals zero', () {
      expect(DraftOrderService().totalInRial, 0);
    });
  });
}
