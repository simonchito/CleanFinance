import 'package:clean_finance/features/finance/domain/entities/analytics_models.dart';
import 'package:clean_finance/features/finance/domain/entities/end_of_month_projection.dart';
import 'package:clean_finance/features/finance/domain/entities/finance_insight.dart';
import 'package:clean_finance/features/finance/domain/entities/movement.dart';
import 'package:clean_finance/features/finance/domain/entities/savings_goal.dart';
import 'package:clean_finance/features/finance/domain/services/cashflow_snapshot_service.dart';
import 'package:clean_finance/features/finance/domain/services/category_comparison_service.dart';
import 'package:clean_finance/features/finance/domain/services/end_of_month_projection_service.dart';
import 'package:clean_finance/features/finance/domain/services/finance_insights_service.dart';
import 'package:clean_finance/features/finance/domain/services/financial_health_score_service.dart';
import 'package:clean_finance/features/finance/domain/services/monthly_trend_service.dart';
import 'package:clean_finance/features/finance/domain/services/savings_goal_report_service.dart';
import 'package:clean_finance/features/finance/domain/services/spending_pace_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
  });

  final referenceDate = DateTime(2026, 3, 20);

  Movement movement({
    required String id,
    required MovementType type,
    required double amount,
    required DateTime occurredOn,
    String? categoryName,
    String? paymentMethod,
    String? goalId,
  }) {
    return Movement(
      id: id,
      type: type,
      amount: amount,
      categoryId: 'cat-$id',
      occurredOn: occurredOn,
      createdAt: occurredOn,
      updatedAt: occurredOn,
      categoryName: categoryName,
      paymentMethod: paymentMethod,
      goalId: goalId,
    );
  }

  test('MonthlyTrendService agrupa ingresos y gastos por mes', () {
    const service = MonthlyTrendService();
    final points = service.build(
      movements: [
        movement(
          id: '1',
          type: MovementType.income,
          amount: 1000,
          occurredOn: DateTime(2026, 3, 10),
        ),
        movement(
          id: '2',
          type: MovementType.expense,
          amount: 400,
          occurredOn: DateTime(2026, 3, 11),
        ),
      ],
      referenceDate: referenceDate,
    );

    expect(points.length, 6);
    expect(points.last.income, 1000);
    expect(points.last.expense, 400);
  });

  test('CategoryComparisonService calcula share y variacion contra el mes anterior', () {
    const service = CategoryComparisonService();
    final report = service.build(
      movements: [
        movement(
          id: '1',
          type: MovementType.expense,
          amount: 500,
          occurredOn: DateTime(2026, 3, 5),
          categoryName: 'Comida',
        ),
        movement(
          id: '2',
          type: MovementType.expense,
          amount: 250,
          occurredOn: DateTime(2026, 2, 10),
          categoryName: 'Comida',
        ),
      ],
      referenceDate: referenceDate,
    );

    expect(report.totalCurrentExpense, 500);
    expect(report.items.first.categoryName, 'Comida');
    expect(report.items.first.shareOfCurrent, 1);
    expect(report.items.first.deltaPercentage, closeTo(1, 0.001));
  });

  test('Spending pace e health score detectan un mes exigente', () {
    const cashflowService = CashflowSnapshotService();
    const paceService = SpendingPaceService();
    const healthService = FinancialHealthScoreService();
    const categoryService = CategoryComparisonService();

    final movements = [
      movement(
        id: '1',
        type: MovementType.income,
        amount: 1000,
        occurredOn: DateTime(2026, 3, 1),
      ),
      movement(
        id: '2',
        type: MovementType.expense,
        amount: 900,
        occurredOn: DateTime(2026, 3, 20),
        categoryName: 'Comida',
      ),
      movement(
        id: '3',
        type: MovementType.saving,
        amount: 200,
        occurredOn: DateTime(2026, 3, 10),
      ),
      movement(
        id: '4',
        type: MovementType.income,
        amount: 1400,
        occurredOn: DateTime(2026, 2, 2),
      ),
    ];

    final cashflow = cashflowService.build(
      movements: movements,
      referenceDate: referenceDate,
    );
    final pace = paceService.build(
      referenceDate: referenceDate,
      cashflow: cashflow,
    );
    final health = healthService.build(
      cashflow: cashflow,
      spendingPace: pace,
      categoryComparison: categoryService.build(
        movements: movements,
        referenceDate: referenceDate,
      ),
    );

    expect(cashflow.isOvercommitted, isTrue);
    expect(pace.status, SpendingPaceStatus.risk);
    expect(health.level, FinancialHealthLevel.risk);
  });

  test('EndOfMonthProjectionService proyecta gasto y clasifica riesgo', () {
    const service = EndOfMonthProjectionService();
    final projection = service.build(
      referenceDate: referenceDate,
      incomeSoFar: 1000,
      expenseSoFar: 900,
    );

    expect(projection.daysElapsed, 20);
    expect(projection.totalDaysInMonth, 31);
    expect(projection.daysRemaining, 11);
    expect(projection.avgDailyExpense, 45);
    expect(projection.projectedExpense, closeTo(1395, 0.001));
    expect(projection.projectedNet, closeTo(-395, 0.001));
    expect(projection.riskLevel, ProjectionRiskLevel.high);
  });
  test('SavingsGoalReportService estima fecha de cumplimiento con ritmo de aporte', () {
    const service = SavingsGoalReportService();
    final goal = SavingsGoalProgress(
      goal: SavingsGoal(
        id: 'goal-1',
        name: 'Viaje',
        targetAmount: 1000,
        isArchived: false,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
      savedAmount: 400,
    );

    final report = service.build(
      goals: [goal],
      savingsMovements: [
        movement(
          id: '1',
          type: MovementType.saving,
          amount: 200,
          occurredOn: DateTime(2026, 1, 15),
          goalId: 'goal-1',
        ),
        movement(
          id: '2',
          type: MovementType.saving,
          amount: 200,
          occurredOn: DateTime(2026, 2, 15),
          goalId: 'goal-1',
        ),
      ],
      referenceDate: referenceDate,
    );

    expect(report.single.averageMonthlyContribution, 200);
    expect(report.single.estimatedCompletionDate, isNotNull);
  });

  test('FinanceInsightsService clasifica insights utiles y cuantificados', () {
    const insightsService = FinanceInsightsService();
    final insights = insightsService.buildInsights(
      cashflow: const CashflowSnapshot(
        income: 1000,
        expense: 900,
        savings: 200,
        netBalance: -100,
        previousNetBalance: 50,
      ),
      categoryComparison: const CategoryComparisonReport(
        totalCurrentExpense: 900,
        totalPreviousExpense: 600,
        items: [
          CategoryComparisonItem(
            categoryName: 'Comida',
            currentAmount: 500,
            previousAmount: 300,
            shareOfCurrent: 0.55,
          ),
        ],
      ),
      spendingPace: const SpendingPaceReport(
        spentSoFar: 900,
        expectedSpendToDate: 533,
        projectedEndOfMonth: 1395,
        averageDailySpend: 45,
        daysElapsed: 20,
        daysInMonth: 31,
        safeSpendingCapacity: 800,
        projectedNetBalance: -595,
        status: SpendingPaceStatus.risk,
      ),
      healthScore: const FinancialHealthScore(
        score: 28,
        level: FinancialHealthLevel.risk,
        label: 'En riesgo',
        message: 'El ritmo actual puede dejarte sin margen.',
      ),
      largestExpense: 350,
    );

    expect(insights, isNotEmpty);
    expect(
      insights.any((insight) => insight.kind == FinanceInsightKind.predictive),
      isTrue,
    );
    expect(
      insights.any((insight) => insight.message.contains('%')),
      isTrue,
    );
  });
}

