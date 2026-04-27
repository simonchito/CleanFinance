import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/seed/default_categories_seed.dart';
import '../../../core/security/backup_cipher_service.dart';
import '../../../core/security/secure_storage_service.dart';
import '../../../core/utils/payment_method_utils.dart';
import '../domain/entities/app_theme_preference.dart';
import '../domain/entities/category.dart';
import '../domain/entities/movement.dart';
import '../domain/entities/savings_goal.dart';

class LocalFinanceSupport {
  LocalFinanceSupport(
    this.appDatabase, {
    this.secureStorage,
    this.backupCipherService = const BackupCipherService(),
  });

  final AppDatabase appDatabase;
  final SecureStorageService? secureStorage;
  final BackupCipherService backupCipherService;
  final Uuid uuid = const Uuid();
  final DefaultCategoriesSeed defaultCategoriesSeed =
      const DefaultCategoriesSeed();

  Future<void> ensureSeedData() async {
    final db = await appDatabase.instance;
    await defaultCategoriesSeed.seed(
      db,
      createId: uuid.v4,
    );
    await defaultCategoriesSeed.backfillDefaultCategoryNames(db);
    await defaultCategoriesSeed.backfillDefaultCategoryIcons(db);
  }

  Movement movementFromMap(Map<String, Object?> map) {
    return Movement(
      id: map['id'] as String,
      type: MovementType.values.byName(map['type'] as String),
      amount: readDouble(map['amount']),
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
      categoryIsDefault: (map['category_is_default'] as int? ?? 0) == 1,
      subcategoryIsDefault: (map['subcategory_is_default'] as int? ?? 0) == 1,
      monthlyReminderEnabled:
          (map['monthly_reminder_enabled'] as int? ?? 0) == 1,
      reminderDay: map['reminder_day'] as int?,
    );
  }

  Category categoryFromMap(Map<String, Object?> map) {
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

  SavingsGoal savingsGoalFromMap(Map<String, Object?> map) {
    final targetDate = map['target_date'] as String?;
    return SavingsGoal(
      id: map['id'] as String,
      name: map['name'] as String,
      targetAmount: readDouble(map['target_amount']),
      targetDate: targetDate == null ? null : DateTime.parse(targetDate),
      isArchived: (map['is_archived'] as int? ?? 0) == 1,
      reminderEnabled: (map['reminder_enabled'] as int? ?? 0) == 1,
      reminderDay: map['reminder_day'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  double readDouble(Object? value) {
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

  AppThemePreference themeModeFromDb(String raw) {
    switch (raw) {
      case 'light':
        return AppThemePreference.light;
      case 'dark':
        return AppThemePreference.dark;
      default:
        return AppThemePreference.system;
    }
  }

  List<String> paymentMethodsFromDb(String? raw) {
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
}
