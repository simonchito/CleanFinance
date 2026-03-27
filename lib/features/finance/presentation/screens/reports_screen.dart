import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/providers.dart';
import '../widgets/section_card.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsState = ref.watch(reportsSnapshotProvider);
    final symbol =
        ref.watch(settingsControllerProvider).valueOrNull?.currencySymbol ?? r'$';

    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          reportsState.when(
            data: (snapshot) {
              final change = snapshot.netMonth - snapshot.previousNetMonth;
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SectionCard(
                          child: _ReportMetric(
                            label: 'Ingresos',
                            value: snapshot.incomeMonth,
                            symbol: symbol,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SectionCard(
                          child: _ReportMetric(
                            label: 'Gastos',
                            value: snapshot.expenseMonth,
                            symbol: symbol,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen mensual',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Resultado del mes: ${CurrencyFormatter.format(snapshot.netMonth, symbol: symbol)}',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Variación contra el mes anterior: ${CurrencyFormatter.format(change, symbol: symbol)}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gasto por categoría',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        if (snapshot.topExpenseCategories.isEmpty)
                          const Text('Todavía no hay gastos para mostrar.')
                        else
                          ...snapshot.topExpenseCategories.map((item) {
                            final max =
                                snapshot.topExpenseCategories.first.amount;
                            final progress = max == 0 ? 0 : item.amount / max;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text(item.categoryName)),
                                      Text(
                                        CurrencyFormatter.format(
                                          item.amount,
                                          symbol: symbol,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 8,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) =>
                Text('No se pudieron cargar reportes: $error'),
          ),
        ],
      ),
    );
  }
}

class _ReportMetric extends StatelessWidget {
  const _ReportMetric({
    required this.label,
    required this.value,
    required this.symbol,
  });

  final String label;
  final double value;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Text(
          CurrencyFormatter.format(value, symbol: symbol),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
