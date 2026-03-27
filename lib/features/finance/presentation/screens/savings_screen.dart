import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/providers.dart';
import '../../domain/entities/movement.dart';
import '../../domain/entities/savings_goal.dart';
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
    ref.invalidate(savingsGoalsProvider);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openGoalEditor(context, ref),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          goalsState.when(
            data: (goals) {
              if (goals.isEmpty) {
                return const SectionCard(
                  child: Text('Todavía no tenés metas de ahorro.'),
                );
              }

              return Column(
                children: goals.map((progress) {
                  final goal = progress.goal;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  goal.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _openGoalEditor(
                                  context,
                                  ref,
                                  goal: goal,
                                ),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${CurrencyFormatter.format(progress.savedAmount, symbol: symbol)} de ${CurrencyFormatter.format(goal.targetAmount, symbol: symbol)}',
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: progress.progress,
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      _openContribution(context, ref, progress),
                                  child: const Text('Aportar'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () async {
                                    await ref
                                        .read(financeRepositoryProvider)
                                        .deleteSavingsGoal(goal.id);
                                    ref.invalidate(savingsGoalsProvider);
                                  },
                                  child: const Text('Eliminar'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) =>
                Text('No se pudieron cargar las metas: $error'),
          ),
        ],
      ),
    );
  }
}
