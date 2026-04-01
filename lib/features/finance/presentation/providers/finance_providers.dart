import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/month_context.dart';
import '../../../../shared/providers.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/analytics_models.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/end_of_month_projection.dart';
import '../../domain/entities/monthly_payment_reminder.dart';
import '../../domain/entities/movement.dart';
import '../../domain/entities/movement_filter.dart';
import '../../domain/entities/reports_snapshot.dart';
import '../../domain/entities/savings_goal.dart';
import '../controllers/settings_controller.dart';
import '../models/finance_overview.dart';

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AsyncValue<AppSettings>>((ref) {
      final controller = SettingsController(
        settingsRepository: ref.watch(settingsRepositoryProvider),
      );
      Future.microtask(controller.load);
      return controller;
    });

final showSensitiveAmountsOverrideProvider = StateProvider<bool?>((ref) => null);

final showSensitiveAmountsProvider = Provider<bool>((ref) {
  final settingsState = ref.watch(settingsControllerProvider);
  final settings = settingsState.valueOrNull;
  if (settings != null) {
    return settings.showSensitiveAmounts;
  }

  // Privacy-first fallback while settings are still loading on app startup.
  return false;
});

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  final repo = ref.watch(movementsRepositoryProvider);
  return repo.getDashboardSummary(DateTime.now());
});

final recentMovementsProvider = FutureProvider<List<Movement>>((ref) async {
  final repo = ref.watch(movementsRepositoryProvider);
  return repo.getMovements(filter: const MovementFilter(limit: 10));
});

final categoriesProvider =
    FutureProvider.family<List<Category>, CategoryScope?>((ref, scope) async {
  final repo = ref.watch(categoriesRepositoryProvider);
  return repo.getCategories(scope: scope);
});

final movementsProvider =
    FutureProvider.family<List<Movement>, MovementFilter>((ref, filter) async {
  final repo = ref.watch(movementsRepositoryProvider);
  return repo.getMovements(filter: filter);
});

final savingsGoalsProvider =
    FutureProvider<List<SavingsGoalProgress>>((ref) async {
      final repo = ref.watch(savingsGoalsRepositoryProvider);
      return repo.getSavingsGoals();
    });

final reportsSnapshotProvider = FutureProvider<ReportsSnapshot>((ref) async {
  final overview = await ref.watch(financeOverviewProvider.future);
  return overview.reports;
});

final monthlyDueRemindersProvider =
    FutureProvider<List<MonthlyPaymentReminder>>((ref) async {
      final service = ref.watch(monthlyPaymentReminderServiceProvider);
      final movementsRepo = ref.watch(movementsRepositoryProvider);
      final referenceDate = DateTime.now();
      final currentMonth = MonthContext.forDate(referenceDate);
      final expenseCategories = await ref.watch(
        categoriesProvider(CategoryScope.expense).future,
      );
      final savingsGoals = await ref.watch(savingsGoalsProvider.future);
      final currentMonthMovements = await movementsRepo.getMovements(
        filter: MovementFilter(
          startDate: currentMonth.startDate,
          endDate: currentMonth.endDateInclusive,
        ),
      );

      return service.buildDueReminders(
        expenseCategories: expenseCategories,
        savingsGoals: savingsGoals,
        currentMonthMovements: currentMonthMovements,
        referenceDate: referenceDate,
      );
    });

final expenseReminderSubcategoriesProvider =
    FutureProvider<List<Category>>((ref) async {
      final categories = await ref.watch(
        categoriesProvider(CategoryScope.expense).future,
      );
      return categories
          .where((category) => category.isSubcategory && category.reminderEnabled)
          .toList();
    });

final savingsGoalRemindersProvider =
    FutureProvider<List<SavingsGoalProgress>>((ref) async {
      final goals = await ref.watch(savingsGoalsProvider.future);
      return goals.where((progress) => progress.goal.reminderEnabled).toList();
    });

