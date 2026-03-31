import '../../../../core/utils/month_context.dart';
import '../entities/monthly_payment_reminder.dart';
import '../entities/movement.dart';

class MonthlyPaymentReminderService {
  const MonthlyPaymentReminderService();

  List<MonthlyPaymentReminder> buildDueReminders({
    required List<Movement> expenseMovements,
    required DateTime referenceDate,
  }) {
    final visibleExpenses = expenseMovements
        .where(
          (movement) =>
              movement.type == MovementType.expense &&
              !movement.occurredOn.isAfter(referenceDate),
        )
        .toList();

    final groupedByRecurringKey = <String, List<Movement>>{};
    for (final movement in visibleExpenses) {
      groupedByRecurringKey
          .putIfAbsent(_recurringKeyFor(movement), () => [])
          .add(movement);
    }

    final currentMonth = MonthContext.forDate(referenceDate);
    final reminders = <MonthlyPaymentReminder>[];

    for (final group in groupedByRecurringKey.values) {
      group.sort((a, b) {
        final occurredComparison = b.occurredOn.compareTo(a.occurredOn);
        if (occurredComparison != 0) {
          return occurredComparison;
        }

        return b.updatedAt.compareTo(a.updatedAt);
      });

      final latest = group.first;
      final reminderDay = latest.reminderDay;
      if (!latest.monthlyReminderEnabled ||
          reminderDay == null ||
          reminderDay < 1 ||
          reminderDay > 31 ||
          referenceDate.day < reminderDay) {
        continue;
      }

      final hasPaymentThisMonth = group.any(
        (movement) =>
            !movement.occurredOn.isBefore(currentMonth.startDate) &&
            !movement.occurredOn.isAfter(referenceDate),
      );
      if (hasPaymentThisMonth) {
        continue;
      }

      reminders.add(
        MonthlyPaymentReminder(
          sourceMovementId: latest.id,
          title: _titleFor(latest),
          categoryId: latest.categoryId,
          subcategoryId: latest.subcategoryId,
          categoryName: latest.categoryName,
          note: latest.note,
          paymentMethod: latest.paymentMethod,
          amount: latest.amount,
          reminderDay: reminderDay,
          status: MonthlyPaymentReminderStatus.due,
          lastRecordedOn: latest.occurredOn,
        ),
      );
    }

    reminders.sort((a, b) {
      final dayComparison = a.reminderDay.compareTo(b.reminderDay);
      if (dayComparison != 0) {
        return dayComparison;
      }

      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });

    return reminders;
  }

  String _recurringKeyFor(Movement movement) {
    final normalizedNote = _normalize(movement.note);
    final normalizedPaymentMethod = _normalize(movement.paymentMethod);
    final normalizedCategory = movement.categoryId.trim().toLowerCase();
    final normalizedSubcategory =
        movement.subcategoryId?.trim().toLowerCase() ?? '';
    final normalizedAmount = movement.amount.truncate();

    return [
      normalizedCategory,
      normalizedSubcategory,
      normalizedNote,
      normalizedPaymentMethod,
      normalizedAmount,
    ].join('|');
  }

  String _titleFor(Movement movement) {
    final note = movement.note?.trim();
    if (note != null && note.isNotEmpty) {
      return note;
    }

    final categoryName = movement.categoryName?.trim();
    if (categoryName != null && categoryName.isNotEmpty) {
      return categoryName;
    }

    return 'Pago recurrente';
  }

  String _normalize(String? value) {
    return value?.trim().toLowerCase() ?? '';
  }
}
