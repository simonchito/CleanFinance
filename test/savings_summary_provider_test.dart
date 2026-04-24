import 'package:clean_finance/features/finance/domain/entities/dashboard_summary.dart';
import 'package:clean_finance/features/finance/domain/entities/movement.dart';
import 'package:clean_finance/features/finance/domain/entities/movement_filter.dart';
import 'package:clean_finance/features/finance/domain/entities/reports_snapshot.dart';
import 'package:clean_finance/features/finance/domain/entities/savings_goal.dart';
import 'package:clean_finance/features/finance/domain/repositories/movements_repository.dart';
import 'package:clean_finance/features/finance/domain/repositories/savings_goals_repository.dart';
import 'package:clean_finance/features/finance/presentation/providers/finance_providers.dart';
import 'package:clean_finance/shared/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'savings summary keeps unassigned savings visible when there are no goals',
    () async {
      final now = DateTime(2026, 4, 24);
      final movementsRepository = _FakeMovementsRepository(
        movements: [
          Movement(
            id: 'saving-1',
            type: MovementType.saving,
            amount: 300000,
            categoryId: 'saving-general',
            occurredOn: now,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          movementsRepositoryProvider.overrideWithValue(movementsRepository),
          savingsGoalsRepositoryProvider.overrideWithValue(
            _FakeSavingsGoalsRepository(goals: const []),
          ),
        ],
      );
      addTearDown(container.dispose);

      final summary = await container.read(savingsSummaryProvider.future);

      expect(summary.goalsCount, 0);
      expect(summary.totalSavedAmount, 300000);
      expect(summary.unassignedSavings.totalAmount, 300000);
      expect(summary.unassignedSavings.movementsCount, 1);
      expect(movementsRepository.lastFilter?.type, MovementType.saving);
    },
  );

  test(
    'unassigned savings include movements with missing or stale goal links',
    () async {
      final now = DateTime(2026, 4, 24);
      final movementsRepository = _FakeMovementsRepository(
        movements: [
          Movement(
            id: 'saving-goal',
            type: MovementType.saving,
            amount: 120000,
            categoryId: 'saving-emergency',
            goalId: 'goal-emergency',
            occurredOn: now,
            createdAt: now,
            updatedAt: now,
          ),
          Movement(
            id: 'saving-no-goal',
            type: MovementType.saving,
            amount: 50000,
            categoryId: 'saving-general',
            occurredOn: now,
            createdAt: now,
            updatedAt: now,
          ),
          Movement(
            id: 'saving-stale-goal',
            type: MovementType.saving,
            amount: 30000,
            categoryId: 'saving-general',
            goalId: 'goal-deleted',
            occurredOn: now,
            createdAt: now,
            updatedAt: now,
          ),
          Movement(
            id: 'expense-1',
            type: MovementType.expense,
            amount: 999,
            categoryId: 'expense',
            occurredOn: now,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      );
      final goalsRepository = _FakeSavingsGoalsRepository(
        goals: [
          SavingsGoalProgress(
            goal: SavingsGoal(
              id: 'goal-emergency',
              name: 'Fondo de emergencia',
              targetAmount: 500000,
              isArchived: false,
              createdAt: now,
              updatedAt: now,
            ),
            savedAmount: 120000,
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          movementsRepositoryProvider.overrideWithValue(movementsRepository),
          savingsGoalsRepositoryProvider.overrideWithValue(goalsRepository),
        ],
      );
      addTearDown(container.dispose);

      final unassigned = await container.read(unassignedSavingsProvider.future);
      final summary = await container.read(savingsSummaryProvider.future);

      expect(unassigned.totalAmount, 80000);
      expect(unassigned.movementsCount, 2);
      expect(summary.goalsSavedAmount, 120000);
      expect(summary.totalSavedAmount, 200000);
      expect(summary.totalGoalTargetAmount, 500000);
      expect(summary.completedGoalsCount, 0);
    },
  );
}

class _FakeMovementsRepository implements MovementsRepository {
  _FakeMovementsRepository({
    required this.movements,
  });

  final List<Movement> movements;
  MovementFilter? lastFilter;

  @override
  Future<void> deleteMovement(String movementId) async {}

  @override
  Future<DashboardSummary> getDashboardSummary(DateTime month) async {
    return const DashboardSummary(
      availableBalance: 0,
      incomeMonth: 0,
      expenseMonth: 0,
      savingsAccumulated: 0,
      savingsMonth: 0,
      currentMonthMovementCount: 0,
    );
  }

  @override
  Future<List<Movement>> getMovements({
    MovementFilter filter = const MovementFilter(),
  }) async {
    lastFilter = filter;
    final type = filter.type;
    if (type == null) {
      return movements;
    }
    return movements.where((movement) => movement.type == type).toList();
  }

  @override
  Future<ReportsSnapshot> getReportsSnapshot(DateTime month) async {
    return const ReportsSnapshot(
      incomeMonth: 0,
      expenseMonth: 0,
      savingsMonth: 0,
      netMonth: 0,
      previousNetMonth: 0,
      topExpenseCategories: [],
    );
  }

  @override
  Future<void> upsertMovement(Movement movement) async {}
}

class _FakeSavingsGoalsRepository implements SavingsGoalsRepository {
  _FakeSavingsGoalsRepository({
    required this.goals,
  });

  final List<SavingsGoalProgress> goals;

  @override
  Future<void> deleteSavingsGoal(String goalId) async {}

  @override
  Future<List<SavingsGoalProgress>> getSavingsGoals() async => goals;

  @override
  Future<void> upsertSavingsGoal(SavingsGoal goal) async {}
}
