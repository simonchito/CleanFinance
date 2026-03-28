import 'package:flutter/material.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/end_of_month_projection.dart';
import 'section_card.dart';

class EndOfMonthProjectionCard extends StatelessWidget {
  const EndOfMonthProjectionCard({
    required this.projection,
    required this.currencySymbol,
    super.key,
  });

  final EndOfMonthProjection projection;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final accent = _riskColor(context, projection.riskLevel);
    final label = _riskLabel(strings, projection.riskLevel);

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
              _RiskPill(label: label, color: accent),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            projection.interpretation,
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
                  value: CurrencyFormatter.format(
                    projection.projectedExpense,
                    symbol: currencySymbol,
                  ),
                  color: scheme.error,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProjectionMetric(
                  label: strings.isEnglish ? 'Projected net' : 'Neto estimado',
                  value: CurrencyFormatter.format(
                    projection.projectedNet,
                    symbol: currencySymbol,
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
                ? 'Average expense pace: ${CurrencyFormatter.format(projection.avgDailyExpense, symbol: currencySymbol)}/day. ${projection.daysRemaining} days left.'
                : 'Ritmo promedio: ${CurrencyFormatter.format(projection.avgDailyExpense, symbol: currencySymbol)}/dia. Quedan ${projection.daysRemaining} dias.',
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

  String _riskLabel(AppStrings strings, ProjectionRiskLevel riskLevel) {
    return switch (riskLevel) {
      ProjectionRiskLevel.low => strings.isEnglish ? 'Low' : 'Bajo',
      ProjectionRiskLevel.medium => strings.isEnglish ? 'Medium' : 'Medio',
      ProjectionRiskLevel.high => strings.isEnglish ? 'High' : 'Alto',
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
