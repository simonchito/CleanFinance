import 'package:sqflite/sqflite.dart';

import '../domain/entities/savings_goal.dart';
import '../domain/repositories/savings_goals_repository.dart';
import 'local_finance_support.dart';

class LocalSavingsRepository implements SavingsGoalsRepository {
  LocalSavingsRepository(this._support);

  final LocalFinanceSupport _support;

  @override
  Future<List<SavingsGoalProgress>> getSavingsGoals() async {
    final db = await _support.appDatabase.instance;
    final rows = await db.rawQuery('''
      SELECT
        g.*,
        COALESCE(SUM(m.amount), 0) AS saved_amount
      FROM savings_goals g
      LEFT JOIN movements m
        ON m.goal_id = g.id
        AND m.type = 'saving'
      GROUP BY g.id
      ORDER BY g.is_archived ASC, g.created_at DESC
    ''');

    return rows
        .map(
          (row) => SavingsGoalProgress(
            goal: _support.savingsGoalFromMap(row),
            savedAmount: _support.readDouble(row['saved_amount']),
          ),
        )
        .toList();
  }

  @override
  Future<void> upsertSavingsGoal(SavingsGoal goal) async {
    if (goal.targetAmount <= 0) {
      throw StateError('La meta debe ser mayor a cero.');
    }

    final db = await _support.appDatabase.instance;
    await db.insert(
      'savings_goals',
      {
        'id': goal.id,
        'name': goal.name,
        'target_amount': goal.targetAmount,
        'target_date': goal.targetDate?.toIso8601String(),
        'is_archived': goal.isArchived ? 1 : 0,
        'reminder_enabled': goal.reminderEnabled ? 1 : 0,
        'reminder_day': goal.reminderDay,
        'created_at': goal.createdAt.toIso8601String(),
        'updated_at': goal.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteSavingsGoal(String goalId) async {
    final db = await _support.appDatabase.instance;
    await db.update(
      'movements',
      {'goal_id': null},
      where: 'goal_id = ?',
      whereArgs: [goalId],
    );
    await db.delete('savings_goals', where: 'id = ?', whereArgs: [goalId]);
  }
}
