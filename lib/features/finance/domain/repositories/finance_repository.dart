import '../entities/app_settings.dart';
import '../entities/category.dart';
import '../entities/dashboard_summary.dart';
import '../entities/movement.dart';
import '../entities/movement_filter.dart';
import '../entities/reports_snapshot.dart';
import '../entities/savings_goal.dart';

abstract class FinanceRepository {
  Future<void> ensureSeedData();
  Future<DashboardSummary> getDashboardSummary(DateTime month);
  Future<List<Movement>> getMovements({MovementFilter filter = const MovementFilter()});
  Future<void> upsertMovement(Movement movement);
  Future<void> deleteMovement(String movementId);
  Future<List<Category>> getCategories({CategoryScope? scope});
  Future<void> upsertCategory(Category category);
  Future<void> deleteCategory(String categoryId);
  Future<List<SavingsGoalProgress>> getSavingsGoals();
  Future<void> upsertSavingsGoal(SavingsGoal goal);
  Future<void> deleteSavingsGoal(String goalId);
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<ReportsSnapshot> getReportsSnapshot(DateTime month);
  Future<String> exportData();
  Future<void> importData(String payload);
  Future<void> clearAllData();
}
