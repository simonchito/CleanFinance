import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../budgets/presentation/providers/budget_providers.dart';
import '../providers/finance_providers.dart';

final dataManagementControllerProvider =
    Provider.autoDispose<DataManagementController>(
  DataManagementController.new,
);

class DataManagementController {
  DataManagementController(this._ref);

  final Ref _ref;

  Future<String> exportData({String? password}) {
    return _ref.read(backupDataRepositoryProvider).exportData(
          password: password,
        );
  }

  Future<void> importData(String payload, {String? password}) async {
    await _ref.read(backupDataRepositoryProvider).importData(
          payload,
          password: password,
        );
    _refreshFinanceData();
  }

  Future<void> clearAllData() async {
    await _ref.read(backupDataRepositoryProvider).clearAllData();
    _ref.read(showSensitiveAmountsOverrideProvider.notifier).state = null;
    _refreshFinanceData(includeAuth: true);
  }

  void _refreshFinanceData({bool includeAuth = false}) {
    _ref.invalidate(settingsControllerProvider);
    _ref.invalidate(financeOverviewProvider);
    _ref.invalidate(dashboardSummaryProvider);
    _ref.invalidate(recentMovementsProvider);
    _ref.invalidate(reportsSnapshotProvider);
    _ref.invalidate(savingsGoalsProvider);
    _ref.invalidate(categoriesProvider);
    _ref.invalidate(movementsProvider);
    _ref.invalidate(monthlyDueRemindersProvider);
    _ref.invalidate(categoryBudgetStatusProvider);
    if (includeAuth) {
      _ref.invalidate(authControllerProvider);
    }
  }
}
