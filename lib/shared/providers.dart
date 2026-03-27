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
import '../features/finance/domain/entities/category.dart';
import '../features/finance/domain/entities/dashboard_summary.dart';
import '../features/finance/domain/entities/movement.dart';
import '../features/finance/domain/entities/movement_filter.dart';
import '../features/finance/domain/entities/reports_snapshot.dart';
import '../features/finance/domain/entities/savings_goal.dart';
import '../features/finance/domain/repositories/finance_repository.dart';
import '../features/finance/presentation/controllers/settings_controller.dart';

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
  (ref) => LocalFinanceRepository(ref.watch(appDatabaseProvider)),
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
