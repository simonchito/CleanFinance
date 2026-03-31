import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers.dart';
import '../../data/repositories/local_budget_repository.dart';
import '../../domain/models/category_budget_status.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/services/budget_service.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => LocalBudgetRepository(ref.watch(appDatabaseProvider)),
);

final budgetServiceProvider = Provider<BudgetService>(
  (ref) => BudgetService(
    budgetRepository: ref.watch(budgetRepositoryProvider),
    categoriesRepository: ref.watch(categoriesRepositoryProvider),
    movementsRepository: ref.watch(movementsRepositoryProvider),
  ),
);

final categoryBudgetStatusProvider =
    FutureProvider<List<CategoryBudgetStatus>>((ref) async {
  final service = ref.watch(budgetServiceProvider);
  return service.getCategoryBudgetStatuses();
});
