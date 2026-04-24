class UnassignedSavingsSummary {
  const UnassignedSavingsSummary({
    required this.totalAmount,
    required this.movementsCount,
    this.lastContributionDate,
  });

  final double totalAmount;
  final int movementsCount;
  final DateTime? lastContributionDate;

  bool get hasSavings => totalAmount > 0;
}

class SavingsSummary {
  const SavingsSummary({
    required this.totalSavedAmount,
    required this.goalsSavedAmount,
    required this.totalGoalTargetAmount,
    required this.goalsCount,
    required this.completedGoalsCount,
    required this.unassignedSavings,
  });

  final double totalSavedAmount;
  final double goalsSavedAmount;
  final double totalGoalTargetAmount;
  final int goalsCount;
  final int completedGoalsCount;
  final UnassignedSavingsSummary unassignedSavings;

  bool get hasAnySavingsData => goalsCount > 0 || unassignedSavings.hasSavings;
}
