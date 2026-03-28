import '../../../../core/utils/month_context.dart';
import '../entities/analytics_models.dart';
import '../entities/movement.dart';

class PaymentMethodReportService {
  const PaymentMethodReportService();

  PaymentMethodReport build({
    required List<Movement> movements,
    required DateTime referenceDate,
  }) {
    final monthContext = MonthContext.forDate(referenceDate);
    final totals = <String, double>{};

    for (final movement in movements) {
      if (movement.type != MovementType.expense) {
        continue;
      }
      if (movement.occurredOn.isBefore(monthContext.startDate) ||
          !movement.occurredOn.isBefore(monthContext.endDateExclusive)) {
        continue;
      }

      final method = movement.paymentMethod?.trim();
      final normalizedMethod =
          method == null || method.isEmpty ? 'Sin definir' : method;
      totals.update(
        normalizedMethod,
        (value) => value + movement.amount,
        ifAbsent: () => movement.amount,
      );
    }

    final totalExpense =
        totals.values.fold<double>(0, (sum, value) => sum + value);
    final items = totals.entries
        .map(
          (entry) => PaymentMethodSpend(
            name: entry.key,
            amount: entry.value,
            share: totalExpense <= 0 ? 0 : entry.value / totalExpense,
          ),
        )
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return PaymentMethodReport(totalExpense: totalExpense, items: items);
  }
}
