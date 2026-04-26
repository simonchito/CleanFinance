import 'package:clean_finance/features/budgets/domain/models/budget.dart';
import 'package:clean_finance/features/budgets/domain/models/category_budget_status.dart';
import 'package:clean_finance/features/budgets/domain/repositories/budget_repository.dart';
import 'package:clean_finance/features/budgets/domain/services/budget_service.dart';
import 'package:clean_finance/features/finance/domain/entities/category.dart';
import 'package:clean_finance/features/finance/domain/entities/dashboard_summary.dart';
import 'package:clean_finance/features/finance/domain/entities/movement.dart';
import 'package:clean_finance/features/finance/domain/entities/movement_filter.dart';
import 'package:clean_finance/features/finance/domain/entities/reports_snapshot.dart';
import 'package:clean_finance/features/finance/domain/repositories/categories_repository.dart';
import 'package:clean_finance/features/finance/domain/repositories/movements_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BudgetService', () {
    test(
        'calcula estados solo con gastos del mes actual agrupados por categoria',
        () async {
      final service = BudgetService(
        budgetRepository: _FakeBudgetRepository([
          const Budget(
            id: 'budget-1',
            categoryId: 'food',
            monthlyLimit: 1000,
            month: '2026-03',
          ),
          const Budget(
            id: 'budget-2',
            categoryId: 'transport',
            monthlyLimit: 500,
            month: '2026-03',
          ),
        ]),
        categoriesRepository: _FakeCategoriesRepository(
          categories: [
            _category('food', 'Comida'),
            _category('transport', 'Transporte'),
          ],
        ),
        movementsRepository: _FakeMovementsRepository(
          movements: [
            _movement(
              id: '1',
              type: MovementType.expense,
              amount: 600,
              categoryId: 'food',
              occurredOn: DateTime(2026, 3, 10),
            ),
            _movement(
              id: '2',
              type: MovementType.expense,
              amount: 400,
              categoryId: 'food',
              occurredOn: DateTime(2026, 2, 28),
            ),
            _movement(
              id: '3',
              type: MovementType.expense,
              amount: 250,
              categoryId: 'transport',
              occurredOn: DateTime(2026, 3, 11),
            ),
            _movement(
              id: '4',
              type: MovementType.income,
              amount: 800,
              categoryId: 'food',
              occurredOn: DateTime(2026, 3, 12),
            ),
          ],
        ),
      );

      final result = await service.getCategoryBudgetStatuses(
        referenceDate: DateTime(2026, 3, 20),
      );

      expect(result.length, 2);
      expect(result[0].categoryName, 'Comida');
      expect(result[0].spent, 600);
      expect(result[0].remaining, 400);
      expect(result[0].percentageUsed, 60);
      expect(result[0].status, BudgetStatus.normal);

      expect(result[1].categoryName, 'Transporte');
      expect(result[1].spent, 250);
      expect(result[1].remaining, 250);
      expect(result[1].percentageUsed, 50);
      expect(result[1].status, BudgetStatus.normal);
    });

    test('marca warning desde 80 por ciento y exceeded desde 100 por ciento',
        () {
      const service = BudgetService(
        budgetRepository: _NoopBudgetRepository(),
        categoriesRepository: _NoopCategoriesRepository(),
        movementsRepository: _NoopMovementsRepository(),
      );

      expect(
        service.determineStatus(
          service.calculatePercentageUsed(monthlyLimit: 1000, spent: 799.99),
        ),
        BudgetStatus.normal,
      );
      expect(
        service.determineStatus(
          service.calculatePercentageUsed(monthlyLimit: 1000, spent: 800),
        ),
        BudgetStatus.warning,
      );
      expect(
        service.determineStatus(
          service.calculatePercentageUsed(monthlyLimit: 1000, spent: 1000),
        ),
        BudgetStatus.exceeded,
      );
    });

    test('maneja presupuestos de cero sin dividir por cero', () {
      const service = BudgetService(
        budgetRepository: _NoopBudgetRepository(),
        categoriesRepository: _NoopCategoriesRepository(),
        movementsRepository: _NoopMovementsRepository(),
      );

      expect(
        service.calculatePercentageUsed(monthlyLimit: 0, spent: 0),
        0,
      );
      expect(
        service.calculatePercentageUsed(monthlyLimit: 0, spent: 50),
        100,
      );
    });
  });
}

