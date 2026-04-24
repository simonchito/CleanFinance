import '../../../../core/utils/month_context.dart';
import '../entities/analytics_models.dart';

class SpendingPaceService {
  const SpendingPaceService();

  SpendingPaceReport build({
    required DateTime referenceDate,
    required CashflowSnapshot cashflow,
  }) {
    final monthContext = MonthContext.forDate(referenceDate);
    final safeSpendingCapacity = (cashflow.income - cashflow.savings)
        .clamp(0, double.infinity)
        .toDouble();
    final expectedSpendToDate = safeSpendingCapacity *
        (monthContext.daysElapsed / monthContext.totalDaysInMonth);
    final averageDailySpend = cashflow.expense / monthContext.daysElapsed;
    final projectedEndOfMonth =
        averageDailySpend * monthContext.totalDaysInMonth;
    final projectedNetBalance =
        cashflow.income - cashflow.savings - projectedEndOfMonth;

    final status = switch ((safeSpendingCapacity, projectedNetBalance)) {
      (_, final projectedNet) when projectedNet < 0 => SpendingPaceStatus.risk,
      (final capacity, _)
          when capacity > 0 && projectedEndOfMonth > capacity * 0.92 =>
        SpendingPaceStatus.watch,
      _ => SpendingPaceStatus.onTrack,
    };

    return SpendingPaceReport(
      spentSoFar: cashflow.expense,
      expectedSpendToDate: expectedSpendToDate,
      projectedEndOfMonth: projectedEndOfMonth,
      averageDailySpend: averageDailySpend,
      daysElapsed: monthContext.daysElapsed,
      daysInMonth: monthContext.totalDaysInMonth,
      safeSpendingCapacity: safeSpendingCapacity,
      projectedNetBalance: projectedNetBalance,
      status: status,
    );
  }
}
