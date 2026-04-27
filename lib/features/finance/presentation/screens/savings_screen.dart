import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/utils/amount_visibility_formatter.dart';
import '../../../../shared/providers.dart';
import '../../domain/entities/movement.dart';
import '../../domain/entities/savings_goal.dart';
import '../models/savings_summary.dart';
import '../providers/finance_providers.dart';
import '../widgets/confirm_action_dialog.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/section_card.dart';
import 'movement_form_screen.dart';
import 'savings_goal_form_screen.dart';

class SavingsScreen extends ConsumerWidget {
  const SavingsScreen({super.key});

  Future<void> _openGoalEditor(
    BuildContext context,
    WidgetRef ref, {
    SavingsGoal? goal,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SavingsGoalFormScreen(initialGoal: goal),
      ),
    );
    _refresh(ref);
  }

  Future<void> _openContribution(
    BuildContext context,
    WidgetRef ref,
    SavingsGoalProgress progress,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovementFormScreen(
          initialMovement: Movement(
            id: '',
            type: MovementType.saving,
            amount: 0,
            categoryId: '',
            goalId: progress.goal.id,
            occurredOn: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ),
      ),
    );
    _refresh(ref);
  }

  Future<void> _openGeneralContribution(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const MovementFormScreen(
          initialType: MovementType.saving,
        ),
      ),
    );
    _refresh(ref);
  }

  void _refresh(WidgetRef ref) {
    ref.invalidate(financeOverviewProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(savingMovementsProvider);
    ref.invalidate(unassignedSavingsProvider);
    ref.invalidate(savingsSummaryProvider);
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(reportsSnapshotProvider);
    ref.invalidate(savingsGoalRemindersProvider);
    ref.invalidate(monthlyDueRemindersProvider);
  }

  Future<void> _deleteGoal(
    BuildContext context,
    WidgetRef ref,
    SavingsGoal goal,
  ) async {
    final strings = AppStrings.of(context);
    final confirmed = await showConfirmActionDialog(
      context: context,
      title: strings.t('eliminarMeta'),
      message: strings.deleteSavingsGoalMessage(goal.name),
      confirmLabel: strings.t('eliminar'),
      cancelLabel: strings.cancel,
    );
    if (!confirmed) {
      return;
    }

    await ref.read(savingsGoalsRepositoryProvider).deleteSavingsGoal(goal.id);
    _refresh(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final goalsState = ref.watch(savingsGoalsProvider);
    final savingsSummaryState = ref.watch(savingsSummaryProvider);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final symbol = settings?.currencySymbol ?? r'$';
    final localeCode = ref.watch(appLocaleCodeProvider);
    final showSensitiveAmounts = ref.watch(showSensitiveAmountsProvider);
    String formatAmount(double amount) =>
        AmountVisibilityFormatter.formatCurrency(
          amount: amount,
          symbol: symbol,
          isVisible: showSensitiveAmounts,
          localeCode: localeCode,
        );

    return Scaffold(
      appBar: AppBar(title: Text(strings.savings)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'savings-fab',
        onPressed: () => _openGoalEditor(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(strings.newGoal),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
        children: [
          savingsSummaryState.when(
            data: (summary) {
              return goalsState.when(
                data: (goals) {
                  if (!summary.hasAnySavingsData) {
                    return EmptyStateView(
                      icon: Icons.savings_outlined,
                      title: strings.t('todaviaNoTenesAhorroRegistrado'),
                      message: strings.t('creaUnaMetaORegistraUnAporte'),
                      actionLabel: strings.t('createGoal'),
                      onAction: () => _openGoalEditor(context, ref),
                    );
                  }

                  final activeGoals =
                      goals.where((goal) => !goal.completed).toList();
                  final completedGoals =
                      goals.where((goal) => goal.completed).toList();
                  final unassigned = summary.unassignedSavings;

                  return Column(
                    children: [
                      SectionCard(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.secondaryContainer,
                            Theme.of(context).colorScheme.surface,
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.t('totalAhorrado'),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              formatAmount(summary.totalSavedAmount),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              unassigned.hasSavings
                                  ? strings.savingsGeneralIncluded(
                                      formatAmount(unassigned.totalAmount),
                                    )
                                  : (strings
                                      .t('todoLoQueAhorrasteEstaOrganizadoEn')),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: _SummaryStat(
                                    label: strings.text6,
                                    value: '${summary.goalsCount}',
                                  ),
                                ),
                                Expanded(
                                  child: _SummaryStat(
                                    label: strings.t('objetivo'),
                                    value: formatAmount(
                                      summary.totalGoalTargetAmount,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: _SummaryStat(
                                    label: strings.t('logradas'),
                                    value: '${summary.completedGoalsCount}',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (unassigned.hasSavings) ...[
                        const SizedBox(height: 14),
                        _GeneralSavingsCard(
                          summary: unassigned,
                          symbol: symbol,
                          localeCode: localeCode,
                          showAmounts: showSensitiveAmounts,
                          onContribute: () =>
                              _openGeneralContribution(context, ref),
                          onCreateGoal: () => _openGoalEditor(context, ref),
                        ),
                      ],
                      if (activeGoals.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            strings.t('activeGoals'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...activeGoals.map(
                          (progress) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _GoalCard(
                              progress: progress,
                              symbol: symbol,
                              localeCode: localeCode,
                              showAmounts: showSensitiveAmounts,
                              onEdit: () => _openGoalEditor(
                                context,
                                ref,
                                goal: progress.goal,
                              ),
                              onContribute: () =>
                                  _openContribution(context, ref, progress),
                              onDelete: () =>
                                  _deleteGoal(context, ref, progress.goal),
                            ),
                          ),
                        ),
                      ],
                      if (completedGoals.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            strings.t('metasLogradas'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...completedGoals.map(
                          (progress) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _GoalCard(
                              progress: progress,
                              symbol: symbol,
                              localeCode: localeCode,
                              showAmounts: showSensitiveAmounts,
                              onEdit: () => _openGoalEditor(
                                context,
                                ref,
                                goal: progress.goal,
                              ),
                              onContribute: () =>
                                  _openContribution(context, ref, progress),
                              onDelete: () =>
                                  _deleteGoal(context, ref, progress.goal),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => EmptyStateView(
                  icon: Icons.error_outline_rounded,
                  title: strings.t('noPudimosCargarTusMetas'),
                  message: strings.technicalErrorDetails(error),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => EmptyStateView(
              icon: Icons.error_outline_rounded,
              title: strings.t('noPudimosCargarAhorros'),
              message: strings.technicalErrorDetails(error),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneralSavingsCard extends StatelessWidget {
  const _GeneralSavingsCard({
    required this.summary,
    required this.symbol,
    required this.localeCode,
    required this.showAmounts,
    required this.onContribute,
    required this.onCreateGoal,
  });

  final UnassignedSavingsSummary summary;
  final String symbol;
  final String localeCode;
  final bool showAmounts;
  final VoidCallback onContribute;
  final VoidCallback onCreateGoal;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final lastContributionDate = summary.lastContributionDate == null
        ? null
        : DateFormat('d MMM y', strings.languageCode)
            .format(summary.lastContributionDate!);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined),
              const SizedBox(width: 8),
              Text(
                strings.t('ahorroGeneral'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AmountVisibilityFormatter.formatCurrency(
              amount: summary.totalAmount,
              symbol: symbol,
              isVisible: showAmounts,
              localeCode: localeCode,
            ),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            strings.t('dineroGuardadoSinUnaMetaEspecifica'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            lastContributionDate == null
                ? strings.savingsContributionCount(summary.movementsCount)
                : strings.savingsContributionCountWithDate(
                    summary.movementsCount,
                    lastContributionDate,
                  ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            strings.t('creaUnaMetaParaOrganizarMejorTus'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onContribute,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(strings.contribute),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onCreateGoal,
                  child: Text(strings.createGoal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.progress,
    required this.symbol,
    required this.localeCode,
    required this.showAmounts,
    required this.onEdit,
    required this.onContribute,
    required this.onDelete,
  });

  final SavingsGoalProgress progress;
  final String symbol;
  final String localeCode;
  final bool showAmounts;
  final VoidCallback onEdit;
  final VoidCallback onContribute;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final goal = progress.goal;
    final scheme = Theme.of(context).colorScheme;
    final dueDate = goal.targetDate == null
        ? strings.unlimitedDate
        : strings.savingsGoalTargetDate(
            DateFormat('d MMM y', strings.languageCode).format(
              goal.targetDate!,
            ),
          );

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (progress.completed)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    strings.achieved,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: scheme.primary,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            strings.savingsGoalProgress(
              AmountVisibilityFormatter.formatCurrency(
                amount: progress.savedAmount,
                symbol: symbol,
                isVisible: showAmounts,
                localeCode: localeCode,
              ),
              AmountVisibilityFormatter.formatCurrency(
                amount: goal.targetAmount,
                symbol: symbol,
                isVisible: showAmounts,
                localeCode: localeCode,
              ),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            dueDate,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.progress,
              minHeight: 12,
              backgroundColor: scheme.primary.withValues(alpha: 0.12),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            progress.completed
                ? (strings.t('excelenteYaAlcanzasteEstaMeta'))
                : strings.savingsGoalRemaining(
                    AmountVisibilityFormatter.formatCurrency(
                      amount: (goal.targetAmount - progress.savedAmount)
                          .clamp(0, goal.targetAmount)
                          .toDouble(),
                      symbol: symbol,
                      isVisible: showAmounts,
                      localeCode: localeCode,
                    ),
                  ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onContribute,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(strings.contribute),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              const SizedBox(width: 6),
              IconButton.filledTonal(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
