import 'package:clean_finance/features/finance/domain/entities/monthly_payment_reminder.dart';
import 'package:clean_finance/features/finance/domain/entities/movement.dart';
import 'package:clean_finance/features/finance/domain/services/monthly_payment_reminder_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = MonthlyPaymentReminderService();

  Movement expense({
    required String id,
    required DateTime occurredOn,
    required bool monthlyReminderEnabled,
    int? reminderDay,
    double amount = 2500,
    String note = 'Internet',
  }) {
    return Movement(
      id: id,
      type: MovementType.expense,
      amount: amount,
      categoryId: 'services',
      occurredOn: occurredOn,
      note: note,
      categoryName: 'Servicios',
      monthlyReminderEnabled: monthlyReminderEnabled,
      reminderDay: reminderDay,
      createdAt: occurredOn,
      updatedAt: occurredOn,
    );
  }

  test('marks reminder as due when reminder day passed and month has no payment', () {
    final reminders = service.buildDueReminders(
      expenseMovements: [
        expense(
          id: 'jan-internet',
          occurredOn: DateTime(2026, 1, 7),
          monthlyReminderEnabled: true,
          reminderDay: 5,
        ),
      ],
      referenceDate: DateTime(2026, 3, 20),
    );

    expect(reminders, hasLength(1));
    expect(reminders.single.title, 'Internet');
    expect(reminders.single.reminderDay, 5);
    expect(reminders.single.status, MonthlyPaymentReminderStatus.due);
  });

  test('does not mark reminder as due before the configured day', () {
    final reminders = service.buildDueReminders(
      expenseMovements: [
        expense(
          id: 'internet-template',
          occurredOn: DateTime(2026, 2, 7),
          monthlyReminderEnabled: true,
          reminderDay: 25,
        ),
      ],
      referenceDate: DateTime(2026, 3, 20),
    );

    expect(reminders, isEmpty);
  });

  test('treats a matching payment entered this month as already paid', () {
    final reminders = service.buildDueReminders(
      expenseMovements: [
        expense(
          id: 'feb-internet',
          occurredOn: DateTime(2026, 2, 7),
          monthlyReminderEnabled: true,
          reminderDay: 5,
        ),
        expense(
          id: 'mar-internet',
          occurredOn: DateTime(2026, 3, 8),
          monthlyReminderEnabled: false,
          reminderDay: null,
        ),
      ],
      referenceDate: DateTime(2026, 3, 20),
    );

    expect(reminders, isEmpty);
  });

  test('uses the latest movement state so disabling recurrence stops future reminders', () {
    final reminders = service.buildDueReminders(
      expenseMovements: [
        expense(
          id: 'jan-gym',
          occurredOn: DateTime(2026, 1, 4),
          monthlyReminderEnabled: true,
          reminderDay: 3,
          note: 'Gym',
        ),
        expense(
          id: 'feb-gym',
          occurredOn: DateTime(2026, 2, 4),
          monthlyReminderEnabled: false,
          reminderDay: null,
          note: 'Gym',
        ),
      ],
      referenceDate: DateTime(2026, 3, 20),
    );

    expect(reminders, isEmpty);
  });
}
