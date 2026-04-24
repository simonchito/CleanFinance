import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_strings.dart';
import '../../../finance/presentation/providers/finance_providers.dart';
import '../../../finance/presentation/widgets/empty_state_view.dart';
import '../../../finance/presentation/widgets/section_card.dart';
import '../../domain/models/budget.dart';
import '../../domain/models/category_budget_status.dart';
import '../providers/budget_providers.dart';
import '../widgets/budget_status_card.dart';
import 'budget_form_screen.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    Budget? initialBudget,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BudgetFormScreen(initialBudget: initialBudget),
      ),
    );
    ref.invalidate(categoryBudgetStatusProvider);
  }

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(categoryBudgetStatusProvider);
  }

  Future<Budget?> _findBudget(
    WidgetRef ref,
    CategoryBudgetStatus item,
  ) {
    final monthKey = Budget.monthKeyFor(DateTime.now());
    return ref.read(budgetRepositoryProvider).getBudgetByCategoryAndMonth(
          item.categoryId,
          monthKey,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final budgetState = ref.watch(categoryBudgetStatusProvider);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final symbol = settings?.currencySymbol ?? r'$';
    final localeCode = ref.watch(appLocaleCodeProvider);
    final monthLabel =
        DateFormat.yMMMM(strings.languageCode).format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.budgets),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'budgets-fab',
        onPressed: () => _openForm(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(strings.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: budgetState.when(
          data: (items) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
              children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.isEnglish
                            ? 'Monthly budgets'
                            : 'Presupuestos mensuales',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings.isEnglish
                            ? 'Track how each category is doing this month and update limits whenever you need.'
                            : 'Seguí cómo viene cada categoría este mes y ajustá los límites cuando lo necesites.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_month_outlined, size: 18),
                            const SizedBox(width: 8),
                            Flexible(child: Text(monthLabel)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  EmptyStateView(
                    icon: Icons.account_balance_wallet_outlined,
                    title: strings.isEnglish
                        ? 'Create your first budget'
                        : 'Creá tu primer presupuesto',
                    message: strings.isEnglish
                        ? 'Set a monthly limit for an expense category and we will track how much you have already spent.'
                        : 'Definí un límite mensual para una categoría de gasto y vamos a seguir cuánto ya gastaste.',
                    actionLabel: strings.isEnglish
                        ? 'Add budget'
                        : 'Agregar presupuesto',
                    onAction: () => _openForm(context, ref),
                  )
                else
                  ...items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: BudgetStatusCard(
                        item: item,
                        currencySymbol: symbol,
                        localeCode: localeCode,
                        onTap: () async {
                          final budget = await _findBudget(ref, item);
                          if (!context.mounted) {
                            return;
                          }
                          await _openForm(
                            context,
                            ref,
                            initialBudget: budget,
                          );
                        },
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              EmptyStateView(
                icon: Icons.error_outline_rounded,
                title: strings.isEnglish
                    ? 'Could not load budgets'
                    : 'No se pudieron cargar los presupuestos',
                message: '$error',
                actionLabel: strings.localized(es: 'Reintentar', en: 'Retry'),
                onAction: () => ref.invalidate(categoryBudgetStatusProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
