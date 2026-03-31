enum MonthlyPaymentReminderStatus { due }

class MonthlyPaymentReminder {
  const MonthlyPaymentReminder({
    required this.sourceMovementId,
    required this.title,
    required this.categoryId,
    required this.amount,
    required this.reminderDay,
    required this.status,
    required this.lastRecordedOn,
    this.categoryName,
    this.note,
    this.paymentMethod,
    this.subcategoryId,
  });

  final String sourceMovementId;
  final String title;
  final String categoryId;
  final String? subcategoryId;
  final String? categoryName;
  final String? note;
  final String? paymentMethod;
  final double amount;
  final int reminderDay;
  final MonthlyPaymentReminderStatus status;
  final DateTime lastRecordedOn;
}
