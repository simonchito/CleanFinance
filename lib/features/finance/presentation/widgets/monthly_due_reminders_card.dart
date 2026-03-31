import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/utils/amount_visibility_formatter.dart';
import '../../domain/entities/monthly_payment_reminder.dart';
import 'section_card.dart';

class MonthlyDueRemindersCard extends StatelessWidget {
  const MonthlyDueRemindersCard({
    required this.reminders,
    required this.currencySymbol,
    required this.localeCode,
    required this.showAmounts,
    required this.onReminderTap,
    super.key,
  });

  final List<MonthlyPaymentReminder> reminders;
  final String currencySymbol;
  final String localeCode;
  final bool showAmounts;
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
            strings.isEnglish
                ? 'Recurring expenses that still look pending for this month.'
                : 'Gastos mensuales recurrentes que todavía aparecen como pendientes este mes.',
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
                    color: scheme.surfaceContainerHighest.withValues(alpha: 0.42),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: scheme.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.notifications_active_outlined,
                          color: scheme.error,
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
                              '${strings.reminderDayPrefix} ${reminder.reminderDay} · ${strings.reminderLastRegistered}: ${DateFormat('d MMM', strings.languageCode).format(reminder.lastRecordedOn)}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                            ),
                            if (reminder.categoryName != null &&
                                reminder.categoryName!.trim().isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                reminder.categoryName!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AmountVisibilityFormatter.formatCurrency(
                              amount: reminder.amount,
                              symbol: currencySymbol,
                              isVisible: showAmounts,
                              localeCode: localeCode,
                            ),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            strings.reminderRegisterPayment,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: scheme.primary,
                                ),
                          ),
                        ],
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
