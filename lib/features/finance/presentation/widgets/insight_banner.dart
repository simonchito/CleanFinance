import 'package:flutter/material.dart';

import '../../../../app/app_strings.dart';
import '../../domain/entities/finance_insight.dart';
import '../mappers/finance_text_mapper.dart';

class InsightBanner extends StatelessWidget {
  const InsightBanner({
    required this.insight,
    super.key,
  });

  final FinanceInsight insight;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final localized = FinanceTextMapper.insight(strings, insight);
    final scheme = Theme.of(context).colorScheme;
    final (icon, color) = switch (insight.tone) {
      FinanceInsightTone.positive => (Icons.trending_up_rounded, scheme.primary),
      FinanceInsightTone.warning => (Icons.warning_amber_rounded, scheme.error),
      FinanceInsightTone.neutral => (Icons.auto_awesome_rounded, scheme.secondary),
    };

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        localized.title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        localized.kindLabel,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: color,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  localized.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
