enum MonthlyReminderSource { expenseSubcategory, savingsGoal }

enum MonthlyReminderStatus { due }

class MonthlyPaymentReminder {
  const MonthlyPaymentReminder({
    required this.id,
    required this.source,
    required this.title,
    required this.reminderDay,
    required this.status,
    this.subtitle,
    this.categoryId,
    this.subcategoryId,
    this.goalId,
  });

  final String id;
  final MonthlyReminderSource source;
  final String title;
  final String? subtitle;
  final int reminderDay;
  final MonthlyReminderStatus status;
  final String? categoryId;
  final String? subcategoryId;
  final String? goalId;
}
