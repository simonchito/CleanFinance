import 'package:flutter/material.dart';

import '../../../../app/app_strings.dart';
import '../../domain/entities/monthly_payment_reminder.dart';
import 'section_card.dart';

class MonthlyDueRemindersCard extends StatelessWidget {
  const MonthlyDueRemindersCard({
    required this.reminders,
    required this.onReminderTap,
    super.key,
  });

  final List<MonthlyPaymentReminder> reminders;
  final ValueChanged<MonthlyPaymentReminder> onReminderTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.pendingThisMonth,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            strings.t('todaviaTeQuedaPagarOAhorrarPara'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 14),
          ...reminders.map(
            (reminder) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => onReminderTap(reminder),
                borderRadius: BorderRadius.circular(18),
                child: Ink(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:
                        scheme.surfaceContainerHighest.withValues(alpha: 0.42),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: reminder.source ==
                                  MonthlyReminderSource.savingsGoal
                              ? scheme.tertiary.withValues(alpha: 0.14)
                              : scheme.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          reminder.source == MonthlyReminderSource.savingsGoal
                              ? Icons.savings_outlined
                              : Icons.receipt_long_outlined,
                          color: reminder.source ==
                                  MonthlyReminderSource.savingsGoal
                              ? scheme.tertiary
                              : scheme.error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reminder.title,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              reminder.source ==
                                      MonthlyReminderSource.savingsGoal
                                  ? '${strings.savingGoal} · ${strings.reminderDayPrefix} ${reminder.reminderDay}'
                                  : '${reminder.subtitle ?? strings.expense} · ${strings.reminderDayPrefix} ${reminder.reminderDay}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        strings.add,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: scheme.primary,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
