import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
import '../features/finance/domain/entities/category.dart';
import '../features/finance/domain/entities/dashboard_summary.dart';
import '../features/finance/domain/entities/movement.dart';
import '../features/finance/domain/entities/movement_filter.dart';
import '../features/finance/domain/entities/reports_snapshot.dart';
import '../features/finance/domain/entities/savings_goal.dart';
import '../features/finance/domain/repositories/finance_repository.dart';
import '../features/finance/domain/services/finance_insights_service.dart';
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

final dashboardSummaryProvider =
    FutureProvider<DashboardSummary>((ref) async {
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

final savingsGoalsProvider =
    FutureProvider<List<SavingsGoalProgress>>((ref) async {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getSavingsGoals();
});

final reportsSnapshotProvider =
    FutureProvider<ReportsSnapshot>((ref) async {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getReportsSnapshot(DateTime.now());
});

final financeOverviewProvider = FutureProvider<FinanceOverview>((ref) async {
  final repo = ref.watch(financeRepositoryProvider);
  final insightService = ref.watch(financeInsightsServiceProvider);
  final now = DateTime.now();
  final firstVisibleMonth = DateTime(now.year, now.month - 5, 1);
  final allRecentMovements = await repo.getMovements(
    filter: MovementFilter(startDate: firstVisibleMonth),
  );

  final summary = await repo.getDashboardSummary(now);
  final reports = await repo.getReportsSnapshot(now);
  final recentMovements = allRecentMovements.take(5).toList();

  final currentMonthStart = DateTime(now.year, now.month, 1);
  final previousMonthStart = DateTime(now.year, now.month - 1, 1);

  final monthlyBuckets = <String, ({double income, double expense})>{};
  final currentCategoryExpenses = <String, double>{};
  final previousCategoryExpenses = <String, double>{};
  var largestExpense = 0.0;

  for (var i = 0; i < 6; i++) {
    final month = DateTime(now.year, now.month - (5 - i), 1);
    final label = DateFormat('MMM', 'es').format(month);
    monthlyBuckets[label] = (income: 0, expense: 0);
  }

  for (final movement in allRecentMovements) {
    final monthKey =
        DateFormat('MMM', 'es').format(DateTime(movement.occurredOn.year, movement.occurredOn.month, 1));
    final bucket = monthlyBuckets[monthKey];
    if (bucket == null) {
      continue;
    }

    if (movement.type == MovementType.income) {
      monthlyBuckets[monthKey] = (
        income: bucket.income + movement.amount,
        expense: bucket.expense,
      );
    } else if (movement.type == MovementType.expense) {
      monthlyBuckets[monthKey] = (
        income: bucket.income,
        expense: bucket.expense + movement.amount,
      );
      largestExpense = movement.amount > largestExpense
          ? movement.amount
          : largestExpense;

      final categoryName = movement.categoryName ?? 'Sin categoría';
      final expenseMonth =
          DateTime(movement.occurredOn.year, movement.occurredOn.month, 1);
      if (expenseMonth == currentMonthStart) {
        currentCategoryExpenses.update(
          categoryName,
          (value) => value + movement.amount,
          ifAbsent: () => movement.amount,
        );
      } else if (expenseMonth == previousMonthStart) {
        previousCategoryExpenses.update(
          categoryName,
          (value) => value + movement.amount,
          ifAbsent: () => movement.amount,
        );
      }
    }
  }

  final monthlyTrend = monthlyBuckets.entries
      .map(
        (entry) => MonthlyTrendPoint(
          label: _monthLabel(entry.key),
          income: entry.value.income,
          expense: entry.value.expense,
        ),
      )
      .toList();

  final averageExpense = monthlyTrend.isEmpty
      ? 0.0
      : monthlyTrend.fold<double>(0, (sum, point) => sum + point.expense) /
          monthlyTrend.length;
  final monthRemaining =
      summary.incomeMonth - summary.expenseMonth - summary.savingsMonth;
  final insights = insightService.buildInsights(
    monthIncome: summary.incomeMonth,
    monthExpense: summary.expenseMonth,
    monthSavings: summary.savingsMonth,
    previousNetMonth: reports.previousNetMonth,
    currentNetMonth: reports.netMonth,
    averageExpense: averageExpense,
    currentCategoryExpenses: currentCategoryExpenses,
    previousCategoryExpenses: previousCategoryExpenses,
    largestExpense: largestExpense,
  );

  return FinanceOverview(
    summary: summary,
    reports: reports,
    recentMovements: recentMovements,
    monthlyTrend: monthlyTrend,
    insights: insights,
    monthRemaining: monthRemaining,
    averageExpense: averageExpense,
    largestExpense: largestExpense,
  );
});

String _monthLabel(String raw) {
  if (raw.isEmpty) {
    return raw;
  }
  return raw[0].toUpperCase() + raw.substring(1).replaceAll('.', '');
}
