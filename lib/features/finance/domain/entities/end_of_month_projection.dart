enum ProjectionRiskLevel { low, medium, high }
enum ProjectionInterpretationType {
  insufficientActivity,
  positiveBalance,
  tightMargin,
  deficitRisk,
}

class EndOfMonthProjection {
  const EndOfMonthProjection({
    required this.incomeSoFar,
    required this.expenseSoFar,
    required this.avgDailyExpense,
    required this.daysElapsed,
    required this.totalDaysInMonth,
    required this.daysRemaining,
    required this.projectedExpense,
    required this.projectedNet,
    required this.riskLevel,
    required this.interpretationType,
  });

  final double incomeSoFar;
  final double expenseSoFar;
  final double avgDailyExpense;
  final int daysElapsed;
  final int totalDaysInMonth;
  final int daysRemaining;
  final double projectedExpense;
  final double projectedNet;
  final ProjectionRiskLevel riskLevel;
  final ProjectionInterpretationType interpretationType;
}