Category _category(String id, String name) {
  final now = DateTime(2026, 1, 1);
  return Category(
    id: id,
    name: name,
    iconKey: 'category',
    scope: CategoryScope.expense,
    isDefault: false,
    createdAt: now,
    updatedAt: now,
  );
}

Movement _movement({
  required String id,
  required MovementType type,
  required double amount,
  required String categoryId,
  required DateTime occurredOn,
}) {
  return Movement(
    id: id,
    type: type,
    amount: amount,
    categoryId: categoryId,
    occurredOn: occurredOn,
    createdAt: occurredOn,
    updatedAt: occurredOn,
  );
}

class _FakeBudgetRepository implements BudgetRepository {
  _FakeBudgetRepository(this._budgets);

  final List<Budget> _budgets;

  @override
  Future<void> createBudget(Budget budget) async {}

  @override
  Future<void> deleteBudget(String budgetId) async {}

  @override
  Future<Budget?> getBudgetByCategoryAndMonth(
      String categoryId, String month) async {
    for (final budget in _budgets) {
      if (budget.categoryId == categoryId && budget.month == month) {
        return budget;
      }
    }
    return null;
  }

  @override
  Future<List<Budget>> getBudgetsForMonth(String month) async {
    return _budgets.where((budget) => budget.month == month).toList();
  }

  @override
  Future<void> updateBudget(Budget budget) async {}
}

class _FakeCategoriesRepository implements CategoriesRepository {
  _FakeCategoriesRepository({
    required this.categories,
  });

  final List<Category> categories;

  @override
  Future<void> ensureSeedData() async {}

  @override
  Future<List<Category>> getCategories({CategoryScope? scope}) async {
    if (scope == null) {
      return categories;
    }
    return categories
        .where(
          (category) =>
              category.scope == scope || category.scope == CategoryScope.all,
        )
        .toList();
  }

  @override
  Future<void> upsertCategory(Category category) async {}

  @override
  Future<void> deleteCategory(String categoryId) async {}
}

class _FakeMovementsRepository implements MovementsRepository {
  _FakeMovementsRepository({
    required this.movements,
  });

  final List<Movement> movements;

  @override
  Future<ReportsSnapshot> getReportsSnapshot(DateTime month) async {
    throw UnimplementedError();
  }

  @override
  Future<DashboardSummary> getDashboardSummary(DateTime month) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Movement>> getMovements({
    MovementFilter filter = const MovementFilter(),
  }) async {
    return movements.where((movement) {
      if (filter.type != null && movement.type != filter.type) {
        return false;
      }
      if (filter.startDate != null &&
          movement.occurredOn.isBefore(filter.startDate!)) {
        return false;
      }
      if (filter.endDate != null &&
          movement.occurredOn.isAfter(filter.endDate!)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<void> upsertMovement(Movement movement) async {}

  @override
  Future<void> deleteMovement(String movementId) async {}
}

class _NoopBudgetRepository implements BudgetRepository {
  const _NoopBudgetRepository();

  @override
  Future<void> createBudget(Budget budget) async {}

  @override
  Future<void> deleteBudget(String budgetId) async {}

  @override
  Future<Budget?> getBudgetByCategoryAndMonth(
      String categoryId, String month) async {
    return null;
  }

  @override
  Future<List<Budget>> getBudgetsForMonth(String month) async => const [];

  @override
  Future<void> updateBudget(Budget budget) async {}
}

class _NoopCategoriesRepository implements CategoriesRepository {
  const _NoopCategoriesRepository();

  @override
  Future<void> ensureSeedData() async {}

  @override
  Future<List<Category>> getCategories({CategoryScope? scope}) async =>
      const [];

  @override
  Future<void> upsertCategory(Category category) async {}

  @override
  Future<void> deleteCategory(String categoryId) async {}
}

class _NoopMovementsRepository implements MovementsRepository {
  const _NoopMovementsRepository();

  @override
  Future<ReportsSnapshot> getReportsSnapshot(DateTime month) async {
    throw UnimplementedError();
  }

  @override
  Future<DashboardSummary> getDashboardSummary(DateTime month) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Movement>> getMovements({
    MovementFilter filter = const MovementFilter(),
  }) async =>
      const [];

  @override
  Future<void> upsertMovement(Movement movement) async {}

  @override
  Future<void> deleteMovement(String movementId) async {}
}