final endOfMonthProjectionProvider =
    FutureProvider<EndOfMonthProjection>((ref) async {
      final overview = await ref.watch(financeOverviewProvider.future);
      return overview.endOfMonthProjection;
    });

final financeOverviewProvider = FutureProvider<FinanceOverview>((ref) async {
  final movementsRepo = ref.watch(movementsRepositoryProvider);
  final savingsGoalsRepo = ref.watch(savingsGoalsRepositoryProvider);
  final insightService = ref.watch(financeInsightsServiceProvider);
  final monthlyTrendService = ref.watch(monthlyTrendServiceProvider);
  final categoryComparisonService = ref.watch(categoryComparisonServiceProvider);
  final cashflowSnapshotService = ref.watch(cashflowSnapshotServiceProvider);
  final spendingPaceService = ref.watch(spendingPaceServiceProvider);
  final endOfMonthProjectionService =
      ref.watch(endOfMonthProjectionServiceProvider);
  final savingsGoalReportService = ref.watch(savingsGoalReportServiceProvider);
  final paymentMethodReportService =
      ref.watch(paymentMethodReportServiceProvider);
  final healthScoreService = ref.watch(financialHealthScoreServiceProvider);

  final now = DateTime.now();
  final firstVisibleMonth = DateTime(now.year, now.month - 5, 1);
  final periodMovements = await movementsRepo.getMovements(
    filter: MovementFilter(startDate: firstVisibleMonth),
  );
  final savingMovements = await movementsRepo.getMovements(
    filter: const MovementFilter(type: MovementType.saving),
  );
  final savingsGoals = await savingsGoalsRepo.getSavingsGoals();
  final summary = await movementsRepo.getDashboardSummary(now);

  final recentMovements = periodMovements.take(5).toList();
  final cashflow = cashflowSnapshotService.build(
    movements: periodMovements,
    referenceDate: now,
  );
  final monthlyTrend = monthlyTrendService.build(
    movements: periodMovements,
    referenceDate: now,
  );
  final categoryComparison = categoryComparisonService.build(
    movements: periodMovements,
    referenceDate: now,
  );
  final spendingPace = spendingPaceService.build(
    referenceDate: now,
    cashflow: cashflow,
  );
  final endOfMonthProjection = endOfMonthProjectionService.build(
    referenceDate: now,
    incomeSoFar: cashflow.income,
    expenseSoFar: cashflow.expense,
  );
  final savingsGoalForecasts = savingsGoalReportService.build(
    goals: savingsGoals,
    savingsMovements: savingMovements,
    referenceDate: now,
  );
  final paymentMethodReport = paymentMethodReportService.build(
    movements: periodMovements,
    referenceDate: now,
  );
  final healthScore = healthScoreService.build(
    cashflow: cashflow,
    spendingPace: spendingPace,
    categoryComparison: categoryComparison,
  );
  final reports = ReportsSnapshot(
    incomeMonth: cashflow.income,
    expenseMonth: cashflow.expense,
    savingsMonth: cashflow.savings,
    netMonth: cashflow.netBalance,
    previousNetMonth: cashflow.previousNetBalance,
    topExpenseCategories: categoryComparison.items
        .map(
          (item) => CategorySpend(
            categoryName: item.categoryName,
            amount: item.currentAmount,
          ),
        )
        .toList(),
  );
  final insights = insightService.buildInsights(
    cashflow: cashflow,
    categoryComparison: categoryComparison,
    spendingPace: spendingPace,
    healthScore: healthScore,
    largestExpense: largestExpenseForMonth(periodMovements, now),
    savingsGoals: savingsGoalForecasts,
  );

  return FinanceOverview(
    summary: summary,
    reports: reports,
    recentMovements: recentMovements,
    cashflow: cashflow,
    monthlyTrend: monthlyTrend,
    categoryComparison: categoryComparison,
    spendingPace: spendingPace,
    endOfMonthProjection: endOfMonthProjection,
    savingsGoals: savingsGoalForecasts,
    paymentMethodReport: paymentMethodReport,
    healthScore: healthScore,
    insights: insights,
  );
});






