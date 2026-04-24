import 'monthly_payment_reminder.dart';

class MonthlyReminderScheduleItem {
  const MonthlyReminderScheduleItem({
    required this.id,
    required this.source,
    required this.title,
    required this.reminderDay,
    this.subtitle,
  });

  final String id;
  final MonthlyReminderSource source;
  final String title;
  final String? subtitle;
  final int reminderDay;
}
