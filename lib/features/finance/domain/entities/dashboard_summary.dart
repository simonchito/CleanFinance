class DashboardSummary {
  const DashboardSummary({
    required this.availableBalance,
    required this.incomeMonth,
    required this.expenseMonth,
    required this.savingsAccumulated,
    required this.savingsMonth,
    required this.currentMonthMovementCount,
  });

  final double availableBalance;
  final double incomeMonth;
  final double expenseMonth;
  final double savingsAccumulated;
  final double savingsMonth;
  final int currentMonthMovementCount;
}
