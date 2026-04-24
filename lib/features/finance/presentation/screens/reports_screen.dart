import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/payment_method_utils.dart';
import '../../domain/entities/analytics_models.dart';
import '../mappers/finance_text_mapper.dart';
import '../providers/finance_providers.dart';
import '../utils/payment_method_icon_resolver.dart';
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
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final symbol = settings?.currencySymbol ?? r'$';
    final localeCode = ref.watch(appLocaleCodeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.reports)),
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
                      strings.isEnglish
                          ? 'Financial health'
                          : 'Salud financiera',
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
                          color:
                              _healthColor(context, overview.healthScore.level),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      healthCopy.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
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
                      strings.isEnglish
                          ? 'Monthly cashflow'
                          : 'Cashflow mensual',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.isEnglish
                          ? 'A quick summary of what came in, what went out, and the margin left.'
                          : 'Un resumen rápido para entender cuánto entró, cuánto salió y qué margen te quedó.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricBox(
                            label: strings.income,
                            value: CurrencyFormatter.format(
                              overview.cashflow.income,
                              symbol: symbol,
                              localeCode: localeCode,
                            ),
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricBox(
                            label: strings.expense,
                            value: CurrencyFormatter.format(
                              overview.cashflow.expense,
                              symbol: symbol,
                              localeCode: localeCode,
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
                            label: strings.saving,
                            value: CurrencyFormatter.format(
                              overview.cashflow.savings,
                              symbol: symbol,
                              localeCode: localeCode,
                            ),
                            color: scheme.tertiary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricBox(
                            label:
                                strings.isEnglish ? 'Net balance' : 'Saldo neto',
                            value: CurrencyFormatter.format(
                              overview.cashflow.netBalance,
                              symbol: symbol,
                              localeCode: localeCode,
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
                      currencySymbol: symbol,
                      localeCode: localeCode,
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
                      strings.isEnglish
                          ? 'Monthly trend'
                          : 'Evolución mensual',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.isEnglish
                          ? 'Compare how your income and expenses evolved in recent months.'
                          : 'Compará cómo vienen tus ingresos y gastos en los últimos meses.',
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
                      strings.isEnglish
                          ? 'Top categories this month'
                          : 'Top categorías del mes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.isEnglish
                          ? 'See where most money went and how it changed versus last month.'
                          : 'Vas a ver en qué se fue más dinero y cómo cambió frente al mes anterior.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (overview.categoryComparison.items.isEmpty)
                      EmptyStateView(
                        icon: Icons.pie_chart_outline_rounded,
                        title: strings.isEnglish
                            ? 'No data yet'
                            : 'Sin datos todavía',
                        message: strings.isEnglish
                            ? 'Once you register expenses, you will see where most spending goes.'
                            : 'Cuando registres gastos, vas a ver acá en qué categorías se fue más dinero.',
                      )
                    else ...[
                      DonutChart(
                        items: overview.reports.topExpenseCategories,
                        localeCode: localeCode,
                      ),
                      const SizedBox(height: 18),
                      ...overview.categoryComparison.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CategoryComparisonTile(
                            item: item,
                            symbol: symbol,
                            localeCode: localeCode,
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
                      strings.isEnglish ? 'Spending pace' : 'Ritmo de gasto',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.isEnglish
                          ? 'Shows whether your cumulative spending is inside the expected range for this point in the month.'
                          : 'Te muestra si el gasto acumulado va dentro del margen esperable para este momento del mes.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricBox(
                            label: strings.spent,
                            value: CurrencyFormatter.format(
                              overview.spendingPace.spentSoFar,
                              symbol: symbol,
                              localeCode: localeCode,
                            ),
                            color: scheme.error,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricBox(
                            label: strings.isEnglish
                                ? 'Expected today'
                                : 'Esperado hoy',
                            value: CurrencyFormatter.format(
                              overview.spendingPace.expectedSpendToDate,
                              symbol: symbol,
                              localeCode: localeCode,
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
                            label:
                                strings.isEnglish ? 'Projection' : 'Proyección',
                            value: CurrencyFormatter.format(
                              overview.spendingPace.projectedEndOfMonth,
                              symbol: symbol,
                              localeCode: localeCode,
                            ),
                            color: scheme.tertiary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricBox(
                            label: strings.isEnglish ? 'Status' : 'Estado',
                            value: _paceLabel(strings, overview.spendingPace.status),
                            color: _paceColor(
                                context, overview.spendingPace.status),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: overview.spendingPace.progressRatio
                            .clamp(0.02, 1.4),
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
                          ? (strings.isEnglish
                              ? 'Your current pace is demanding for the available margin.'
                              : 'El ritmo actual es exigente para tu margen disponible.')
                          : overview.spendingPace.status ==
                                  SpendingPaceStatus.watch
                              ? (strings.isEnglish
                                  ? 'You are close to the limit. It is worth watching the second half of the month carefully.'
                                  : 'Vas cerca del límite. Conviene mirar con atención la segunda mitad del mes.')
                              : (strings.isEnglish
                                  ? 'Your spending is currently in a healthy zone for this time of month.'
                                  : 'Tu gasto viene en una zona saludable para este momento del mes.'),
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
                      strings.isEnglish ? 'Savings goals' : 'Metas de ahorro',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.isEnglish
                          ? 'Simple tracking of progress, contribution pace and estimated completion date.'
                          : 'Seguimiento simple del avance, ritmo de aporte y fecha estimada de cumplimiento.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (overview.savingsGoals.isEmpty)
                      EmptyStateView(
                        icon: Icons.savings_outlined,
                        title: strings.isEnglish
                            ? 'No goals to analyze yet'
                            : 'Todavía no hay metas para analizar',
                        message: strings.isEnglish
                            ? 'Once you have goals and contributions, progress pace will show here.'
                            : 'Cuando tengas metas y aportes, vas a ver acá el ritmo de avance.',
                      )
                    else
                      ...overview.savingsGoals.map(
                        (goal) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _GoalForecastTile(
                            goal: goal,
                            symbol: symbol,
                            localeCode: localeCode,
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
                        strings.isEnglish
                            ? 'Expenses by payment method'
                            : 'Gastos por medio de pago',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        strings.isEnglish
                            ? 'Helps you see which payment method you use the most this month.'
                            : 'Te ayuda a ver qué método estás usando más en el mes.',
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
                            localeCode: localeCode,
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
                  strings.isEnglish ? 'Quick read' : 'Lectura rápida',
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
              title: strings.isEnglish
                  ? 'Could not load reports'
                  : 'No se pudieron cargar los reportes',
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

  String _paceLabel(AppStrings strings, SpendingPaceStatus status) {
    return switch (status) {
      SpendingPaceStatus.onTrack =>
        strings.isEnglish ? 'On track' : 'En rango',
      SpendingPaceStatus.watch =>
        strings.isEnglish ? 'Watch' : 'Atención',
      SpendingPaceStatus.risk =>
        strings.isEnglish ? 'Risk' : 'Riesgo',
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
    required this.localeCode,
  });

  final CategoryComparisonItem item;
  final String symbol;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final deltaColor = item.deltaAmount >= 0 ? scheme.error : scheme.primary;
    final deltaLabel = item.deltaPercentage == null
        ? (strings.isEnglish ? 'New' : 'Nuevo')
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
                  CurrencyFormatter.format(
                    item.currentAmount,
                    symbol: symbol,
                    localeCode: localeCode,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Text(
                strings.isEnglish
                    ? '${(item.shareOfCurrent * 100).round()}% of total'
                    : '${(item.shareOfCurrent * 100).round()}% del total',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          if (item.previousAmount > 0) ...[
            const SizedBox(height: 4),
            Text(
              strings.isEnglish
                  ? 'Previous month: ${CurrencyFormatter.format(item.previousAmount, symbol: symbol, localeCode: localeCode)}'
                  : 'Mes anterior: ${CurrencyFormatter.format(item.previousAmount, symbol: symbol, localeCode: localeCode)}',
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
    required this.localeCode,
  });

  final SavingsGoalForecast goal;
  final String symbol;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final estimatedDate = goal.estimatedCompletionDate == null
        ? (strings.isEnglish
            ? 'No estimate yet'
            : 'Sin estimación todavía')
        : DateFormat('MMM yyyy', strings.languageCode)
            .format(goal.estimatedCompletionDate!);

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
            strings.isEnglish
                ? '${CurrencyFormatter.format(goal.progress.savedAmount, symbol: symbol, localeCode: localeCode)} of ${CurrencyFormatter.format(goal.progress.goal.targetAmount, symbol: symbol, localeCode: localeCode)}'
                : '${CurrencyFormatter.format(goal.progress.savedAmount, symbol: symbol, localeCode: localeCode)} de ${CurrencyFormatter.format(goal.progress.goal.targetAmount, symbol: symbol, localeCode: localeCode)}',
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
            strings.isEnglish
                ? 'Average contribution: ${CurrencyFormatter.format(goal.averageMonthlyContribution, symbol: symbol, localeCode: localeCode)} per month'
                : 'Aporte promedio: ${CurrencyFormatter.format(goal.averageMonthlyContribution, symbol: symbol, localeCode: localeCode)} por mes',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            strings.isEnglish
                ? 'Contribution this month: ${CurrencyFormatter.format(goal.currentMonthContribution, symbol: symbol, localeCode: localeCode)}'
                : 'Aporte este mes: ${CurrencyFormatter.format(goal.currentMonthContribution, symbol: symbol, localeCode: localeCode)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            strings.isEnglish
                ? 'Estimated date: $estimatedDate'
                : 'Fecha estimada: $estimatedDate',
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
    required this.localeCode,
  });

  final PaymentMethodSpend item;
  final String symbol;
  final String localeCode;

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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              PaymentMethodIconResolver.resolve(item.name),
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              PaymentMethodUtils.canonicalizeLabel(item.name),
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
            CurrencyFormatter.format(
              item.amount,
              symbol: symbol,
              localeCode: localeCode,
            ),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
