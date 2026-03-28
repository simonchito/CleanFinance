import '../../../../core/utils/month_context.dart';
import '../entities/analytics_models.dart';
import '../entities/movement.dart';
import '../entities/savings_goal.dart';

class SavingsGoalReportService {
  const SavingsGoalReportService();

  List<SavingsGoalForecast> build({
    required List<SavingsGoalProgress> goals,
    required List<Movement> savingsMovements,
    required DateTime referenceDate,
  }) {
    final goalMovements = <String, List<Movement>>{};
    final currentMonth = MonthContext.forDate(referenceDate);

    for (final movement in savingsMovements) {
      if (movement.type != MovementType.saving || movement.goalId == null) {
        continue;
      }
      goalMovements.putIfAbsent(movement.goalId!, () => []).add(movement);
    }

    final forecasts = goals.map((progress) {
      final movementsForGoal = goalMovements[progress.goal.id] ?? const <Movement>[];
      final activeMonths = movementsForGoal
          .map((movement) => MonthContext.monthKeyFor(movement.occurredOn))
          .toSet()
          .length;
      final averageMonthlyContribution = (activeMonths == 0
              ? 0
              : progress.savedAmount / activeMonths)
          .toDouble();
      final currentMonthContribution = movementsForGoal
          .where(
            (movement) =>
                !movement.occurredOn.isBefore(currentMonth.startDate) &&
                movement.occurredOn.isBefore(currentMonth.endDateExclusive),
          )
          .fold<double>(0, (sum, movement) => sum + movement.amount);
      final remainingAmount =
          (progress.goal.targetAmount - progress.savedAmount)
              .clamp(0, progress.goal.targetAmount)
              .toDouble();

      return SavingsGoalForecast(
        progress: progress,
        averageMonthlyContribution: averageMonthlyContribution,
        currentMonthContribution: currentMonthContribution,
        estimatedCompletionDate: _estimateCompletionDate(
          referenceDate: referenceDate,
          remainingAmount: remainingAmount,
          averageMonthlyContribution: averageMonthlyContribution,
        ),
      );
    }).toList()
      ..sort((a, b) => b.progress.progress.compareTo(a.progress.progress));

    return forecasts;
  }

  DateTime? _estimateCompletionDate({
    required DateTime referenceDate,
    required double remainingAmount,
    required double averageMonthlyContribution,
  }) {
    if (remainingAmount <= 0) {
      return referenceDate;
    }
    if (averageMonthlyContribution <= 0) {
      return null;
    }

    final monthsNeeded = (remainingAmount / averageMonthlyContribution).ceil();
    final tentative = DateTime(
      referenceDate.year,
      referenceDate.month + monthsNeeded,
      1,
    );
    final targetDay = referenceDate.day;
    final lastDayOfTargetMonth = DateTime(
      tentative.year,
      tentative.month + 1,
      0,
    ).day;

    return DateTime(
      tentative.year,
      tentative.month,
      targetDay > lastDayOfTargetMonth ? lastDayOfTargetMonth : targetDay,
    );
  }
}
