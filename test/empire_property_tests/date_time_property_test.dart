import 'package:empire/empire.dart';
import 'package:flutter_test/flutter_test.dart';

class DateTimeViewModel extends EmpireViewModel {
  @override
  void initProperties() {}
}

void main() {
  group('EmpireDateTimeProperty Tests', () {
    late DateTimeViewModel viewModel;
    setUp(() {
      viewModel = DateTimeViewModel();
    });

    test('year - is 1985 - returns 1985', () {
      const int expectedValue = 1985;
      final dateTime = DateTime(expectedValue, 1, 1);
      final property = viewModel.createDateTimeProperty(dateTime);
      expect(property.year, equals(expectedValue));
    });

    test('day - is 1 - returns 1', () {
      const int expectedValue = 1;
      final dateTime = DateTime(1985, 1, 1);
      final property = viewModel.createDateTimeProperty(dateTime);
      expect(property.day, equals(expectedValue));
    });

    test('month - is 10 - returns 10', () {
      const int expectedValue = 10;
      final dateTime = DateTime(1985, expectedValue, 1);
      final property = viewModel.createDateTimeProperty(dateTime);
      expect(property.month, equals(expectedValue));
    });

    test('milliseconds', () {
      final dt1 = DateTime.now();
      final property = viewModel.createDateTimeProperty(dt1);
      final millisecond = dt1.millisecond;

      expect(property.millisecond, equals(millisecond));
    });

    test('millisecondsSinceEpoch', () {
      final dt1 = DateTime.now();
      final property = viewModel.createDateTimeProperty(dt1);
      var millisecondsSinceEpoch = dt1.millisecondsSinceEpoch;
      var dt2 = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

      expect(
          property.millisecondsSinceEpoch, equals(dt2.millisecondsSinceEpoch));
    });

    test('microsecondsSinceEpoch', () {
      final dt1 = DateTime.now();
      final property = viewModel.createDateTimeProperty(dt1);
      var microsecondsSinceEpoch = dt1.microsecondsSinceEpoch;
      var dt2 = DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);

      expect(
          property.microsecondsSinceEpoch, equals(dt2.microsecondsSinceEpoch));
    });

    test('microseconds', () {
      final dt1 = DateTime.now();
      final property = viewModel.createDateTimeProperty(dt1);
      final microsecond = dt1.microsecond;

      expect(property.microsecond, equals(microsecond));
    });

    test('isUtc', () {
      final dt1 = DateTime.now().toUtc();
      final property = viewModel.createDateTimeProperty(dt1);

      expect(property.isUtc, equals(dt1.isUtc));
    });

    test('toUtc', () {
      final dt1 = DateTime.now();
      final property = viewModel.createDateTimeProperty(dt1);

      expect(property.toUtc(), equals(dt1.toUtc()));
    });

    test('toLocal', () {
      final dt1 = DateTime.now().toUtc();
      final property = viewModel.createDateTimeProperty(dt1);

      expect(property.toLocal(), equals(dt1.toLocal()));
    });

    test('add', () {
      final dt1 = DateTime.now();
      const tenDays = Duration(days: 10);
      final property = viewModel.createDateTimeProperty(dt1);

      expect(property.add(tenDays), equals(dt1.add(tenDays)));
    });

    test('subtract', () {
      final dt1 = DateTime.now();
      const tenDays = Duration(days: 10);
      final property = viewModel.createDateTimeProperty(dt1);

      expect(property.subtract(tenDays), equals(dt1.subtract(tenDays)));
    });

    test('isBefore - other is before - returns true', () {
      final dt1 = DateTime.now();
      final dtBefore = DateTime.now().subtract(const Duration(days: 1));

      final property = viewModel.createDateTimeProperty(dtBefore);

      expect(property.isBefore(dt1), isTrue);
    });

    test('isAfter - other is after - returns true', () {
      final dt1 = DateTime.now();
      final dt2 = DateTime.now().add(const Duration(days: 1));

      final property = viewModel.createDateTimeProperty(dt2);

      expect(property.isAfter(dt1), isTrue);
    });

    test('isAtSameMomentAs', () {
      final dt1 = DateTime.now();

      final property = viewModel.createDateTimeProperty(dt1);

      expect(property.isAtSameMomentAs(dt1), isTrue);
    });

    test('compareTo - value is before other- value is -1', () {
      const int expected = -1;
      final dt1 = DateTime.now().subtract(const Duration(days: 1));
      final dt2 = DateTime.now();
      final property = viewModel.createDateTimeProperty(dt1);

      expect(property.compareTo(dt2), equals(expected));
    });

    test('compareTo - value is after other - value is 1', () {
      const int expected = 1;
      final dt1 = DateTime.now().add(const Duration(days: 1));
      final dt2 = DateTime.now();
      final property = viewModel.createDateTimeProperty(dt1);

      expect(property.compareTo(dt2), equals(expected));
    });

    test('compareTo - other is same - value is 0', () {
      const int expected = 0;
      final dt1 = DateTime.now();

      final property = viewModel.createDateTimeProperty(dt1);

      expect(property.compareTo(dt1), equals(expected));
    });
  });
}
