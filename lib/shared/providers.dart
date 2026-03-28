import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import '../core/security/biometric_service.dart';
import '../core/security/password_hasher.dart';
import '../core/security/secure_storage_service.dart';
import '../features/auth/data/local_auth_repository.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/auth_state.dart';
import '../features/finance/data/local_finance_repository.dart';
import '../features/finance/domain/entities/app_settings.dart';
import '../features/finance/domain/entities/analytics_models.dart';
import '../features/finance/domain/entities/category.dart';
import '../features/finance/domain/entities/dashboard_summary.dart';
import '../features/finance/domain/entities/movement.dart';
import '../features/finance/domain/entities/movement_filter.dart';
import '../features/finance/domain/entities/reports_snapshot.dart';
import '../features/finance/domain/entities/savings_goal.dart';
import '../features/finance/domain/repositories/finance_repository.dart';
import '../features/finance/domain/services/cashflow_snapshot_service.dart';
import '../features/finance/domain/services/category_comparison_service.dart';
import '../features/finance/domain/services/financial_health_score_service.dart';
import '../features/finance/domain/services/finance_insights_service.dart';
import '../features/finance/domain/services/monthly_trend_service.dart';
import '../features/finance/domain/services/payment_method_report_service.dart';
import '../features/finance/domain/services/savings_goal_report_service.dart';
import '../features/finance/domain/services/spending_pace_service.dart';
import '../features/finance/presentation/controllers/settings_controller.dart';
import '../features/finance/presentation/models/finance_overview.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final secureStorageProvider =
    Provider<SecureStorageService>((ref) => SecureStorageService());

final passwordHasherProvider =
    Provider<PasswordHasher>((ref) => PasswordHasher());

final biometricServiceProvider =
    Provider<BiometricService>((ref) => BiometricService());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => LocalAuthRepository(
    secureStorage: ref.watch(secureStorageProvider),
    passwordHasher: ref.watch(passwordHasherProvider),
    biometricService: ref.watch(biometricServiceProvider),
  ),
);

final financeRepositoryProvider = Provider<FinanceRepository>(
  (ref) => LocalFinanceRepository(
    ref.watch(appDatabaseProvider),
    secureStorage: ref.watch(secureStorageProvider),
  ),
);

final financeInsightsServiceProvider =
    Provider<FinanceInsightsService>((ref) => const FinanceInsightsService());
final monthlyTrendServiceProvider =
    Provider<MonthlyTrendService>((ref) => const MonthlyTrendService());
final categoryComparisonServiceProvider = Provider<CategoryComparisonService>(
  (ref) => const CategoryComparisonService(),
);
final cashflowSnapshotServiceProvider = Provider<CashflowSnapshotService>(
  (ref) => const CashflowSnapshotService(),
);
final spendingPaceServiceProvider =
    Provider<SpendingPaceService>((ref) => const SpendingPaceService());
final savingsGoalReportServiceProvider = Provider<SavingsGoalReportService>(
  (ref) => const SavingsGoalReportService(),
);
final paymentMethodReportServiceProvider = Provider<PaymentMethodReportService>(
  (ref) => const PaymentMethodReportService(),
);
final financialHealthScoreServiceProvider =
    Provider<FinancialHealthScoreService>(
  (ref) => const FinancialHealthScoreService(),
);

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final controller = AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    financeRepository: ref.watch(financeRepositoryProvider),
  );
  Future.microtask(controller.bootstrap);
  return controller;
});

final settingsControllerProvider = StateNotifierProvider<SettingsController,
    AsyncValue<AppSettings>>((ref) {
  final controller = SettingsController(
    financeRepository: ref.watch(financeRepositoryProvider),
  );
  Future.microtask(controller.load);
  return controller;
});

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getDashboardSummary(DateTime.now());
});

final recentMovementsProvider = FutureProvider<List<Movement>>((ref) async {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getMovements(filter: const MovementFilter(limit: 10));
});

final categoriesProvider =
    FutureProvider.family<List<Category>, CategoryScope?>((ref, scope) async {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getCategories(scope: scope);
});

final movementsProvider =
    FutureProvider.family<List<Movement>, MovementFilter>((ref, filter) async {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getMovements(filter: filter);
});

final savingsGoalsProvider = FutureProvider<List<SavingsGoalProgress>>((ref) async {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getSavingsGoals();
});

final reportsSnapshotProvider = FutureProvider<ReportsSnapshot>((ref) async {
  final overview = await ref.watch(financeOverviewProvider.future);
  return overview.reports;
});

final financeOverviewProvider = FutureProvider<FinanceOverview>((ref) async {
  final repo = ref.watch(financeRepositoryProvider);
  final insightService = ref.watch(financeInsightsServiceProvider);
  final monthlyTrendService = ref.watch(monthlyTrendServiceProvider);
  final categoryComparisonService = ref.watch(categoryComparisonServiceProvider);
  final cashflowSnapshotService = ref.watch(cashflowSnapshotServiceProvider);
  final spendingPaceService = ref.watch(spendingPaceServiceProvider);
  final savingsGoalReportService = ref.watch(savingsGoalReportServiceProvider);
  final paymentMethodReportService = ref.watch(paymentMethodReportServiceProvider);
  final healthScoreService = ref.watch(financialHealthScoreServiceProvider);

  final now = DateTime.now();
  final firstVisibleMonth = DateTime(now.year, now.month - 5, 1);
  final periodMovements = await repo.getMovements(
    filter: MovementFilter(startDate: firstVisibleMonth),
  );
  final savingMovements = await repo.getMovements(
    filter: const MovementFilter(type: MovementType.saving),
  );
  final savingsGoals = await repo.getSavingsGoals();
  final summary = await repo.getDashboardSummary(now);

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
    savingsGoals: savingsGoalForecasts,
    paymentMethodReport: paymentMethodReport,
    healthScore: healthScore,
    insights: insights,
  );
});
