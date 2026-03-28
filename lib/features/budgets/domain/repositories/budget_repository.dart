import '../models/budget.dart';

abstract class BudgetRepository {
  Future<void> createBudget(Budget budget);
  Future<void> updateBudget(Budget budget);
  Future<void> deleteBudget(String budgetId);
  Future<Budget?> getBudgetByCategoryAndMonth(String categoryId, String month);
  Future<List<Budget>> getBudgetsForMonth(String month);
}
