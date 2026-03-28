import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/providers.dart';
import '../../domain/entities/movement.dart';
import '../../domain/entities/savings_goal.dart';
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

  void _refresh(WidgetRef ref) {
    ref.invalidate(financeOverviewProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(reportsSnapshotProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsState = ref.watch(savingsGoalsProvider);
    final symbol =
        ref.watch(settingsControllerProvider).valueOrNull?.currencySymbol ?? r'$';

    return Scaffold(
      appBar: AppBar(title: const Text('Ahorros')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openGoalEditor(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva meta'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
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
                  'Tus metas visibles y simples',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Seguí tu progreso con una lectura rápida y agregá aportes en pocos pasos.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          goalsState.when(
            data: (goals) {
              if (goals.isEmpty) {
                return EmptyStateView(
                  icon: Icons.savings_outlined,
                  title: 'Todavía no tenés metas',
                  message: 'Creá una meta simple y empezá a ver el progreso de tu ahorro.',
                  actionLabel: 'Crear meta',
                  onAction: () => _openGoalEditor(context, ref),
                );
              }

              final savedTotal = goals.fold<double>(
                0,
                (sum, item) => sum + item.savedAmount,
              );
              final targetTotal = goals.fold<double>(
                0,
                (sum, item) => sum + item.goal.targetAmount,
              );
              final activeGoals =
                  goals.where((goal) => !goal.completed).toList();
              final completedGoals =
                  goals.where((goal) => goal.completed).toList();

              return Column(
                children: [
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Podés ahorrar en varias metas al mismo tiempo',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Organizá objetivos distintos como viaje, fondo de emergencia o compras grandes.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                label: 'Ahorrado',
                                value: CurrencyFormatter.format(savedTotal, symbol: symbol),
                              ),
                            ),
                            Expanded(
                              child: _SummaryStat(
                                label: 'Objetivo',
                                value: CurrencyFormatter.format(targetTotal, symbol: symbol),
                              ),
                            ),
                            Expanded(
                              child: _SummaryStat(
                                label: 'Completadas',
                                value: '${completedGoals.length}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (activeGoals.isNotEmpty) ...[
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
                          onEdit: () => _openGoalEditor(
                            context,
                            ref,
                            goal: progress.goal,
                          ),
                          onContribute: () =>
                              _openContribution(context, ref, progress),
                          onDelete: () async {
                            await ref
                                .read(savingsGoalsRepositoryProvider)
                                .deleteSavingsGoal(progress.goal.id);
                            _refresh(ref);
                          },
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
                          onEdit: () => _openGoalEditor(
                            context,
                            ref,
                            goal: progress.goal,
                          ),
                          onContribute: () =>
                              _openContribution(context, ref, progress),
                          onDelete: () async {
                            await ref
                                .read(savingsGoalsRepositoryProvider)
                                .deleteSavingsGoal(progress.goal.id);
                            _refresh(ref);
                          },
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
    required this.onEdit,
    required this.onContribute,
    required this.onDelete,
  });

  final SavingsGoalProgress progress;
  final String symbol;
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
            '${CurrencyFormatter.format(progress.savedAmount, symbol: symbol)} de ${CurrencyFormatter.format(goal.targetAmount, symbol: symbol)}',
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
                : 'Te falta ${CurrencyFormatter.format((goal.targetAmount - progress.savedAmount).clamp(0, goal.targetAmount), symbol: symbol)} para llegar.',
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
