import 'package:sqflite/sqflite.dart';

import '../../../core/utils/month_context.dart';
import '../../../core/utils/payment_method_utils.dart';
import '../domain/entities/dashboard_summary.dart';
import '../domain/entities/movement.dart';
import '../domain/entities/movement_filter.dart';
import '../domain/entities/reports_snapshot.dart';
import '../domain/repositories/movements_repository.dart';
import 'local_finance_support.dart';

class LocalMovementRepository implements MovementsRepository {
  LocalMovementRepository(this._support);

  final LocalFinanceSupport _support;

  @override
  Future<DashboardSummary> getDashboardSummary(DateTime month) async {
    final db = await _support.appDatabase.instance;
    final monthContext = MonthContext.forDate(month);

    final totalRows = await db.rawQuery(
      '''
      SELECT
        COALESCE(SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END), 0) AS incomes,
        COALESCE(SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END), 0) AS expenses,
        COALESCE(SUM(CASE WHEN type = 'saving' THEN amount ELSE 0 END), 0) AS savings
      FROM movements
      ''',
    );

    final monthRows = await db.rawQuery(
      '''
      SELECT
        COALESCE(SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END), 0) AS incomes,
        COALESCE(SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END), 0) AS expenses,
        COALESCE(SUM(CASE WHEN type = 'saving' THEN amount ELSE 0 END), 0) AS savings,
        COUNT(*) AS count_all
      FROM movements
      WHERE occurred_on >= ? AND occurred_on < ?
      ''',
      [
        monthContext.startDate.toIso8601String(),
        monthContext.endDateExclusive.toIso8601String(),
      ],
    );

    final totals = totalRows.first;
    final monthly = monthRows.first;
    final incomeTotal = _support.readDouble(totals['incomes']);
    final expenseTotal = _support.readDouble(totals['expenses']);
    final savingsTotal = _support.readDouble(totals['savings']);

    return DashboardSummary(
      availableBalance: incomeTotal - expenseTotal - savingsTotal,
      incomeMonth: _support.readDouble(monthly['incomes']),
      expenseMonth: _support.readDouble(monthly['expenses']),
      savingsAccumulated: savingsTotal,
      savingsMonth: _support.readDouble(monthly['savings']),
      currentMonthMovementCount: (monthly['count_all'] as int?) ?? 0,
    );
  }

  @override
  Future<List<Movement>> getMovements({
    MovementFilter filter = const MovementFilter(),
  }) async {
    final db = await _support.appDatabase.instance;
    final where = <String>[];
    final args = <Object?>[];

    if (filter.startDate != null) {
      where.add('m.occurred_on >= ?');
      args.add(filter.startDate!.toIso8601String());
    }
    if (filter.endDate != null) {
      where.add('m.occurred_on <= ?');
      args.add(filter.endDate!.toIso8601String());
    }
    if (filter.type != null) {
      where.add('m.type = ?');
      args.add(filter.type!.name);
    }
    if (filter.categoryId != null && filter.categoryId!.isNotEmpty) {
      where.add('(m.category_id = ? OR m.subcategory_id = ?)');
      args.add(filter.categoryId);
      args.add(filter.categoryId);
    }
    if (filter.search != null && filter.search!.trim().isNotEmpty) {
      where.add('LOWER(COALESCE(m.note, \'\')) LIKE ?');
      args.add('%${filter.search!.trim().toLowerCase()}%');
    }

    final sql = StringBuffer('''
      SELECT
        m.*,
        c.name AS category_name,
        s.name AS subcategory_name
      FROM movements m
      LEFT JOIN categories c ON c.id = m.category_id
      LEFT JOIN categories s ON s.id = m.subcategory_id
    ''');

    if (where.isNotEmpty) {
      sql.write(' WHERE ${where.join(' AND ')}');
    }
    sql.write(' ORDER BY m.occurred_on DESC, m.created_at DESC');
    if (filter.limit != null) {
      sql.write(' LIMIT ${filter.limit}');
    }

    final rows = await db.rawQuery(sql.toString(), args);
    return rows.map(_support.movementFromMap).toList();
  }

