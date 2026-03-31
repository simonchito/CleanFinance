import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import '../core/security/biometric_service.dart';
import '../core/security/password_hasher.dart';
import '../core/security/secure_storage_service.dart';
import '../features/auth/data/local_auth_repository.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/finance/data/local_finance_repository.dart';
import '../features/finance/domain/repositories/backup_repository.dart';
import '../features/finance/domain/repositories/categories_repository.dart';
import '../features/finance/domain/repositories/finance_repository.dart';
import '../features/finance/domain/repositories/movements_repository.dart';
import '../features/finance/domain/repositories/savings_goals_repository.dart';
import '../features/finance/domain/repositories/settings_repository.dart';
import '../features/finance/domain/services/cashflow_snapshot_service.dart';
import '../features/finance/domain/services/category_comparison_service.dart';
import '../features/finance/domain/services/end_of_month_projection_service.dart';
import '../features/finance/domain/services/financial_health_score_service.dart';
import '../features/finance/domain/services/finance_insights_service.dart';
import '../features/finance/domain/services/monthly_payment_reminder_service.dart';
import '../features/finance/domain/services/monthly_trend_service.dart';
import '../features/finance/domain/services/payment_method_report_service.dart';
import '../features/finance/domain/services/savings_goal_report_service.dart';
import '../features/finance/domain/services/spending_pace_service.dart';

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
final movementsRepositoryProvider = Provider<MovementsRepository>(
  (ref) => ref.watch(financeRepositoryProvider),
);
final categoriesRepositoryProvider = Provider<CategoriesRepository>(
  (ref) => ref.watch(financeRepositoryProvider),
);
final savingsGoalsRepositoryProvider = Provider<SavingsGoalsRepository>(
  (ref) => ref.watch(financeRepositoryProvider),
);
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => ref.watch(financeRepositoryProvider),
);
final backupRepositoryProvider = Provider<BackupRepository>(
  (ref) => ref.watch(financeRepositoryProvider),
);

final financeInsightsServiceProvider =
    Provider<FinanceInsightsService>((ref) => const FinanceInsightsService());
final monthlyPaymentReminderServiceProvider =
    Provider<MonthlyPaymentReminderService>(
      (ref) => const MonthlyPaymentReminderService(),
    );
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
final endOfMonthProjectionServiceProvider =
    Provider<EndOfMonthProjectionService>(
  (ref) => const EndOfMonthProjectionService(),
);
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

