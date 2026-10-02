import 'package:flutter_test/flutter_test.dart';

import 'package:inventory_app/shared/models/currency.dart';
import 'package:inventory_app/shared/models/dimension.dart';
import 'package:inventory_app/shared/models/size_unit.dart';

void main() {
  group('Dimension units', () {
    test('reads and writes an explicit unit', () {
      final dim = Dimension.fromJson({'type': 'width', 'height': 1.4, 'unit': 'm'});

      expect(dim, isA<WidthDimension>());
      expect(dim.unit, SizeUnit.m);
      expect((dim as WidthDimension).fixedHeight, 1.4);
      expect(dim.toJson(), {'type': 'width', 'unit': 'm', 'height': 1.4});
    });

    test('records saved before units existed use the kind default', () {
      expect(Dimension.fromJson({'type': 'width', 'height': 140}).unit, SizeUnit.cm);
      expect(Dimension.fromJson({'type': 'height', 'width': 100}).unit, SizeUnit.cm);
      expect(Dimension.fromJson({'type': 'area'}).unit, SizeUnit.m2);
      expect(Dimension.fromJson({'type': 'size', 'height': 90}).unit, SizeUnit.cm);
    });

    test('an unknown unit falls back to the kind default', () {
      expect(Dimension.fromJson({'type': 'area', 'unit': 'furlong'}).unit, SizeUnit.m2);
    });

    test('area serializes its unit', () {
      expect(const AreaDimension().toJson(), {'type': 'area', 'unit': 'm2'});
    });

    test('allowed units per kind', () {
      expect(DimensionKind.width.allowedUnits, [SizeUnit.cm, SizeUnit.m]);
      expect(DimensionKind.height.allowedUnits, [SizeUnit.cm, SizeUnit.m]);
      expect(DimensionKind.area.allowedUnits, [SizeUnit.m2]);
      expect(DimensionKind.area.defaultUnit, SizeUnit.m2);
    });
  });

  group('Currency labels', () {
    const aed = Currency(code: 'AED', displayUnit: 'درهم', rateInRial: 450000);
    const bare = Currency(code: 'USD', displayUnit: '', rateInRial: 1);

    test('full label shows the localized name and the code', () {
      expect(aed.fullLabel, 'درهم (AED)');
      expect(aed.shortLabel, 'درهم');
    });

    test('falls back to the code when there is no display name', () {
      expect(bare.fullLabel, 'USD');
      expect(bare.shortLabel, 'USD');
    });
  });
}
