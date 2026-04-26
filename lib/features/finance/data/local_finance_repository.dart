import '../../../core/database/app_database.dart';
import '../../../core/security/backup_cipher_service.dart';
import '../../../core/security/secure_storage_service.dart';
import '../domain/entities/app_settings.dart';
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
import 'local_backup_repository.dart';
import 'local_category_repository.dart';
import 'local_finance_support.dart';
import 'local_movement_repository.dart';
import 'local_savings_repository.dart';
import 'local_settings_repository.dart';

class LocalFinanceRepository implements FinanceRepository {
  factory LocalFinanceRepository(
    AppDatabase appDatabase, {
    SecureStorageService? secureStorage,
    BackupCipherService backupCipherService = const BackupCipherService(),
  }) {
    final support = LocalFinanceSupport(
      appDatabase,
      secureStorage: secureStorage,
      backupCipherService: backupCipherService,
    );
    return LocalFinanceRepository._(
      movementsRepository: LocalMovementRepository(support),
      categoriesRepository: LocalCategoryRepository(support),
      savingsRepository: LocalSavingsRepository(support),
      settingsRepository: LocalSettingsRepository(support),
      backupRepository: LocalBackupRepository(support),
    );
  }

  LocalFinanceRepository.composed({
    required MovementsRepository movementsRepository,
    required CategoriesRepository categoriesRepository,
    required SavingsGoalsRepository savingsRepository,
    required SettingsRepository settingsRepository,
    required BackupRepository backupRepository,
  }) : this._(
          movementsRepository: movementsRepository,
          categoriesRepository: categoriesRepository,
          savingsRepository: savingsRepository,
          settingsRepository: settingsRepository,
          backupRepository: backupRepository,
        );

  LocalFinanceRepository._({
    required MovementsRepository movementsRepository,
    required CategoriesRepository categoriesRepository,
    required SavingsGoalsRepository savingsRepository,
    required SettingsRepository settingsRepository,
    required BackupRepository backupRepository,
  })  : _movementsRepository = movementsRepository,
        _categoriesRepository = categoriesRepository,
        _savingsRepository = savingsRepository,
        _settingsRepository = settingsRepository,
        _backupRepository = backupRepository;

  final MovementsRepository _movementsRepository;
  final CategoriesRepository _categoriesRepository;
  final SavingsGoalsRepository _savingsRepository;
  final SettingsRepository _settingsRepository;
  final BackupRepository _backupRepository;

  @override
  Future<void> ensureSeedData() => _categoriesRepository.ensureSeedData();

  @override
  Future<DashboardSummary> getDashboardSummary(DateTime month) {
    return _movementsRepository.getDashboardSummary(month);
  }

  @override
  Future<List<Movement>> getMovements({
    MovementFilter filter = const MovementFilter(),
  }) {
    return _movementsRepository.getMovements(filter: filter);
  }

  @override
  Future<void> upsertMovement(Movement movement) {
    return _movementsRepository.upsertMovement(movement);
  }

  @override
  Future<void> deleteMovement(String movementId) {
    return _movementsRepository.deleteMovement(movementId);
  }

  @override
  Future<ReportsSnapshot> getReportsSnapshot(DateTime month) {
    return _movementsRepository.getReportsSnapshot(month);
  }

  @override
  Future<List<Category>> getCategories({CategoryScope? scope}) {
    return _categoriesRepository.getCategories(scope: scope);
  }

  @override
  Future<Category?> getCategoryById(String categoryId) {
    return _categoriesRepository.getCategoryById(categoryId);
  }

  @override
  Future<Category?> getActiveExpenseReminderBySubcategory(
    String subcategoryId,
  ) {
    return _categoriesRepository.getActiveExpenseReminderBySubcategory(
      subcategoryId,
    );
  }

  @override
  Future<Category> setExpenseSubcategoryMonthlyReminder({
    required String subcategoryId,
    required bool enabled,
    int? reminderDay,
  }) {
    return _categoriesRepository.setExpenseSubcategoryMonthlyReminder(
      subcategoryId: subcategoryId,
      enabled: enabled,
      reminderDay: reminderDay,
    );
  }

  @override
  Future<void> upsertCategory(Category category) {
    return _categoriesRepository.upsertCategory(category);
  }

  @override
  Future<void> deleteCategory(String categoryId) {
    return _categoriesRepository.deleteCategory(categoryId);
  }

  @override
  Future<List<SavingsGoalProgress>> getSavingsGoals() {
    return _savingsRepository.getSavingsGoals();
  }

  @override
  Future<void> upsertSavingsGoal(SavingsGoal goal) {
    return _savingsRepository.upsertSavingsGoal(goal);
  }

  @override
  Future<void> deleteSavingsGoal(String goalId) {
    return _savingsRepository.deleteSavingsGoal(goalId);
  }

  @override
  Future<AppSettings> getSettings() => _settingsRepository.getSettings();

  @override
  Future<void> saveSettings(AppSettings settings) {
    return _settingsRepository.saveSettings(settings);
  }

  @override
  Future<String> exportData({String? password}) {
    return _backupRepository.exportData(password: password);
  }

  @override
  Future<void> importData(String payload, {String? password}) {
    return _backupRepository.importData(payload, password: password);
  }

  @override
  Future<void> clearAllData() => _backupRepository.clearAllData();
}
