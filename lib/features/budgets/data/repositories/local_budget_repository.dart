import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/models/budget.dart';
import '../../domain/repositories/budget_repository.dart';

class LocalBudgetRepository implements BudgetRepository {
  LocalBudgetRepository(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<void> createBudget(Budget budget) async {
    _validateBudget(budget);

    final db = await _appDatabase.instance;
    try {
      await db.insert(
        'budgets',
        _budgetToMap(budget),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (error) {
      if (error.isUniqueConstraintError()) {
        throw StateError(
          'Ya existe un presupuesto para esta categoría en ese mes.',
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    _validateBudget(budget);

    final db = await _appDatabase.instance;
    try {
      final updated = await db.update(
        'budgets',
        _budgetToMap(budget),
        where: 'id = ?',
        whereArgs: [budget.id],
      );

      if (updated == 0) {
        throw StateError('No se encontró el presupuesto a actualizar.');
      }
    } on DatabaseException catch (error) {
      if (error.isUniqueConstraintError()) {
        throw StateError(
          'Ya existe un presupuesto para esta categoría en ese mes.',
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteBudget(String budgetId) async {
    final db = await _appDatabase.instance;
    await db.delete('budgets', where: 'id = ?', whereArgs: [budgetId]);
  }

  @override
  Future<Budget?> getBudgetByCategoryAndMonth(
    String categoryId,
    String month,
  ) async {
    _validateMonth(month);

    final db = await _appDatabase.instance;
    final rows = await db.query(
      'budgets',
      where: 'category_id = ? AND month = ?',
      whereArgs: [categoryId, month],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }
    return _budgetFromMap(rows.first);
  }

  @override
  Future<List<Budget>> getBudgetsForMonth(String month) async {
    _validateMonth(month);

    final db = await _appDatabase.instance;
    final rows = await db.query(
      'budgets',
      where: 'month = ?',
      whereArgs: [month],
      orderBy: 'category_id ASC',
    );

    return rows.map(_budgetFromMap).toList();
  }

  Map<String, Object?> _budgetToMap(Budget budget) {
    return {
      'id': budget.id,
      'category_id': budget.categoryId,
      'monthly_limit': budget.monthlyLimit,
      'month': budget.month,
    };
  }

  Budget _budgetFromMap(Map<String, Object?> map) {
    return Budget(
      id: map['id'] as String,
      categoryId: map['category_id'] as String,
      monthlyLimit: _readDouble(map['monthly_limit']),
      month: map['month'] as String,
    );
  }

  void _validateBudget(Budget budget) {
    if (budget.id.trim().isEmpty) {
      throw StateError('El presupuesto debe tener un id válido.');
    }
    if (budget.categoryId.trim().isEmpty) {
      throw StateError('La categoría es obligatoria.');
    }
    if (budget.monthlyLimit < 0) {
      throw StateError('El límite mensual no puede ser negativo.');
    }
    _validateMonth(budget.month);
  }

  void _validateMonth(String month) {
    if (!Budget.isValidMonth(month)) {
      throw StateError('El mes debe usar el formato YYYY-MM.');
    }
  }

  double _readDouble(Object? value) {
    if (value is int) {
      return value.toDouble();
    }
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return 0;
  }
}
