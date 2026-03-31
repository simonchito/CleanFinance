import 'package:flutter/material.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../features/finance/presentation/widgets/section_card.dart';
import '../../domain/models/category_budget_status.dart';

class BudgetStatusCard extends StatelessWidget {
  const BudgetStatusCard({
    required this.item,
    required this.currencySymbol,
    required this.localeCode,
    this.onTap,
    super.key,
  });

  final CategoryBudgetStatus item;
  final String currencySymbol;
  final String localeCode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final statusStyle = _styleFor(context, item.status);
    final progressValue = (item.percentageUsed / 100).clamp(0.0, 1.0);

    return SectionCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.categoryName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${strings.monthlyLimit}: ${CurrencyFormatter.format(item.monthlyLimit, symbol: currencySymbol, localeCode: localeCode)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusStyle.background,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusStyle.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: statusStyle.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progressValue,
              backgroundColor: scheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(statusStyle.foreground),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${item.percentageUsed.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: statusStyle.foreground,
                      ),
                ),
              ),
              TextButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.edit_outlined),
                label: Text(strings.editBudget),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _BudgetMetric(
                  label: strings.spent,
                  value: CurrencyFormatter.format(
                    item.spent,
                    symbol: currencySymbol,
                    localeCode: localeCode,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _BudgetMetric(
                  label: strings.remaining,
                  value: CurrencyFormatter.format(
                    item.remaining,
                    symbol: currencySymbol,
                    localeCode: localeCode,
                  ),
                  valueColor: item.remaining < 0 ? scheme.error : scheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _BudgetVisualStyle _styleFor(BuildContext context, BudgetStatus status) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;

    switch (status) {
      case BudgetStatus.warning:
        return _BudgetVisualStyle(
          label: strings.isEnglish ? 'Warning' : 'Atención',
          foreground: Colors.orange.shade800,
          background: Colors.orange.shade100,
        );
      case BudgetStatus.exceeded:
        return _BudgetVisualStyle(
          label: strings.isEnglish ? 'Exceeded' : 'Excedido',
          foreground: scheme.error,
          background: scheme.errorContainer,
        );
      case BudgetStatus.normal:
        return _BudgetVisualStyle(
          label: strings.isEnglish ? 'Normal' : 'Normal',
          foreground: scheme.primary,
          background: scheme.primaryContainer,
        );
    }
  }
}

class _BudgetMetric extends StatelessWidget {
  const _BudgetMetric({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: valueColor,
                ),
          ),
        ],
      ),
    );
  }
}

class _BudgetVisualStyle {
  const _BudgetVisualStyle({
    required this.label,
    required this.foreground,
    required this.background,
  });

  final String label;
  final Color foreground;
  final Color background;
}
