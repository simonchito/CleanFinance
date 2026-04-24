import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_strings.dart';
import '../../../../brand_logo_asset.dart';
import '../../../../core/utils/amount_visibility_formatter.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/monthly_payment_reminder.dart';
import '../../domain/entities/movement.dart';
import '../providers/finance_providers.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/end_of_month_projection_card.dart';
import '../widgets/insight_banner.dart';
import '../widgets/metric_chip.dart';
import '../widgets/monthly_due_reminders_card.dart';
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
    ref.invalidate(savingMovementsProvider);
    ref.invalidate(unassignedSavingsProvider);
    ref.invalidate(savingsSummaryProvider);
    ref.invalidate(movementsProvider);
    ref.invalidate(monthlyDueRemindersProvider);
  }

  Future<void> _openReminderPayment(MonthlyPaymentReminder reminder) async {
    final now = DateTime.now();
    final initialMovement = switch (reminder.source) {
      MonthlyReminderSource.expenseSubcategory => Movement(
          id: '',
          type: MovementType.expense,
          amount: 0,
          categoryId: reminder.categoryId ?? '',
          subcategoryId: reminder.subcategoryId,
          occurredOn: now,
          createdAt: now,
          updatedAt: now,
        ),
      MonthlyReminderSource.savingsGoal => Movement(
          id: '',
          type: MovementType.saving,
          amount: 0,
          categoryId: '',
          goalId: reminder.goalId,
          occurredOn: now,
          createdAt: now,
          updatedAt: now,
        ),
    };
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovementFormScreen(
          initialMovement: initialMovement,
        ),
      ),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final overviewState = ref.watch(financeOverviewProvider);
    final dueRemindersState = ref.watch(monthlyDueRemindersProvider);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final showSensitiveAmounts = ref.watch(showSensitiveAmountsProvider);
    final strings = AppStrings.of(context);
    final symbol = settings?.currencySymbol ?? r'$';
    final localeCode = settings?.localeCode ?? 'es';
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Saldo actual',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.82),
                                  ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(showSensitiveAmountsOverrideProvider
                                      .notifier)
                                  .state = !showSensitiveAmounts;
                            },
                            tooltip: showSensitiveAmounts
                                ? strings.hideAmounts
                                : strings.showAmounts,
                            icon: Icon(
                              showSensitiveAmounts
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TweenAnimationBuilder<double>(
                        tween: Tween(
                            begin: 0, end: overview.summary.availableBalance),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return Text(
                            AmountVisibilityFormatter.formatCurrency(
                              amount: value,
                              symbol: symbol,
                              isVisible: showSensitiveAmounts,
                              localeCode: localeCode,
                            ),
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
                              ? 'Te quedan ${AmountVisibilityFormatter.formatCurrency(amount: overview.monthRemaining, symbol: symbol, isVisible: showSensitiveAmounts, localeCode: localeCode)} este mes.'
                              : 'Este mes vas ${AmountVisibilityFormatter.formatCurrency(amount: overview.monthRemaining.abs(), symbol: symbol, isVisible: showSensitiveAmounts, localeCode: localeCode)} por encima de tu margen.',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: MetricChip(
                            icon: Icons.arrow_upward_rounded,
                            label: 'Ingresos',
                            value: AmountVisibilityFormatter.formatCurrency(
                              amount: overview.summary.incomeMonth,
                              symbol: symbol,
                              isVisible: showSensitiveAmounts,
                              localeCode: localeCode,
                            ),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MetricChip(
                            icon: Icons.arrow_downward_rounded,
                            label: 'Gastos',
                            value: AmountVisibilityFormatter.formatCurrency(
                              amount: overview.summary.expenseMonth,
                              symbol: symbol,
                              isVisible: showSensitiveAmounts,
                              localeCode: localeCode,
                            ),
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: MetricChip(
                            icon: Icons.auto_graph_rounded,
                            label: 'Movimientos',
                            value:
                                '${overview.summary.currentMonthMovementCount}',
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MetricChip(
                            icon: Icons.savings_rounded,
                            label: 'Ahorro total',
                            value: AmountVisibilityFormatter.formatCurrency(
                              amount: overview.summary.savingsAccumulated,
                              symbol: symbol,
                              isVisible: showSensitiveAmounts,
                              localeCode: localeCode,
                            ),
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                EndOfMonthProjectionCard(
                  projection: overview.endOfMonthProjection,
                  currencySymbol: symbol,
                  showAmounts: showSensitiveAmounts,
                  localeCode: localeCode,
                ),
                dueRemindersState.when(
                  data: (reminders) => reminders.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: MonthlyDueRemindersCard(
                            reminders: reminders,
                            onReminderTap: _openReminderPayment,
                          ),
                        ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 22),
                Text(
                  strings.isEnglish ? 'Insights' : 'Recomendaciones',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (overview.insights.isEmpty)
                  EmptyStateView(
                    icon: Icons.insights_outlined,
                    title: strings.isEnglish
                        ? 'There are no insights yet'
                        : 'Todavía no hay recomendaciones',
                    message: strings.isEnglish
                        ? 'Add a few movements to see simple alerts and suggestions.'
                        : 'Cargá algunos movimientos para ver alertas y recomendaciones simples.',
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 16),
                      IncomeExpenseComparison(
                        income: overview.summary.incomeMonth,
                        expense: overview.summary.expenseMonth,
                        showAmounts: showSensitiveAmounts,
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
                        'Evolución mensual',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Compará tus ingresos y gastos de los últimos 6 meses.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 18),
                      if (overview.reports.topExpenseCategories.isEmpty)
                        EmptyStateView(
                          icon: Icons.pie_chart_outline_rounded,
                          title: 'Todavía no hay gastos suficientes',
                          message:
                              'Cuando registres gastos, vas a ver tus categorías principales acá.',
                          actionLabel: 'Agregar gasto',
                          onAction: () => _openForm(MovementType.expense),
                        )
                      else
                        DonutChart(
                          items: overview.reports.topExpenseCategories,
                          localeCode: localeCode,
                        ),
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
                    message:
                        'Cargar gastos e ingresos te va a permitir ver resumen, alertas y gráficos.',
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
                              localeCode: localeCode,
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
    final shadowColor = Colors.black.withValues(alpha: 0.14);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        height: 96,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.28),
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.08),
              blurRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 17),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
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
    required this.localeCode,
  });

  final Movement movement;
  final String symbol;
  final String localeCode;

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
        '$prefix ${CurrencyFormatter.format(movement.amount, symbol: symbol, localeCode: localeCode)}',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
      ),
    );
  }
}
