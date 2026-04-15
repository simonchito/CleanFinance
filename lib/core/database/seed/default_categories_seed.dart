import 'package:sqflite/sqflite.dart';

import '../../constants/default_categories.dart';
import '../../constants/icon_options.dart';

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

  Future<void> backfillDefaultCategoryIcons(Database db) async {
    final rows = await db.query('categories');
    if (rows.isEmpty) {
      return;
    }

    final topLevelByKey = <String, Map<String, Object?>>{};
    final childrenByParentId =
        <String, Map<String, Map<String, Object?>>>{};

    for (final row in rows) {
      final scope = (row['scope'] as String?) ?? '';
      final name = (row['name'] as String?) ?? '';
      final parentId = row['parent_id'] as String?;

      if (parentId == null) {
        topLevelByKey[_categoryKey(scope, name)] = row;
        continue;
      }

      childrenByParentId
          .putIfAbsent(parentId, () => <String, Map<String, Object?>>{})
          [_normalize(name)] = row;
    }

    final batch = db.batch();
    var hasUpdates = false;

    for (final definition in DefaultCategories.all) {
      final parent = topLevelByKey[_categoryKey(definition.scope, definition.name)];
      if (parent == null) {
        continue;
      }

      if (_shouldUpdateIcon(
        currentIconKey: parent['icon_key'] as String?,
        expectedIconKey: definition.iconKey,
        isDefault: (parent['is_default'] as int? ?? 0) == 1,
      )) {
        batch.update(
          'categories',
          {'icon_key': definition.iconKey},
          where: 'id = ?',
          whereArgs: [parent['id']],
        );
        hasUpdates = true;
      }

      final children = childrenByParentId[parent['id'] as String];
      if (children == null) {
        continue;
      }

      for (final subcategory in definition.subcategories) {
        final child = children[_normalize(subcategory.name)];
        if (child == null) {
          continue;
        }

        if (_shouldUpdateIcon(
          currentIconKey: child['icon_key'] as String?,
          expectedIconKey: subcategory.iconKey,
          isDefault: (child['is_default'] as int? ?? 0) == 1,
        )) {
          batch.update(
            'categories',
            {'icon_key': subcategory.iconKey},
            where: 'id = ?',
            whereArgs: [child['id']],
          );
          hasUpdates = true;
        }
      }
    }

    if (hasUpdates) {
      await batch.commit(noResult: true);
    }
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

  bool _shouldUpdateIcon({
    required String? currentIconKey,
    required String expectedIconKey,
    required bool isDefault,
  }) {
    if (!isDefault) {
      return false;
    }
    if (!IconOptions.isSupported(currentIconKey)) {
      return true;
    }
    if (IconOptions.normalize(currentIconKey) == IconOptions.defaultKey &&
        expectedIconKey != IconOptions.defaultKey) {
      return true;
    }
    return false;
  }

  String _categoryKey(String scope, String name) {
    return '$scope::${_normalize(name)}';
  }

  String _normalize(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }
}
