import 'package:flutter/material.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/utils/amount_visibility_formatter.dart';
import '../../domain/entities/end_of_month_projection.dart';
import '../mappers/finance_text_mapper.dart';
import 'section_card.dart';

class EndOfMonthProjectionCard extends StatelessWidget {
  const EndOfMonthProjectionCard({
    required this.projection,
    required this.currencySymbol,
    required this.showAmounts,
    super.key,
  });

  final EndOfMonthProjection projection;
  final String currencySymbol;
  final bool showAmounts;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final localized = FinanceTextMapper.projection(strings, projection);
    final scheme = Theme.of(context).colorScheme;
    final accent = _riskColor(context, projection.riskLevel);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.isEnglish
                      ? 'End-of-month projection'
                      : 'Proyeccion de fin de mes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 10),
              _RiskPill(label: localized.riskLabel, color: accent),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            localized.interpretation,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ProjectionMetric(
                  label: strings.isEnglish
                      ? 'Projected expense'
                      : 'Gasto proyectado',
                  value: AmountVisibilityFormatter.formatCurrency(
                    amount: projection.projectedExpense,
                    symbol: currencySymbol,
                    isVisible: showAmounts,
                  ),
                  color: scheme.error,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProjectionMetric(
                  label: strings.isEnglish ? 'Projected net' : 'Neto estimado',
                  value: AmountVisibilityFormatter.formatCurrency(
                    amount: projection.projectedNet,
                    symbol: currencySymbol,
                    isVisible: showAmounts,
                  ),
                  color:
                      projection.projectedNet >= 0 ? scheme.primary : scheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            strings.isEnglish
                ? 'Average expense pace: ${AmountVisibilityFormatter.formatCurrency(amount: projection.avgDailyExpense, symbol: currencySymbol, isVisible: showAmounts)}/day. ${projection.daysRemaining} days left.'
                : 'Ritmo promedio: ${AmountVisibilityFormatter.formatCurrency(amount: projection.avgDailyExpense, symbol: currencySymbol, isVisible: showAmounts)}/dia. Quedan ${projection.daysRemaining} dias.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Color _riskColor(BuildContext context, ProjectionRiskLevel riskLevel) {
    final scheme = Theme.of(context).colorScheme;
    return switch (riskLevel) {
      ProjectionRiskLevel.low => scheme.primary,
      ProjectionRiskLevel.medium => scheme.secondary,
      ProjectionRiskLevel.high => scheme.error,
    };
  }
}

class _ProjectionMetric extends StatelessWidget {
  const _ProjectionMetric({
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
        color: color.withValues(alpha: 0.10),
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

class _RiskPill extends StatelessWidget {
  const _RiskPill({
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
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