  @override
  Future<void> upsertMovement(Movement movement) async {
    if (movement.amount <= 0) {
      throw StateError('El monto debe ser mayor a cero.');
    }
    if (movement.categoryId.trim().isEmpty) {
      throw StateError('La categoría es obligatoria.');
    }
    if (movement.subcategoryId?.trim().isEmpty == true) {
      throw StateError('La subcategoría no es válida.');
    }
    if (movement.goalId?.trim().isEmpty == true) {
      throw StateError('La meta de ahorro no es válida.');
    }

    final db = await _support.appDatabase.instance;
    await db.insert(
      'movements',
      {
        'id': movement.id,
        'type': movement.type.name,
        'amount': movement.amount,
        'category_id': movement.categoryId,
        'subcategory_id': movement.subcategoryId,
        'goal_id': movement.goalId,
        'occurred_on': movement.occurredOn.toIso8601String(),
        'note': movement.note,
        'payment_method': movement.paymentMethod == null
            ? null
            : PaymentMethodUtils.canonicalizeLabel(movement.paymentMethod!),
        'monthly_reminder_enabled': movement.monthlyReminderEnabled ? 1 : 0,
        'reminder_day': movement.reminderDay,
        'created_at': movement.createdAt.toIso8601String(),
        'updated_at': movement.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteMovement(String movementId) async {
    final db = await _support.appDatabase.instance;
    await db.delete('movements', where: 'id = ?', whereArgs: [movementId]);
  }

  @override
  Future<ReportsSnapshot> getReportsSnapshot(DateTime month) async {
    final db = await _support.appDatabase.instance;
    final currentMonth = MonthContext.forDate(month);
    final previousMonth = currentMonth.previous();

    final current = await _sumByRange(
      db,
      currentMonth.startDate,
      currentMonth.endDateExclusive,
    );
    final previous = await _sumByRange(
      db,
      previousMonth.startDate,
      currentMonth.startDate,
    );
    final topCategories = await db.rawQuery(
      '''
      SELECT c.name AS category_name, SUM(m.amount) AS amount
      FROM movements m
      LEFT JOIN categories c ON c.id = m.category_id
      WHERE m.type = 'expense' AND m.occurred_on >= ? AND m.occurred_on < ?
      GROUP BY m.category_id
      ORDER BY amount DESC
      LIMIT 5
      ''',
      [
        currentMonth.startDate.toIso8601String(),
        currentMonth.endDateExclusive.toIso8601String(),
      ],
    );

    return ReportsSnapshot(
      incomeMonth: _support.readDouble(current['incomes']),
      expenseMonth: _support.readDouble(current['expenses']),
      savingsMonth: _support.readDouble(current['savings']),
      netMonth: _support.readDouble(current['incomes']) -
          _support.readDouble(current['expenses']) -
          _support.readDouble(current['savings']),
      previousNetMonth: _support.readDouble(previous['incomes']) -
          _support.readDouble(previous['expenses']) -
          _support.readDouble(previous['savings']),
      topExpenseCategories: topCategories
          .map(
            (row) => CategorySpend(
              categoryName:
                  (row['category_name'] as String?) ?? 'Sin categoría',
              amount: _support.readDouble(row['amount']),
            ),
          )
          .toList(),
    );
  }

  Future<Map<String, Object?>> _sumByRange(
    Database db,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await db.rawQuery(
      '''
      SELECT
        COALESCE(SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END), 0) AS incomes,
        COALESCE(SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END), 0) AS expenses,
        COALESCE(SUM(CASE WHEN type = 'saving' THEN amount ELSE 0 END), 0) AS savings
      FROM movements
      WHERE occurred_on >= ? AND occurred_on < ?
      ''',
      [start.toIso8601String(), end.toIso8601String()],
    );
    return rows.first;
  }
}
