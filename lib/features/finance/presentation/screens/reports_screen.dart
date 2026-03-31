import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/analytics_models.dart';
import '../mappers/finance_text_mapper.dart';
import '../providers/finance_providers.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/insight_banner.dart';
import '../widgets/section_card.dart';
import '../widgets/simple_charts.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(financeOverviewProvider);
    final strings = AppStrings.of(context);
    final symbol =
        ref.watch(settingsControllerProvider).valueOrNull?.currencySymbol ?? r'$';

    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
      body: overviewState.when(
        data: (overview) {
          final healthCopy = FinanceTextMapper.healthScore(
            strings,
            overview.healthScore,
          );
          final scheme = Theme.of(context).colorScheme;
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
                      'Salud financiera',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${overview.healthScore.score}/100',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        _StatusPill(
                          label: healthCopy.label,
                          color: _healthColor(context, overview.healthScore.level),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      healthCopy.message,
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
                      'Cashflow mensual',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Un resumen rápido para entender cuánto entró, cuánto salió y qué margen te quedó.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricBox(
                            label: 'Ingresos',
                            value: CurrencyFormatter.format(
                              overview.cashflow.income,
                              symbol: symbol,
                            ),
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricBox(
                            label: 'Gastos',
                            value: CurrencyFormatter.format(
                              overview.cashflow.expense,
                              symbol: symbol,
                            ),
                            color: scheme.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricBox(
                            label: 'Ahorro',
                            value: CurrencyFormatter.format(
                              overview.cashflow.savings,
                              symbol: symbol,
                            ),
                            color: scheme.tertiary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricBox(
                            label: 'Saldo neto',
                            value: CurrencyFormatter.format(
                              overview.cashflow.netBalance,
                              symbol: symbol,
                            ),
                            color: overview.cashflow.netBalance >= 0
                                ? scheme.primary
                                : scheme.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    IncomeExpenseComparison(
                      income: overview.cashflow.income,
                      expense: overview.cashflow.expense,
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
                    const SizedBox(height: 6),
                    Text(
                      'Compará cómo vienen tus ingresos y gastos en los últimos meses.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
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
                      'Top categorías del mes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Vas a ver en qué se fue más dinero y cómo cambió frente al mes anterior.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (overview.categoryComparison.items.isEmpty)
                      const EmptyStateView(
                        icon: Icons.pie_chart_outline_rounded,
                        title: 'Sin datos todavía',
                        message: 'Cuando registres gastos, vas a ver acá en qué categorías se fue más dinero.',
                      )
                    else ...[
                      DonutChart(items: overview.reports.topExpenseCategories),
                      const SizedBox(height: 18),
                      ...overview.categoryComparison.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CategoryComparisonTile(
                            item: item,
                            symbol: symbol,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ritmo de gasto',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Te muestra si el gasto acumulado va dentro del margen esperable para este momento del mes.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricBox(
                            label: 'Gastado',
                            value: CurrencyFormatter.format(
                              overview.spendingPace.spentSoFar,
                              symbol: symbol,
                            ),
                            color: scheme.error,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricBox(
                            label: 'Esperado hoy',
                            value: CurrencyFormatter.format(
                              overview.spendingPace.expectedSpendToDate,
                              symbol: symbol,
                            ),
                            color: scheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricBox(
                            label: 'Proyección',
                            value: CurrencyFormatter.format(
                              overview.spendingPace.projectedEndOfMonth,
                              symbol: symbol,
                            ),
                            color: scheme.tertiary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricBox(
                            label: 'Estado',
                            value: _paceLabel(overview.spendingPace.status),
                            color: _paceColor(context, overview.spendingPace.status),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: overview.spendingPace.progressRatio.clamp(0.02, 1.4),
                        minHeight: 12,
                        backgroundColor: _paceColor(
                          context,
                          overview.spendingPace.status,
                        ).withValues(alpha: 0.14),
                        valueColor: AlwaysStoppedAnimation(
                          _paceColor(context, overview.spendingPace.status),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      overview.spendingPace.status == SpendingPaceStatus.risk
                          ? 'El ritmo actual es exigente para tu margen disponible.'
                          : overview.spendingPace.status == SpendingPaceStatus.watch
                              ? 'Vas cerca del límite. Conviene mirar con atención la segunda mitad del mes.'
                              : 'Tu gasto viene en una zona saludable para este momento del mes.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
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
                      'Metas de ahorro',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Seguimiento simple del avance, ritmo de aporte y fecha estimada de cumplimiento.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (overview.savingsGoals.isEmpty)
                      const EmptyStateView(
                        icon: Icons.savings_outlined,
                        title: 'Todavía no hay metas para analizar',
                        message: 'Cuando tengas metas y aportes, vas a ver acá el ritmo de avance.',
                      )
                    else
                      ...overview.savingsGoals.map(
                        (goal) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _GoalForecastTile(
                            goal: goal,
                            symbol: symbol,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (overview.paymentMethodReport.items.isNotEmpty) ...[
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gastos por medio de pago',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Te ayuda a ver qué método estás usando más en el mes.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 16),
                      ...overview.paymentMethodReport.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _PaymentMethodTile(
                            item: item,
                            symbol: symbol,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

  Color _paceColor(BuildContext context, SpendingPaceStatus status) {
    final scheme = Theme.of(context).colorScheme;
    return switch (status) {
      SpendingPaceStatus.onTrack => scheme.primary,
      SpendingPaceStatus.watch => scheme.secondary,
      SpendingPaceStatus.risk => scheme.error,
    };
  }

  String _paceLabel(SpendingPaceStatus status) {
    return switch (status) {
      SpendingPaceStatus.onTrack => 'En rango',
      SpendingPaceStatus.watch => 'Atención',
      SpendingPaceStatus.risk => 'Riesgo',
    };
  }

  Color _healthColor(BuildContext context, FinancialHealthLevel level) {
    final scheme = Theme.of(context).colorScheme;
    return switch (level) {
      FinancialHealthLevel.strong => scheme.primary,
      FinancialHealthLevel.stable => scheme.tertiary,
      FinancialHealthLevel.attention => scheme.secondary,
      FinancialHealthLevel.risk => scheme.error,
    };
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
            ),
      ),
    );
  }
}

class _CategoryComparisonTile extends StatelessWidget {
  const _CategoryComparisonTile({
    required this.item,
    required this.symbol,
  });

  final CategoryComparisonItem item;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final deltaColor = item.deltaAmount >= 0 ? scheme.error : scheme.primary;
    final deltaLabel = item.deltaPercentage == null
        ? 'Nuevo'
        : '${item.deltaAmount >= 0 ? '+' : ''}${(item.deltaPercentage! * 100).round()}%';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.44),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.categoryName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 10),
              _StatusPill(label: deltaLabel, color: deltaColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  CurrencyFormatter.format(item.currentAmount, symbol: symbol),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Text(
                '${(item.shareOfCurrent * 100).round()}% del total',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          if (item.previousAmount > 0) ...[
            const SizedBox(height: 4),
            Text(
              'Mes anterior: ${CurrencyFormatter.format(item.previousAmount, symbol: symbol)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GoalForecastTile extends StatelessWidget {
  const _GoalForecastTile({
    required this.goal,
    required this.symbol,
  });

  final SavingsGoalForecast goal;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final estimatedDate = goal.estimatedCompletionDate == null
        ? 'Sin estimación todavía'
        : DateFormat('MMM yyyy', 'es').format(goal.estimatedCompletionDate!);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal.progress.goal.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${CurrencyFormatter.format(goal.progress.savedAmount, symbol: symbol)} de ${CurrencyFormatter.format(goal.progress.goal.targetAmount, symbol: symbol)}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: goal.progress.progress,
              minHeight: 12,
              backgroundColor: scheme.primary.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(scheme.primary),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Aporte promedio: ${CurrencyFormatter.format(goal.averageMonthlyContribution, symbol: symbol)} por mes',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Aporte este mes: ${CurrencyFormatter.format(goal.currentMonthContribution, symbol: symbol)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fecha estimada: $estimatedDate',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.item,
    required this.symbol,
  });

  final PaymentMethodSpend item;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${(item.share * 100).round()}%',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.secondary,
                ),
          ),
          const SizedBox(width: 12),
          Text(
            CurrencyFormatter.format(item.amount, symbol: symbol),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
