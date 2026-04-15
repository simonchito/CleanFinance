import 'package:sqflite/sqflite.dart';

import '../../constants/default_categories.dart';

class DefaultCategoriesSeed {
  const DefaultCategoriesSeed();

  Future<void> seed(
    Database db, {
    required String Function() createId,
  }) async {
    final existing = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM categories'),
    );
    if ((existing ?? 0) > 0) {
      return;
    }

    final now = DateTime.now().toIso8601String();
    final batch = db.batch();

    for (final definition in DefaultCategories.all) {
      final categoryId = createId();
      batch.insert(
        'categories',
        _categoryMap(
          id: categoryId,
          name: definition.name,
          iconKey: definition.iconKey,
          scope: definition.scope,
          now: now,
        ),
      );

      for (final subcategory in definition.subcategories) {
        batch.insert(
          'categories',
          _categoryMap(
            id: createId(),
            name: subcategory.name,
            iconKey: subcategory.iconKey,
            scope: definition.scope,
            parentId: categoryId,
            now: now,
          ),
        );
      }
    }

    await batch.commit(noResult: true);
  }

  Map<String, Object?> _categoryMap({
    required String id,
    required String name,
    required String iconKey,
    required String scope,
    required String now,
    String? parentId,
  }) {
    return {
      'id': id,
      'name': name,
      'icon_key': iconKey,
      'scope': scope,
      'parent_id': parentId,
      'is_default': 1,
      'reminder_enabled': 0,
      'reminder_day': null,
      'created_at': now,
      'updated_at': now,
    };
  }
}
