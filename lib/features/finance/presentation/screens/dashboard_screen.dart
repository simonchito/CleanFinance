import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/providers.dart';
import '../../domain/entities/movement.dart';
import '../widgets/section_card.dart';
import 'movement_form_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryState = ref.watch(dashboardSummaryProvider);
    final recentMovementsState = ref.watch(recentMovementsProvider);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final symbol = settings?.currencySymbol ?? r'$';
    final monthLabel =
        DateFormat.yMMMM('es').format(DateTime.now()).replaceFirstMapped(
              RegExp(r'^[a-z]'),
              (match) => match.group(0)!.toUpperCase(),
            );

    Future<void> openForm() async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const MovementFormScreen(),
        ),
      );
      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(recentMovementsProvider);
      ref.invalidate(reportsSnapshotProvider);
      ref.invalidate(savingsGoalsProvider);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openForm,
        icon: const Icon(Icons.add),
        label: const Text('Movimiento'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            monthLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          summaryState.when(
            data: (summary) => Column(
              children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo disponible',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        CurrencyFormatter.format(
                          summary.availableBalance,
                          symbol: symbol,
                        ),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${summary.currentMonthMovementCount} movimientos registrados este mes.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        title: 'Ingresos',
                        value: summary.incomeMonth,
                        symbol: symbol,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        title: 'Gastos',
                        value: summary.expenseMonth,
                        symbol: symbol,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _MetricCard(
                  title: 'Ahorro acumulado',
                  value: summary.savingsAccumulated,
                  symbol: symbol,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Text('No se pudo cargar el dashboard: $error'),
          ),
          const SizedBox(height: 20),
          Text(
            'Movimientos recientes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          recentMovementsState.when(
            data: (movements) {
              if (movements.isEmpty) {
                return const SectionCard(
                  child: Text(
                    'Todavía no hay movimientos. Empezá cargando el primero.',
                  ),
                );
              }

              return SectionCard(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: movements
                      .map(
                        (movement) => _MovementTile(
                          movement: movement,
                          symbol: symbol,
                        ),
                      )
                      .toList(),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) =>
                Text('No se pudieron cargar movimientos: $error'),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.symbol,
    required this.color,
  });

  final String title;
  final double value;
  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(value, symbol: symbol),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({
    required this.movement,
    required this.symbol,
  });

  final Movement movement;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final sign = movement.type == MovementType.income ? '+' : '-';
    final color = switch (movement.type) {
      MovementType.income => Colors.green.shade700,
      MovementType.expense => Colors.red.shade700,
      MovementType.saving => Theme.of(context).colorScheme.primary,
    };

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      title: Text(movement.categoryName ?? 'Sin categoría'),
      subtitle: Text(
        DateFormat('dd/MM/yyyy').format(movement.occurredOn) +
            (movement.note?.isNotEmpty == true ? ' · ${movement.note}' : ''),
      ),
      trailing: Text(
        '$sign ${CurrencyFormatter.format(movement.amount, symbol: symbol)}',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
      ),
    );
  }
}
