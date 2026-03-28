import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../brand_logo_asset.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/providers.dart';
import '../../domain/entities/movement.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/insight_banner.dart';
import '../widgets/metric_chip.dart';
import '../widgets/section_card.dart';
import '../widgets/simple_charts.dart';
import 'movement_form_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Future<void> _openForm([MovementType type = MovementType.expense]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovementFormScreen(initialType: type),
      ),
    );
    _refresh();
  }

  Future<void> _refresh() async {
    ref.invalidate(financeOverviewProvider);
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(reportsSnapshotProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(movementsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final overviewState = ref.watch(financeOverviewProvider);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final symbol = settings?.currencySymbol ?? r'$';
    final monthLabel =
        DateFormat.yMMMM('es').format(DateTime.now()).replaceFirstMapped(
              RegExp(r'^[a-z]'),
              (match) => match.group(0)!.toUpperCase(),
            );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: overviewState.when(
          data: (overview) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final monthChip = Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        monthLabel,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    );

                    if (constraints.maxWidth < 430) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BrandLogo(
                            size: 44,
                            showWordmark: true,
                            showTagline: false,
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: monthChip,
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        const Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: BrandLogo(
                              size: 44,
                              showWordmark: true,
                              showTagline: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(child: monthChip),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 22),
                SectionCard(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo actual',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                            ),
                      ),
                      const SizedBox(height: 10),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: overview.summary.availableBalance),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return Text(
                            CurrencyFormatter.format(value, symbol: symbol),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.white),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          overview.monthRemaining >= 0
                              ? 'Te quedan ${CurrencyFormatter.format(overview.monthRemaining, symbol: symbol)} este mes.'
                              : 'Este mes vas ${CurrencyFormatter.format(overview.monthRemaining.abs(), symbol: symbol)} por encima de tu margen.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _QuickActionButton(
                              label: 'Gasto',
                              icon: Icons.south_west_rounded,
                              onTap: () => _openForm(MovementType.expense),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _QuickActionButton(
                              label: 'Ingreso',
                              icon: Icons.north_east_rounded,
                              onTap: () => _openForm(MovementType.income),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _QuickActionButton(
                              label: 'Ahorro',
                              icon: Icons.savings_rounded,
                              onTap: () => _openForm(MovementType.saving),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    MetricChip(
                      icon: Icons.arrow_upward_rounded,
                      label: 'Ingresos',
                      value: CurrencyFormatter.format(
                        overview.summary.incomeMonth,
                        symbol: symbol,
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    MetricChip(
                      icon: Icons.arrow_downward_rounded,
                      label: 'Gastos',
                      value: CurrencyFormatter.format(
                        overview.summary.expenseMonth,
                        symbol: symbol,
                      ),
                      color: Theme.of(context).colorScheme.error,
                    ),
                    MetricChip(
                      icon: Icons.auto_graph_rounded,
                      label: 'Movimientos',
                      value: '${overview.summary.currentMonthMovementCount}',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'Insights',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (overview.insights.isEmpty)
                  const EmptyStateView(
                    icon: Icons.insights_outlined,
                    title: 'Todavía no hay insights',
                    message: 'Cargá algunos movimientos para ver alertas y recomendaciones simples.',
                  )
                else
                  ...overview.insights.map(
                    (insight) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InsightBanner(insight: insight),
                    ),
                  ),
                const SizedBox(height: 22),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingresos vs gastos',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Una lectura rápida de cómo viene el mes.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 16),
                      IncomeExpenseComparison(
                        income: overview.summary.incomeMonth,
                        expense: overview.summary.expenseMonth,
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
                        'Compará tus ingresos y gastos de los últimos 6 meses.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 18),
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
                        'Gastos por categoría',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Simple, claro y fácil de leer.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 18),
                      if (overview.reports.topExpenseCategories.isEmpty)
                        EmptyStateView(
                          icon: Icons.pie_chart_outline_rounded,
                          title: 'Todavía no hay gastos suficientes',
                          message: 'Cuando registres gastos, vas a ver tus categorías principales acá.',
                          actionLabel: 'Agregar gasto',
                          onAction: () => _openForm(MovementType.expense),
                        )
                      else
                        DonutChart(items: overview.reports.topExpenseCategories),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Movimientos recientes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (overview.recentMovements.isEmpty)
                  EmptyStateView(
                    icon: Icons.receipt_long_outlined,
                    title: 'Empezá con tu primer movimiento',
                    message: 'Cargar gastos e ingresos te va a permitir ver resumen, alertas y gráficos.',
                    actionLabel: 'Agregar movimiento',
                    onAction: () => _openForm(),
                  )
                else
                  SectionCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: overview.recentMovements
                          .map(
                            (movement) => _MovementTile(
                              movement: movement,
                              symbol: symbol,
                            ),
                          )
                          .toList(),
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
                icon: Icons.wifi_tethering_error_rounded,
                title: 'No pudimos cargar el inicio',
                message: '$error',
                actionLabel: 'Reintentar',
                onAction: _refresh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
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
    final scheme = Theme.of(context).colorScheme;
    final (icon, color, prefix) = switch (movement.type) {
      MovementType.income => (
          Icons.arrow_upward_rounded,
          scheme.primary,
          '+',
        ),
      MovementType.expense => (
          Icons.arrow_downward_rounded,
          scheme.error,
          '-',
        ),
      MovementType.saving => (
          Icons.savings_rounded,
          scheme.secondary,
          '+',
        ),
    };

    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(movement.categoryName ?? 'Sin categoría'),
      subtitle: Text(
        DateFormat('dd MMM', 'es').format(movement.occurredOn) +
            (movement.note?.isNotEmpty == true ? ' · ${movement.note}' : ''),
      ),
      trailing: Text(
        '$prefix ${CurrencyFormatter.format(movement.amount, symbol: symbol)}',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
      ),
    );
  }
}
