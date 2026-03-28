import '../../../../core/utils/month_context.dart';
import '../entities/analytics_models.dart';
import '../entities/movement.dart';

class CashflowSnapshotService {
  const CashflowSnapshotService();

  CashflowSnapshot build({
    required List<Movement> movements,
    required DateTime referenceDate,
  }) {
    final currentMonth = MonthContext.forDate(referenceDate);
    final previousMonth = currentMonth.previous();

    var income = 0.0;
    var expense = 0.0;
    var savings = 0.0;
    var previousNetBalance = 0.0;

    for (final movement in movements) {
      if (movement.occurredOn.isBefore(previousMonth.startDate) ||
          !movement.occurredOn.isBefore(currentMonth.endDateExclusive)) {
        continue;
      }

      final isCurrent = !movement.occurredOn.isBefore(currentMonth.startDate);
      final amount = movement.amount;

      if (isCurrent) {
        switch (movement.type) {
          case MovementType.income:
            income += amount;
          case MovementType.expense:
            expense += amount;
          case MovementType.saving:
            savings += amount;
        }
      } else {
        switch (movement.type) {
          case MovementType.income:
            previousNetBalance += amount;
          case MovementType.expense:
          case MovementType.saving:
            previousNetBalance -= amount;
        }
      }
    }

    return CashflowSnapshot(
      income: income,
      expense: expense,
      savings: savings,
      netBalance: income - expense - savings,
      previousNetBalance: previousNetBalance,
    );
  }
}
