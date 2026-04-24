import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_locale_mode.dart';
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
import '../models/savings_summary.dart';

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AsyncValue<AppSettings>>((ref) {
  final controller = SettingsController(
    settingsRepository: ref.watch(settingsRepositoryProvider),
  );
  Future.microtask(controller.load);
  return controller;
});

final systemLocaleProvider = StateProvider<Locale>((ref) {
  return WidgetsBinding.instance.platformDispatcher.locale;
});

final appLocaleCodeProvider = Provider<String>((ref) {
  final localePreferenceCode =
      ref.watch(settingsControllerProvider).valueOrNull?.localeCode ??
          AppConstants.defaultLocalePreferenceCode;
  final deviceLocale = ref.watch(systemLocaleProvider);
  return AppLocaleMode.resolveLocaleCodeFromPreference(
    localePreferenceCode: localePreferenceCode,
    deviceLocale: deviceLocale,
  );
});

final showSensitiveAmountsOverrideProvider =
    StateProvider<bool?>((ref) => null);

final showSensitiveAmountsProvider = Provider<bool>((ref) {
  final override = ref.watch(showSensitiveAmountsOverrideProvider);
  if (override != null) {
    return override;
  }

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
  final categories = await repo.getCategories(scope: scope);
  return _sortCategoriesAlphabetically(categories);
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

final savingMovementsProvider = FutureProvider<List<Movement>>((ref) async {
  final repo = ref.watch(movementsRepositoryProvider);
  return repo.getMovements(
    filter: const MovementFilter(type: MovementType.saving),
  );
});

final unassignedSavingsProvider =
    FutureProvider<UnassignedSavingsSummary>((ref) async {
  final goals = await ref.watch(savingsGoalsProvider.future);
  final validGoalIds = goals.map((item) => item.goal.id).toSet();
  final savingsMovements = await ref.watch(savingMovementsProvider.future);
  final unassignedMovements = savingsMovements.where((movement) {
    final goalId = movement.goalId?.trim();
    if (goalId == null || goalId.isEmpty) {
      return true;
    }
    return !validGoalIds.contains(goalId);
  }).toList();

  final totalAmount = unassignedMovements.fold<double>(
    0,
    (sum, item) => sum + item.amount,
  );
  final lastContributionDate = unassignedMovements.isEmpty
      ? null
      : unassignedMovements.map((movement) => movement.occurredOn).reduce(
            (current, next) => current.isAfter(next) ? current : next,
          );

  return UnassignedSavingsSummary(
    totalAmount: totalAmount,
    movementsCount: unassignedMovements.length,
    lastContributionDate: lastContributionDate,
  );
});

final savingsSummaryProvider = FutureProvider<SavingsSummary>((ref) async {
  final goals = await ref.watch(savingsGoalsProvider.future);
  final unassigned = await ref.watch(unassignedSavingsProvider.future);

  final goalsSavedAmount = goals.fold<double>(
    0,
    (sum, item) => sum + item.savedAmount,
  );
  final totalGoalTargetAmount = goals.fold<double>(
    0,
    (sum, item) => sum + item.goal.targetAmount,
  );
  final completedGoalsCount = goals.where((item) => item.completed).length;

  return SavingsSummary(
    totalSavedAmount: goalsSavedAmount + unassigned.totalAmount,
    goalsSavedAmount: goalsSavedAmount,
    totalGoalTargetAmount: totalGoalTargetAmount,
    goalsCount: goals.length,
    completedGoalsCount: completedGoalsCount,
    unassignedSavings: unassigned,
  );
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
  final categoryComparisonService =
      ref.watch(categoryComparisonServiceProvider);
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

List<Category> _sortCategoriesAlphabetically(List<Category> categories) {
  final sortedTopLevel = categories
      .where((category) => category.parentId == null)
      .toList()
    ..sort(_compareByName);

  final childrenByParent = <String, List<Category>>{};
  final orphanSubcategories = <Category>[];

  for (final category in categories.where((item) => item.parentId != null)) {
    final parentId = category.parentId;
    if (parentId == null) {
      continue;
    }
    childrenByParent.putIfAbsent(parentId, () => <Category>[]).add(category);
  }

  for (final children in childrenByParent.values) {
    children.sort(_compareByName);
  }

  for (final category in categories.where((item) => item.parentId != null)) {
    final parentExists =
        sortedTopLevel.any((parent) => parent.id == category.parentId);
    if (!parentExists) {
      orphanSubcategories.add(category);
    }
  }
  orphanSubcategories.sort(_compareByName);

  return [
    for (final category in sortedTopLevel) ...[
      category,
      ...childrenByParent[category.id] ?? const <Category>[],
    ],
    ...orphanSubcategories,
  ];
}

int _compareByName(Category left, Category right) {
  return left.name.toLowerCase().compareTo(right.name.toLowerCase());
}
