import '../entities/analytics_models.dart';

class SpendingPaceService {
  const SpendingPaceService();

  SpendingPaceReport build({
    required DateTime referenceDate,
    required CashflowSnapshot cashflow,
  }) {
    final daysInMonth = DateTime(
      referenceDate.year,
      referenceDate.month + 1,
      0,
    ).day;
    final daysElapsed = referenceDate.day.clamp(1, daysInMonth);
    final safeSpendingCapacity =
        (cashflow.income - cashflow.savings).clamp(0, double.infinity).toDouble();
    final expectedSpendToDate = safeSpendingCapacity * (daysElapsed / daysInMonth);
    final averageDailySpend = cashflow.expense / daysElapsed;
    final projectedEndOfMonth = averageDailySpend * daysInMonth;
    final projectedNetBalance =
        cashflow.income - cashflow.savings - projectedEndOfMonth;

    final status = switch ((safeSpendingCapacity, projectedNetBalance)) {
      (_, final projectedNet) when projectedNet < 0 => SpendingPaceStatus.risk,
      (final capacity, _) when capacity > 0 &&
              projectedEndOfMonth > capacity * 0.92 =>
        SpendingPaceStatus.watch,
      _ => SpendingPaceStatus.onTrack,
    };

    return SpendingPaceReport(
      spentSoFar: cashflow.expense,
      expectedSpendToDate: expectedSpendToDate,
      projectedEndOfMonth: projectedEndOfMonth,
      averageDailySpend: averageDailySpend,
      daysElapsed: daysElapsed,
      daysInMonth: daysInMonth,
      safeSpendingCapacity: safeSpendingCapacity,
      projectedNetBalance: projectedNetBalance,
      status: status,
    );
  }
}
