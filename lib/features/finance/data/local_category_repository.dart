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
  Future<Category?> getCategoryById(String categoryId) async {
    final normalizedId = categoryId.trim();
    if (normalizedId.isEmpty) {
      return null;
    }

    final db = await _support.appDatabase.instance;
    final rows = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [normalizedId],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return _support.categoryFromMap(rows.single);
  }

  @override
  Future<Category?> getActiveExpenseReminderBySubcategory(
    String subcategoryId,
  ) async {
    final normalizedId = subcategoryId.trim();
    if (normalizedId.isEmpty) {
      return null;
    }

    final db = await _support.appDatabase.instance;
    final rows = await db.query(
      'categories',
      where: '''
        id = ?
        AND scope = ?
        AND parent_id IS NOT NULL
        AND reminder_enabled = 1
      ''',
      whereArgs: [normalizedId, CategoryScope.expense.name],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return _support.categoryFromMap(rows.single);
  }

  @override
  Future<Category> setExpenseSubcategoryMonthlyReminder({
    required String subcategoryId,
    required bool enabled,
    int? reminderDay,
  }) async {
    final category = await getCategoryById(subcategoryId);
    if (category == null) {
      throw StateError('La subcategoría no existe.');
    }
    if (category.scope != CategoryScope.expense || !category.isSubcategory) {
      throw StateError(
        'Los recordatorios de gasto solo se pueden activar en subcategorías de gasto.',
      );
    }
    if (enabled && !_isValidReminderDay(reminderDay)) {
      throw StateError('El día de recordatorio debe estar entre 1 y 31.');
    }

    final updated = category.copyWith(
      reminderEnabled: enabled,
      reminderDay: enabled ? reminderDay : null,
      clearReminderDay: !enabled,
      updatedAt: DateTime.now(),
    );
    await upsertCategory(updated);
    return updated;
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

  bool _isValidReminderDay(int? reminderDay) {
    return reminderDay != null && reminderDay >= 1 && reminderDay <= 31;
  }
}
