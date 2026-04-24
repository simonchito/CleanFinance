import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/currency_formatter.dart';
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
    final confirmed = await showConfirmActionDialog(
      context: context,
      title: 'Eliminar meta',
      message:
          'Se eliminará la meta "${goal.name}". Los aportes ya registrados seguirán existiendo, pero dejarán de estar vinculados a esta meta.',
      confirmLabel: 'Eliminar',
    );
    if (!confirmed) {
      return;
    }

    await ref.read(savingsGoalsRepositoryProvider).deleteSavingsGoal(goal.id);
    _refresh(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsState = ref.watch(savingsGoalsProvider);
    final savingsSummaryState = ref.watch(savingsSummaryProvider);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final symbol = settings?.currencySymbol ?? r'$';
    final localeCode = settings?.localeCode ?? 'es';

    return Scaffold(
      appBar: AppBar(title: const Text('Ahorros')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'savings-fab',
        onPressed: () => _openGoalEditor(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva meta'),
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
                      title: 'Todavía no tenés ahorro registrado',
                      message:
                          'Creá una meta o registrá un aporte para empezar a ordenar tus ahorros.',
                      actionLabel: 'Crear meta',
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
                              'Total ahorrado',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              CurrencyFormatter.format(
                                summary.totalSavedAmount,
                                symbol: symbol,
                                localeCode: localeCode,
                              ),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              unassigned.hasSavings
                                  ? 'Incluye ${CurrencyFormatter.format(unassigned.totalAmount, symbol: symbol, localeCode: localeCode)} en ahorro general.'
                                  : 'Todo lo que ahorraste está organizado en metas.',
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
                                    label: 'Metas',
                                    value: '${summary.goalsCount}',
                                  ),
                                ),
                                Expanded(
                                  child: _SummaryStat(
                                    label: 'Objetivo',
                                    value: CurrencyFormatter.format(
                                      summary.totalGoalTargetAmount,
                                      symbol: symbol,
                                      localeCode: localeCode,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: _SummaryStat(
                                    label: 'Logradas',
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
                            'Metas activas',
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
                            'Metas logradas',
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
                  title: 'No pudimos cargar tus metas',
                  message: '$error',
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => EmptyStateView(
              icon: Icons.error_outline_rounded,
              title: 'No pudimos cargar ahorros',
              message: '$error',
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
    required this.onContribute,
    required this.onCreateGoal,
  });

  final UnassignedSavingsSummary summary;
  final String symbol;
  final String localeCode;
  final VoidCallback onContribute;
  final VoidCallback onCreateGoal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lastContributionDate = summary.lastContributionDate == null
        ? null
        : DateFormat('d MMM y', 'es').format(summary.lastContributionDate!);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined),
              const SizedBox(width: 8),
              Text(
                'Ahorro general',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(
              summary.totalAmount,
              symbol: symbol,
              localeCode: localeCode,
            ),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            'Dinero guardado sin una meta específica.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            lastContributionDate == null
                ? '${summary.movementsCount} aporte${summary.movementsCount == 1 ? '' : 's'} registrado${summary.movementsCount == 1 ? '' : 's'}.'
                : '${summary.movementsCount} aporte${summary.movementsCount == 1 ? '' : 's'} · último: $lastContributionDate.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Creá una meta para organizar mejor tus ahorros.',
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
                  label: const Text('Aportar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onCreateGoal,
                  child: const Text('Crear meta'),
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
    required this.onEdit,
    required this.onContribute,
    required this.onDelete,
  });

  final SavingsGoalProgress progress;
  final String symbol;
  final String localeCode;
  final VoidCallback onEdit;
  final VoidCallback onContribute;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final goal = progress.goal;
    final scheme = Theme.of(context).colorScheme;
    final dueDate = goal.targetDate == null
        ? 'Sin fecha límite'
        : 'Objetivo: ${DateFormat('d MMM y', 'es').format(goal.targetDate!)}';

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
                    'Lograda',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: scheme.primary,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${CurrencyFormatter.format(progress.savedAmount, symbol: symbol, localeCode: localeCode)} de ${CurrencyFormatter.format(goal.targetAmount, symbol: symbol, localeCode: localeCode)}',
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
                ? 'Excelente. Ya alcanzaste esta meta.'
                : 'Te falta ${CurrencyFormatter.format((goal.targetAmount - progress.savedAmount).clamp(0, goal.targetAmount), symbol: symbol, localeCode: localeCode)} para llegar.',
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
                  label: const Text('Aportar'),
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
