import 'dart:convert';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/payment_method_utils.dart';
import '../domain/entities/category.dart';
import '../domain/repositories/backup_repository.dart';
import 'local_finance_support.dart';

class LocalBackupRepository implements BackupRepository {
  LocalBackupRepository(this._support);

  final LocalFinanceSupport _support;

  @override
  Future<String> exportData({String? password}) async {
    final db = await _support.appDatabase.instance;
    final categories = await db.query('categories');
    final movements = await db.query('movements');
    final savingsGoals = await db.query('savings_goals');
    final budgets = await db.query('budgets');
    final settings = await db.query('app_settings');

    final payload = const JsonEncoder.withIndent('  ').convert({
      'version': AppConstants.databaseVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'categories': categories,
      'movements': movements,
      'savingsGoals': savingsGoals,
      'budgets': budgets,
      'settings': settings,
    });
    final trimmedPassword = password?.trim();
    if (trimmedPassword == null || trimmedPassword.isEmpty) {
      return payload;
    }
    return _support.backupCipherService.encryptJsonPayload(
      payload,
      password: trimmedPassword,
    );
  }

  @override
  Future<void> importData(String payload, {String? password}) async {
    final db = await _support.appDatabase.instance;
    final clearPayload = await _support.backupCipherService.decryptPayload(
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
      for (final item in backup.savingsGoals) {
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
    if (_support.secureStorage != null) {
      await _support.secureStorage!.deleteBiometricEnabled();
    }
    await _support.ensureSeedData();
  }

  @override
  Future<void> clearAllData() async {
    if (_support.secureStorage != null) {
      await _support.secureStorage!.clearAll();
    }
    await _support.appDatabase.reset();
    await _support.appDatabase.instance;
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
    final savingsGoalsRaw = _requireList(decoded, 'savingsGoals');
    final budgetsRaw = _optionalList(decoded, 'budgets');
    final settingsRaw = _optionalList(decoded, 'settings');

    final categories = <Map<String, Object?>>[];
    final categoryIds = <String>{};

    for (var index = 0; index < categoriesRaw.length; index++) {
      final row = _requireMap(categoriesRaw[index], 'categories[$index]');
      final id = _requiredString(row, 'id', 'categories[$index]');
      if (!categoryIds.add(id)) {
        throw FormatException('El backup tiene categorías duplicadas: "$id".');
      }

      final scope = _requiredString(row, 'scope', 'categories[$index]');
      if (!_validCategoryScopes.contains(scope)) {
        throw FormatException('La categoría "$id" tiene un scope inválido.');
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

    final savingsGoals = <Map<String, Object?>>[];
    final savingsGoalIds = <String>{};
    for (var index = 0; index < savingsGoalsRaw.length; index++) {
      final row = _requireMap(savingsGoalsRaw[index], 'savingsGoals[$index]');
      final id = _requiredString(row, 'id', 'savingsGoals[$index]');
      if (!savingsGoalIds.add(id)) {
        throw FormatException(
          'El backup tiene metas de ahorro duplicadas: "$id".',
        );
      }

      savingsGoals.add({
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
        throw FormatException('El backup tiene movimientos duplicados: "$id".');
      }

      final type = _requiredString(row, 'type', 'movements[$index]');
      if (!_validMovementTypes.contains(type)) {
        throw FormatException('El movimiento "$id" tiene un tipo inválido.');
      }

      final categoryId =
          _requiredString(row, 'category_id', 'movements[$index]');
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
      if (goalId != null && !savingsGoalIds.contains(goalId)) {
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
        throw FormatException('El presupuesto "$id" tiene un mes inválido.');
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
      savingsGoals: savingsGoals,
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
        'El campo "$key" en "$path" no es una fecha válida.',
      );
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
        'El campo "$key" en "$path" debe ser mayor a cero.',
      );
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
      paymentMethods = _support.paymentMethodsFromDb(paymentMethodsRaw);
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
      'locale_code': AppConstants.normalizeLocalePreferenceCode(
        _optionalTrimmedString(row, 'locale_code'),
      ),
      'payment_methods': jsonEncode(paymentMethods),
      'notifications_enabled': row.containsKey('notifications_enabled')
          ? _readBoolAsInt(row, 'notifications_enabled')
          : 0,
      'notification_reminder_hour':
          (_readNullableInt(row, 'notification_reminder_hour') ?? 9)
              .clamp(0, 23)
              .toInt(),
      'notification_reminder_minute':
          (_readNullableInt(row, 'notification_reminder_minute') ?? 0)
              .clamp(0, 59)
              .toInt(),
      'notification_permission_requested':
          row.containsKey('notification_permission_requested')
              ? _readBoolAsInt(row, 'notification_permission_requested')
              : 0,
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
      'locale_code': AppConstants.defaultLocalePreferenceCode,
      'payment_methods': jsonEncode(AppConstants.defaultPaymentMethods),
      'notifications_enabled': 0,
      'notification_reminder_hour': 9,
      'notification_reminder_minute': 0,
      'notification_permission_requested': 0,
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
    required this.savingsGoals,
    required this.budgets,
    required this.settings,
  });

  final List<Map<String, Object?>> categories;
  final List<Map<String, Object?>> movements;
  final List<Map<String, Object?>> savingsGoals;
  final List<Map<String, Object?>> budgets;
  final Map<String, Object?> settings;
}
