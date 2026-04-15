import 'package:clean_finance/core/constants/default_categories.dart';
import 'package:clean_finance/core/constants/icon_options.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all seeded category icon keys are supported', () {
    for (final category in DefaultCategories.all) {
      expect(
        IconOptions.isSupported(category.iconKey),
        isTrue,
        reason: 'Missing icon support for category ${category.name}',
      );

      for (final subcategory in category.subcategories) {
        expect(
          IconOptions.isSupported(subcategory.iconKey),
          isTrue,
          reason: 'Missing icon support for subcategory ${subcategory.name}',
        );
      }
    }
  });
}
