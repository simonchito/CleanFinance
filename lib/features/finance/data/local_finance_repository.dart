import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/security/backup_cipher_service.dart';
import '../../../core/database/seed/default_categories_seed.dart';
import '../../../core/security/secure_storage_service.dart';
import '../../../core/utils/month_context.dart';
import '../../../core/utils/payment_method_utils.dart';
import '../domain/entities/app_settings.dart';
import '../domain/entities/app_theme_preference.dart';
import '../domain/entities/category.dart';
import '../domain/entities/dashboard_summary.dart';
import '../domain/entities/movement.dart';
import '../domain/entities/movement_filter.dart';
import '../domain/entities/reports_snapshot.dart';
import '../domain/entities/savings_goal.dart';
import '../domain/repositories/backup_repository.dart';
import '../domain/repositories/categories_repository.dart';
import '../domain/repositories/finance_repository.dart';
import '../domain/repositories/movements_repository.dart';
import '../domain/repositories/savings_goals_repository.dart';
import '../domain/repositories/settings_repository.dart';

class LocalFinanceRepository
    implements
        FinanceRepository,
        MovementsRepository,
        CategoriesRepository,
        SavingsGoalsRepository,
        SettingsRepository,
        BackupRepository {
  LocalFinanceRepository(
    this._appDatabase, {
    SecureStorageService? secureStorage,
    BackupCipherService backupCipherService = const BackupCipherService(),
  })  : _secureStorage = secureStorage,
        _backupCipherService = backupCipherService;

  final AppDatabase _appDatabase;
  final SecureStorageService? _secureStorage;
  final BackupCipherService _backupCipherService;
  final Uuid _uuid = const Uuid();
  final DefaultCategoriesSeed _defaultCategoriesSeed =
      const DefaultCategoriesSeed();

  @override
  Future<void> ensureSeedData() async {
    final db = await _appDatabase.instance;
    await _defaultCategoriesSeed.seed(
      db,
      createId: _uuid.v4,
    );
    await _defaultCategoriesSeed.backfillDefaultCategoryNames(db);
    await _defaultCategoriesSeed.backfillDefaultCategoryIcons(db);
  }

  @override
  Future<DashboardSummary> getDashboardSummary(DateTime month) async {
    final db = await _appDatabase.instance;
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
    final incomeTotal = _readDouble(totals['incomes']);
    final expenseTotal = _readDouble(totals['expenses']);
    final savingsTotal = _readDouble(totals['savings']);

    return DashboardSummary(
      availableBalance: incomeTotal - expenseTotal - savingsTotal,
      incomeMonth: _readDouble(monthly['incomes']),
      expenseMonth: _readDouble(monthly['expenses']),
      savingsAccumulated: savingsTotal,
      savingsMonth: _readDouble(monthly['savings']),
      currentMonthMovementCount: (monthly['count_all'] as int?) ?? 0,
    );
  }

  @override
  Future<List<Movement>> getMovements({
    MovementFilter filter = const MovementFilter(),
  }) async {
    final db = await _appDatabase.instance;
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
    return rows.map(_movementFromMap).toList();
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

    final db = await _appDatabase.instance;
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
    final db = await _appDatabase.instance;
    await db.delete('movements', where: 'id = ?', whereArgs: [movementId]);
  }

  @override
  Future<List<Category>> getCategories({CategoryScope? scope}) async {
    final db = await _appDatabase.instance;
    final where = scope == null ? null : 'scope IN (?, ?)';
    final args = scope == null ? null : [scope.name, CategoryScope.all.name];
    final rows = await db.query(
      'categories',
      where: where,
      whereArgs: args,
    );
    return rows.map(_categoryFromMap).toList();
  }

  @override
  Future<void> upsertCategory(Category category) async {
    final db = await _appDatabase.instance;
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
    final db = await _appDatabase.instance;
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

  @override
  Future<List<SavingsGoalProgress>> getSavingsGoals() async {
    final db = await _appDatabase.instance;
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
            goal: _goalFromMap(row),
            savedAmount: _readDouble(row['saved_amount']),
          ),
        )
        .toList();
  }

  @override
  Future<void> upsertSavingsGoal(SavingsGoal goal) async {
    if (goal.targetAmount <= 0) {
      throw StateError('La meta debe ser mayor a cero.');
    }

    final db = await _appDatabase.instance;
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
    final db = await _appDatabase.instance;
    await db.update(
      'movements',
      {'goal_id': null},
      where: 'goal_id = ?',
      whereArgs: [goalId],
    );
    await db.delete('savings_goals', where: 'id = ?', whereArgs: [goalId]);
  }

  @override
  Future<AppSettings> getSettings() async {
    final db = await _appDatabase.instance;
    final row = (await db.query(
      'app_settings',
      where: 'id = 1',
      limit: 1,
    ))
        .first;

    return AppSettings(
      currencyCode: row['currency_code'] as String,
      currencySymbol: row['currency_symbol'] as String,
      showSensitiveAmounts: (row['show_sensitive_amounts'] as int? ?? 1) == 1,
      themePreference: _themeModeFromDb(row['theme_mode'] as String),
      biometricEnabled: (row['biometric_enabled'] as int? ?? 0) == 1,
      autoLockMinutes: (row['auto_lock_minutes'] as int?) ??
          AppConstants.defaultAutoLockMinutes,
      localeCode:
          (row['locale_code'] as String?) ?? AppConstants.defaultLocaleCode,
      paymentMethods: _paymentMethodsFromDb(row['payment_methods'] as String?),
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final db = await _appDatabase.instance;
    await db.update(
      'app_settings',
      {
        'currency_code': settings.currencyCode,
        'currency_symbol': settings.currencySymbol,
        'show_sensitive_amounts': settings.showSensitiveAmounts ? 1 : 0,
        'theme_mode': settings.themePreference.name,
        'biometric_enabled': settings.biometricEnabled ? 1 : 0,
        'auto_lock_minutes': settings.autoLockMinutes,
        'locale_code': settings.localeCode,
        'payment_methods': jsonEncode(settings.paymentMethods),
      },
      where: 'id = 1',
    );
  }

  @override
  Future<ReportsSnapshot> getReportsSnapshot(DateTime month) async {
    final db = await _appDatabase.instance;
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
      incomeMonth: _readDouble(current['incomes']),
      expenseMonth: _readDouble(current['expenses']),
      savingsMonth: _readDouble(current['savings']),
      netMonth: _readDouble(current['incomes']) -
          _readDouble(current['expenses']) -
          _readDouble(current['savings']),
      previousNetMonth: _readDouble(previous['incomes']) -
          _readDouble(previous['expenses']) -
          _readDouble(previous['savings']),
      topExpenseCategories: topCategories
          .map(
            (row) => CategorySpend(
              categoryName:
                  (row['category_name'] as String?) ?? 'Sin categoría',
              amount: _readDouble(row['amount']),
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

  @override
  Future<String> exportData({String? password}) async {
    final db = await _appDatabase.instance;
    final categories = await db.query('categories');
    final movements = await db.query('movements');
    final goals = await db.query('savings_goals');
    final budgets = await db.query('budgets');
    final settings = await db.query('app_settings');

    final payload = const JsonEncoder.withIndent('  ').convert({
      'version': AppConstants.databaseVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'categories': categories,
      'movements': movements,
      'savingsGoals': goals,
      'budgets': budgets,
      'settings': settings,
    });
    final trimmedPassword = password?.trim();
    if (trimmedPassword == null || trimmedPassword.isEmpty) {
      return payload;
    }
    return _backupCipherService.encryptJsonPayload(
      payload,
      password: trimmedPassword,
    );
  }

  @override
  Future<void> importData(String payload, {String? password}) async {
    final db = await _appDatabase.instance;
    final clearPayload = await _backupCipherService.decryptPayload(
      payload,
      password: password ?? '',
    );
    final backup = _parseAndValidateBackup(clearPayload);

    await db.transaction((txn) async {
      await txn.delete('budgets');
      await txn.delete('movements');
      await txn.delete('savings_goals');
      await txn.delete('categories');
      await txn.delete('app_settings');

      for (final item in backup.categories) {
        await txn.insert('categories', item);
      }
      for (final item in backup.goals) {
        await txn.insert('savings_goals', item);
      }
      for (final item in backup.movements) {
        await txn.insert('movements', item);
      }
      for (final item in backup.budgets) {
        await txn.insert('budgets', item);
      }
      await txn.insert('app_settings', backup.settings);
    });
    if (_secureStorage != null) {
      await _secureStorage.deleteBiometricEnabled();
    }
    await ensureSeedData();
  }

  @override
  Future<void> clearAllData() async {
    if (_secureStorage != null) {
      await _secureStorage.clearAll();
    }
    await _appDatabase.reset();
    await _appDatabase.instance;
  }

  Movement _movementFromMap(Map<String, Object?> map) {
    return Movement(
      id: map['id'] as String,
      type: MovementType.values.byName(map['type'] as String),
      amount: _readDouble(map['amount']),
      categoryId: map['category_id'] as String,
      subcategoryId: map['subcategory_id'] as String?,
      goalId: map['goal_id'] as String?,
      occurredOn: DateTime.parse(map['occurred_on'] as String),
      note: map['note'] as String?,
      paymentMethod: (map['payment_method'] as String?) == null
          ? null
          : PaymentMethodUtils.canonicalizeLabel(
              map['payment_method'] as String,
            ),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      categoryName: map['category_name'] as String?,
      subcategoryName: map['subcategory_name'] as String?,
      monthlyReminderEnabled:
          (map['monthly_reminder_enabled'] as int? ?? 0) == 1,
      reminderDay: map['reminder_day'] as int?,
    );
  }

  Category _categoryFromMap(Map<String, Object?> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      iconKey: (map['icon_key'] as String?) ?? 'category',
      scope: CategoryScope.values.byName(map['scope'] as String),
      parentId: map['parent_id'] as String?,
      isDefault: (map['is_default'] as int? ?? 0) == 1,
      reminderEnabled: (map['reminder_enabled'] as int? ?? 0) == 1,
      reminderDay: map['reminder_day'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  SavingsGoal _goalFromMap(Map<String, Object?> map) {
    final targetDate = map['target_date'] as String?;
    return SavingsGoal(
      id: map['id'] as String,
      name: map['name'] as String,
      targetAmount: _readDouble(map['target_amount']),
      targetDate: targetDate == null ? null : DateTime.parse(targetDate),
      isArchived: (map['is_archived'] as int? ?? 0) == 1,
      reminderEnabled: (map['reminder_enabled'] as int? ?? 0) == 1,
      reminderDay: map['reminder_day'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
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

  AppThemePreference _themeModeFromDb(String raw) {
    switch (raw) {
      case 'light':
        return AppThemePreference.light;
      case 'dark':
        return AppThemePreference.dark;
      default:
        return AppThemePreference.system;
    }
  }

  List<String> _paymentMethodsFromDb(String? raw) {
    if (raw == null || raw.isEmpty) {
      return AppConstants.defaultPaymentMethods;
    }
    try {
      final decoded = (jsonDecode(raw) as List<dynamic>)
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
      return PaymentMethodUtils.normalizeMethods(decoded);
    } catch (_) {
      return AppConstants.defaultPaymentMethods;
    }
  }

  _ValidatedBackupData _parseAndValidateBackup(String payload) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(payload);
    } on FormatException {
      throw const FormatException('El archivo no contiene un JSON válido.');
    }

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'El backup debe ser un objeto JSON con listas de datos.',
      );
    }

    final categoriesRaw = _requireList(decoded, 'categories');
    final movementsRaw = _requireList(decoded, 'movements');
    final goalsRaw = _requireList(decoded, 'savingsGoals');
    final budgetsRaw = _optionalList(decoded, 'budgets');
    final settingsRaw = _optionalList(decoded, 'settings');

    final categories = <Map<String, Object?>>[];
    final categoryIds = <String>{};

    for (var index = 0; index < categoriesRaw.length; index++) {
      final row = _requireMap(
        categoriesRaw[index],
        'categories[$index]',
      );
      final id = _requiredString(row, 'id', 'categories[$index]');
      if (!categoryIds.add(id)) {
        throw FormatException(
          'El backup tiene categorías duplicadas: "$id".',
        );
      }

      final scope = _requiredString(row, 'scope', 'categories[$index]');
      if (!_validCategoryScopes.contains(scope)) {
        throw FormatException(
          'La categoría "$id" tiene un scope inválido.',
        );
      }

      categories.add({
        'id': id,
        'name': _requiredString(row, 'name', 'categories[$index]'),
        'icon_key': _optionalTrimmedString(row, 'icon_key') ?? 'category',
        'scope': scope,
        'parent_id': _optionalTrimmedString(row, 'parent_id'),
        'is_default': _readBoolAsInt(row, 'is_default'),
        'reminder_enabled': _readBoolAsInt(row, 'reminder_enabled'),
        'reminder_day': _readNullableInt(row, 'reminder_day'),
        'created_at': _requiredIsoDateTimeString(
          row,
          'created_at',
          'categories[$index]',
        ),
        'updated_at': _requiredIsoDateTimeString(
          row,
          'updated_at',
          'categories[$index]',
        ),
      });
    }

    for (final category in categories) {
      final categoryId = category['id'] as String;
      final parentId = category['parent_id'] as String?;
      if (parentId == null) {
        continue;
      }
      if (!categoryIds.contains(parentId)) {
        throw FormatException(
          'La categoría "$categoryId" referencia una categoría padre inexistente.',
        );
      }
      if (parentId == categoryId) {
        throw FormatException(
          'La categoría "$categoryId" no puede ser su propia categoría padre.',
        );
      }
    }

    final goals = <Map<String, Object?>>[];
    final goalIds = <String>{};
    for (var index = 0; index < goalsRaw.length; index++) {
      final row = _requireMap(goalsRaw[index], 'savingsGoals[$index]');
      final id = _requiredString(row, 'id', 'savingsGoals[$index]');
      if (!goalIds.add(id)) {
        throw FormatException(
          'El backup tiene metas de ahorro duplicadas: "$id".',
        );
      }

      goals.add({
        'id': id,
        'name': _requiredString(row, 'name', 'savingsGoals[$index]'),
        'target_amount': _requiredPositiveNumber(
          row,
          'target_amount',
          'savingsGoals[$index]',
        ),
        'target_date': _optionalIsoDateTimeString(row, 'target_date'),
        'is_archived': _readBoolAsInt(row, 'is_archived'),
        'reminder_enabled': _readBoolAsInt(row, 'reminder_enabled'),
        'reminder_day': _readNullableInt(row, 'reminder_day'),
        'created_at': _requiredIsoDateTimeString(
          row,
          'created_at',
          'savingsGoals[$index]',
        ),
        'updated_at': _requiredIsoDateTimeString(
          row,
          'updated_at',
          'savingsGoals[$index]',
        ),
      });
    }

    final movements = <Map<String, Object?>>[];
    final movementIds = <String>{};
    for (var index = 0; index < movementsRaw.length; index++) {
      final row = _requireMap(movementsRaw[index], 'movements[$index]');
      final id = _requiredString(row, 'id', 'movements[$index]');
      if (!movementIds.add(id)) {
        throw FormatException(
          'El backup tiene movimientos duplicados: "$id".',
        );
      }

      final type = _requiredString(row, 'type', 'movements[$index]');
      if (!_validMovementTypes.contains(type)) {
        throw FormatException(
          'El movimiento "$id" tiene un tipo inválido.',
        );
      }

      final categoryId = _requiredString(
        row,
        'category_id',
        'movements[$index]',
      );
      final category = categories.firstWhere(
        (item) => item['id'] == categoryId,
        orElse: () => const <String, Object?>{},
      );
      if (category.isEmpty) {
        throw FormatException(
          'El movimiento "$id" referencia una categoría inexistente.',
        );
      }

      final categoryScope = category['scope'] as String;
      if (!_isScopeCompatibleWithMovement(categoryScope, type)) {
        throw FormatException(
          'El movimiento "$id" usa una categoría incompatible con su tipo.',
        );
      }

      final subcategoryId = _optionalTrimmedString(row, 'subcategory_id');
      if (subcategoryId != null) {
        final subcategory = categories.firstWhere(
          (item) => item['id'] == subcategoryId,
          orElse: () => const <String, Object?>{},
        );
        if (subcategory.isEmpty) {
          throw FormatException(
            'El movimiento "$id" referencia una subcategoría inexistente.',
          );
        }
        if (subcategory['parent_id'] != categoryId) {
          throw FormatException(
            'El movimiento "$id" tiene una subcategoría que no pertenece a su categoría.',
          );
        }
      }

      final goalId = _optionalTrimmedString(row, 'goal_id');
      if (goalId != null && !goalIds.contains(goalId)) {
        throw FormatException(
          'El movimiento "$id" referencia una meta inexistente.',
        );
      }

      movements.add({
        'id': id,
        'type': type,
        'amount': _requiredPositiveNumber(row, 'amount', 'movements[$index]'),
        'category_id': categoryId,
        'subcategory_id': subcategoryId,
        'goal_id': goalId,
        'occurred_on': _requiredIsoDateTimeString(
          row,
          'occurred_on',
          'movements[$index]',
        ),
        'note': _optionalTrimmedString(row, 'note'),
        'payment_method': _normalizeNullablePaymentMethod(
          _optionalTrimmedString(row, 'payment_method'),
        ),
        'monthly_reminder_enabled': _readBoolAsInt(
          row,
          'monthly_reminder_enabled',
        ),
        'reminder_day': _readNullableInt(row, 'reminder_day'),
        'created_at': _requiredIsoDateTimeString(
          row,
          'created_at',
          'movements[$index]',
        ),
        'updated_at': _requiredIsoDateTimeString(
          row,
          'updated_at',
          'movements[$index]',
        ),
      });
    }

    final budgets = <Map<String, Object?>>[];
    final budgetIds = <String>{};
    for (var index = 0; index < budgetsRaw.length; index++) {
      final row = _requireMap(budgetsRaw[index], 'budgets[$index]');
      final id = _requiredString(row, 'id', 'budgets[$index]');
      if (!budgetIds.add(id)) {
        throw FormatException(
          'El backup tiene presupuestos duplicados: "$id".',
        );
      }

      final categoryId = _requiredString(row, 'category_id', 'budgets[$index]');
      final category = categories.firstWhere(
        (item) => item['id'] == categoryId,
        orElse: () => const <String, Object?>{},
      );
      if (category.isEmpty) {
        throw FormatException(
          'El presupuesto "$id" referencia una categoría inexistente.',
        );
      }
      if ((category['parent_id'] as String?) != null ||
          (category['scope'] as String) != CategoryScope.expense.name) {
        throw FormatException(
          'El presupuesto "$id" debe apuntar a una categoría principal de gasto.',
        );
      }

      final month = _requiredString(row, 'month', 'budgets[$index]');
      if (!RegExp(r'^\d{4}-\d{2}$').hasMatch(month)) {
        throw FormatException(
          'El presupuesto "$id" tiene un mes inválido.',
        );
      }

      budgets.add({
        'id': id,
        'category_id': categoryId,
        'monthly_limit': _requiredNonNegativeNumber(
          row,
          'monthly_limit',
          'budgets[$index]',
        ),
        'month': month,
      });
    }

    final settings = settingsRaw.isEmpty
        ? _defaultSettingsRow()
        : _validateSettingsRow(_requireMap(settingsRaw.first, 'settings[0]'));

    return _ValidatedBackupData(
      categories: categories,
      movements: movements,
      goals: goals,
      budgets: budgets,
      settings: settings,
    );
  }

  List<dynamic> _requireList(Map<String, dynamic> data, String key) {
    if (!data.containsKey(key)) {
      throw FormatException('Falta la lista "$key" en el backup.');
    }
    return _optionalList(data, key);
  }

  List<dynamic> _optionalList(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) {
      return const [];
    }
    if (value is! List<dynamic>) {
      throw FormatException('El campo "$key" debe ser una lista.');
    }
    return value;
  }

  Map<String, dynamic> _requireMap(Object? value, String path) {
    if (value is! Map) {
      throw FormatException('El elemento "$path" debe ser un objeto JSON.');
    }
    return Map<String, dynamic>.from(value);
  }

  String _requiredString(Map<String, dynamic> row, String key, String path) {
    final value = _optionalTrimmedString(row, key);
    if (value == null) {
      throw FormatException('Falta "$key" en "$path".');
    }
    return value;
  }

  String? _optionalTrimmedString(Map<String, dynamic> row, String key) {
    final value = row[key];
    if (value == null) {
      return null;
    }
    final trimmed = value.toString().trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _requiredIsoDateTimeString(
    Map<String, dynamic> row,
    String key,
    String path,
  ) {
    final value = _requiredString(row, key, path);
    if (DateTime.tryParse(value) == null) {
      throw FormatException(
          'El campo "$key" en "$path" no es una fecha válida.');
    }
    return value;
  }

  String? _optionalIsoDateTimeString(Map<String, dynamic> row, String key) {
    final value = _optionalTrimmedString(row, key);
    if (value == null) {
      return null;
    }
    if (DateTime.tryParse(value) == null) {
      throw FormatException('El campo "$key" no es una fecha válida.');
    }
    return value;
  }

  double _requiredPositiveNumber(
    Map<String, dynamic> row,
    String key,
    String path,
  ) {
    final value = _readRequiredNumber(row, key, path);
    if (value <= 0) {
      throw FormatException(
          'El campo "$key" en "$path" debe ser mayor a cero.');
    }
    return value;
  }

  double _requiredNonNegativeNumber(
    Map<String, dynamic> row,
    String key,
    String path,
  ) {
    final value = _readRequiredNumber(row, key, path);
    if (value < 0) {
      throw FormatException(
        'El campo "$key" en "$path" no puede ser negativo.',
      );
    }
    return value;
  }

  double _readRequiredNumber(
    Map<String, dynamic> row,
    String key,
    String path,
  ) {
    final value = row[key];
    if (value is num) {
      return value.toDouble();
    }
    throw FormatException('El campo "$key" en "$path" debe ser numérico.');
  }

  int _readBoolAsInt(Map<String, dynamic> row, String key) {
    final value = row[key];
    if (value == null) {
      return 0;
    }
    if (value is bool) {
      return value ? 1 : 0;
    }
    if (value is num && (value == 0 || value == 1)) {
      return value.toInt();
    }
    throw FormatException('El campo "$key" debe ser booleano o 0/1.');
  }

  int? _readNullableInt(Map<String, dynamic> row, String key) {
    final value = row[key];
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num && value == value.roundToDouble()) {
      return value.toInt();
    }
    throw FormatException('El campo "$key" debe ser entero.');
  }

  String? _normalizeNullablePaymentMethod(String? value) {
    if (value == null) {
      return null;
    }
    final normalized = PaymentMethodUtils.canonicalizeLabel(value);
    return normalized.isEmpty ? null : normalized;
  }

  Map<String, Object?> _validateSettingsRow(Map<String, dynamic> row) {
    final id = row['id'];
    if (id != null && id != 1) {
      throw const FormatException(
        'La configuración importada debe usar id = 1.',
      );
    }

    final paymentMethodsRaw = row['payment_methods'];
    List<String> paymentMethods;
    if (paymentMethodsRaw == null) {
      paymentMethods = AppConstants.defaultPaymentMethods;
    } else if (paymentMethodsRaw is String) {
      paymentMethods = _paymentMethodsFromDb(paymentMethodsRaw);
    } else if (paymentMethodsRaw is List) {
      paymentMethods = PaymentMethodUtils.normalizeMethods(
        paymentMethodsRaw.map((item) => item.toString()),
      );
    } else {
      throw const FormatException(
        'El campo "payment_methods" de configuración es inválido.',
      );
    }

    final themeMode = _optionalTrimmedString(row, 'theme_mode') ?? 'system';
    if (!{'system', 'light', 'dark'}.contains(themeMode)) {
      throw const FormatException('El theme_mode importado es inválido.');
    }

    return {
      'id': 1,
      'currency_code': _optionalTrimmedString(row, 'currency_code') ??
          AppConstants.defaultCurrencyCode,
      'currency_symbol': _optionalTrimmedString(row, 'currency_symbol') ??
          AppConstants.defaultCurrencySymbol,
      'show_sensitive_amounts': row.containsKey('show_sensitive_amounts')
          ? _readBoolAsInt(row, 'show_sensitive_amounts')
          : (AppConstants.defaultShowSensitiveAmounts ? 1 : 0),
      'theme_mode': themeMode,
      'biometric_enabled': row.containsKey('biometric_enabled')
          ? _readBoolAsInt(row, 'biometric_enabled')
          : 0,
      'auto_lock_minutes': _readNullableInt(row, 'auto_lock_minutes') ??
          AppConstants.defaultAutoLockMinutes,
      'locale_code': _optionalTrimmedString(row, 'locale_code') ??
          AppConstants.defaultLocaleCode,
      'payment_methods': jsonEncode(paymentMethods),
    };
  }

  Map<String, Object?> _defaultSettingsRow() {
    return {
      'id': 1,
      'currency_code': AppConstants.defaultCurrencyCode,
      'currency_symbol': AppConstants.defaultCurrencySymbol,
      'show_sensitive_amounts':
          AppConstants.defaultShowSensitiveAmounts ? 1 : 0,
      'theme_mode': 'system',
      'biometric_enabled': 0,
      'auto_lock_minutes': AppConstants.defaultAutoLockMinutes,
      'locale_code': AppConstants.defaultLocaleCode,
      'payment_methods': jsonEncode(AppConstants.defaultPaymentMethods),
    };
  }

  bool _isScopeCompatibleWithMovement(String scope, String type) {
    switch (type) {
      case 'income':
        return scope == CategoryScope.income.name ||
            scope == CategoryScope.all.name;
      case 'expense':
        return scope == CategoryScope.expense.name ||
            scope == CategoryScope.all.name;
      case 'saving':
        return scope == CategoryScope.saving.name ||
            scope == CategoryScope.all.name;
      default:
        return false;
    }
  }

  static const Set<String> _validMovementTypes = {
    'income',
    'expense',
    'saving',
  };

  static const Set<String> _validCategoryScopes = {
    'income',
    'expense',
    'saving',
    'all',
  };
}

class _ValidatedBackupData {
  const _ValidatedBackupData({
    required this.categories,
    required this.movements,
    required this.goals,
    required this.budgets,
    required this.settings,
  });

  final List<Map<String, Object?>> categories;
  final List<Map<String, Object?>> movements;
  final List<Map<String, Object?>> goals;
  final List<Map<String, Object?>> budgets;
  final Map<String, Object?> settings;
}
