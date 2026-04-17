import 'package:sqflite/sqflite.dart';

import '../domain/entities/category.dart';
import '../domain/repositories/categories_repository.dart';
import 'local_finance_support.dart';

class LocalCategoryRepository implements CategoriesRepository {
  LocalCategoryRepository(this._support);

  final LocalFinanceSupport _support;

  @override
  Future<void> ensureSeedData() {
    return _support.ensureSeedData();
  }

  @override
  Future<List<Category>> getCategories({CategoryScope? scope}) async {
    final db = await _support.appDatabase.instance;
    final where = scope == null ? null : 'scope IN (?, ?)';
    final args = scope == null ? null : [scope.name, CategoryScope.all.name];
    final rows = await db.query(
      'categories',
      where: where,
      whereArgs: args,
    );
    return rows.map(_support.categoryFromMap).toList();
  }

  @override
  Future<void> upsertCategory(Category category) async {
    final db = await _support.appDatabase.instance;
    await db.insert(
      'categories',
      {
        'id': category.id,
        'name': category.name,
        'icon_key': category.iconKey,
        'scope': category.scope.name,
        'parent_id': category.parentId,
        'is_default': category.isDefault ? 1 : 0,
        'reminder_enabled': category.reminderEnabled ? 1 : 0,
        'reminder_day': category.reminderDay,
        'created_at': category.createdAt.toIso8601String(),
        'updated_at': category.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    final db = await _support.appDatabase.instance;
    final childCount = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM categories WHERE parent_id = ?',
        [categoryId],
      ),
    );
    final movementCount = Sqflite.firstIntValue(
      await db.rawQuery(
        '''
        SELECT COUNT(*)
        FROM movements
        WHERE category_id = ? OR subcategory_id = ?
        ''',
        [categoryId, categoryId],
      ),
    );
    final budgetCount = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM budgets WHERE category_id = ?',
        [categoryId],
      ),
    );

    if ((childCount ?? 0) > 0 ||
        (movementCount ?? 0) > 0 ||
        (budgetCount ?? 0) > 0) {
      throw StateError(
        'No se puede eliminar una categoría con movimientos, subcategorías o presupuestos asociados.',
      );
    }

    await db.delete('categories', where: 'id = ?', whereArgs: [categoryId]);
  }
}
