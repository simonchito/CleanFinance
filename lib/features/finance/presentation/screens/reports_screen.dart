import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/providers.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/insight_banner.dart';
import '../widgets/section_card.dart';
import '../widgets/simple_charts.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(financeOverviewProvider);
    final symbol =
        ref.watch(settingsControllerProvider).valueOrNull?.currencySymbol ?? r'$';

    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
      body: overviewState.when(
        data: (overview) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
            children: [
              SectionCard(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.88),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resultado del mes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      CurrencyFormatter.format(overview.reports.netMonth, symbol: symbol),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      overview.reports.netMonth >= overview.reports.previousNetMonth
                          ? 'Vas mejor que el mes anterior.'
                          : 'Este mes viene más ajustado que el anterior.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingresos y gastos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    IncomeExpenseComparison(
                      income: overview.reports.incomeMonth,
                      expense: overview.reports.expenseMonth,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evolución mensual',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    MonthlyTrendChart(points: overview.monthlyTrend),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distribución de gastos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    if (overview.reports.topExpenseCategories.isEmpty)
                      const EmptyStateView(
                        icon: Icons.pie_chart_outline_rounded,
                        title: 'Sin datos todavía',
                        message: 'Cuando registres gastos, vas a ver acá en qué categorías se fue más dinero.',
                      )
                    else
                      DonutChart(items: overview.reports.topExpenseCategories),
                  ],
                ),
              ),
              if (overview.insights.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Lectura rápida',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...overview.insights.map(
                  (insight) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InsightBanner(insight: insight),
                  ),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            EmptyStateView(
              icon: Icons.show_chart_rounded,
              title: 'No se pudieron cargar los reportes',
              message: '$error',
            ),
          ],
        ),
      ),
    );
  }
}
