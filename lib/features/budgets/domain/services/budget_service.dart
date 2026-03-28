import '../../../../core/utils/month_context.dart';
import '../../../finance/domain/entities/category.dart';
import '../../../finance/domain/entities/movement.dart';
import '../../../finance/domain/entities/movement_filter.dart';
import '../../../finance/domain/repositories/categories_repository.dart';
import '../../../finance/domain/repositories/movements_repository.dart';
import '../models/budget.dart';
import '../models/category_budget_status.dart';
import '../repositories/budget_repository.dart';

class BudgetService {
  const BudgetService({
    required BudgetRepository budgetRepository,
    required CategoriesRepository categoriesRepository,
    required MovementsRepository movementsRepository,
  }) : _budgetRepository = budgetRepository,
       _categoriesRepository = categoriesRepository,
       _movementsRepository = movementsRepository;

  final BudgetRepository _budgetRepository;
  final CategoriesRepository _categoriesRepository;
  final MovementsRepository _movementsRepository;

  Future<List<CategoryBudgetStatus>> getCategoryBudgetStatuses({
    DateTime? referenceDate,
  }) async {
    final targetDate = referenceDate ?? DateTime.now();
    final monthContext = MonthContext.forDate(targetDate);
    final monthKey = monthContext.monthKey;
    final budgets = await _budgetRepository.getBudgetsForMonth(monthKey);

    if (budgets.isEmpty) {
      return const [];
    }

    final categories = await _categoriesRepository.getCategories(
      scope: CategoryScope.expense,
    );
    final movements = await _movementsRepository.getMovements(
      filter: MovementFilter(
        startDate: monthContext.startDate,
        endDate: monthContext.endDateInclusive,
        type: MovementType.expense,
      ),
    );

    final categoryNames = {
      for (final category in categories) category.id: category.name,
    };

    final statuses = budgets
        .map(
          (budget) => _buildStatus(
            budget: budget,
            categoryName:
                categoryNames[budget.categoryId] ?? 'Sin categoría',
            movements: movements,
          ),
        )
        .toList()
      ..sort(
        (a, b) => a.categoryName.toLowerCase().compareTo(
          b.categoryName.toLowerCase(),
        ),
      );

    return statuses;
  }

  CategoryBudgetStatus _buildStatus({
    required Budget budget,
    required String categoryName,
    required List<Movement> movements,
  }) {
    final spent = calculateSpentForCategory(
      categoryId: budget.categoryId,
      movements: movements,
    );
    final remaining = calculateRemaining(
      monthlyLimit: budget.monthlyLimit,
      spent: spent,
    );
    final percentageUsed = calculatePercentageUsed(
      monthlyLimit: budget.monthlyLimit,
      spent: spent,
    );

    return CategoryBudgetStatus(
      categoryId: budget.categoryId,
      categoryName: categoryName,
      monthlyLimit: budget.monthlyLimit,
      spent: spent,
      remaining: remaining,
      percentageUsed: percentageUsed,
      status: determineStatus(percentageUsed),
    );
  }

  double calculateSpentForCategory({
    required String categoryId,
    required List<Movement> movements,
  }) {
    return movements
        .where((movement) => movement.categoryId == categoryId)
        .fold<double>(0, (sum, movement) => sum + movement.amount);
  }

  double calculateRemaining({
    required double monthlyLimit,
    required double spent,
  }) {
    return monthlyLimit - spent;
  }

  double calculatePercentageUsed({
    required double monthlyLimit,
    required double spent,
  }) {
    if (monthlyLimit <= 0) {
      return spent > 0 ? 100 : 0;
    }
    return (spent / monthlyLimit) * 100;
  }

  BudgetStatus determineStatus(double percentageUsed) {
    if (percentageUsed >= 100) {
      return BudgetStatus.exceeded;
    }
    if (percentageUsed >= 80) {
      return BudgetStatus.warning;
    }
    return BudgetStatus.normal;
  }
}
